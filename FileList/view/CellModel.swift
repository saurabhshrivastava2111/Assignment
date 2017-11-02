//
//  CellModel.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 29/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import Swime
import Foundation
import UIKit
import CoreData

class CellModel:DownloadmanagerDelegate {
    
    private var file:File{
        didSet(newValue){
            
        }
    }
    var uiRefreshBlock: UIRefreshBlock!
    var downloadmanager:DownloadManager?
    var onProgress : ProgressHandler?
    var backgroundTask:UIBackgroundTaskIdentifier!  = UIBackgroundTaskInvalid
     init(with file:File){
        self.file = file
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackGround), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc private func didEnterBackGround(){
        self.registerBackgroundtask()
    }
    
    func registerBackgroundtask(){
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            self?.endBackGroundTask()
        })
    }
    
    func endBackGroundTask(){
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    internal func getThumbnail()->UIImage?{
        
        return self.file.thumbnail
    }
    
    internal func getFile()->File{
        return self.file
    }
    
    internal func thumbnail()->(UIImage?,Bool){
        if let thumbnail = self.file.thumbnail {
            return (thumbnail,false)
        }else{
            if let tempMimeype = self.file.mimeType{
                return CellModalHelper.thumbNail(mimeType: tempMimeype,name: self.file.name!)
            }
        }
        return (nil,false)
    }
    
    internal func isDownloaded()->Bool{
        return (self.file.isDownloaded?.boolValue)!
    }
    
    
    public func downLoad(with refreshBlock:@escaping UIRefreshBlock){
        self.downloadmanager = DownloadManager.init(with: .default)
        self.downloadmanager?.onProgress = self.onProgress
        self.downloadmanager?.downloadFile(with: self.file.url!, delegate: self)
        self.uiRefreshBlock = refreshBlock
    }
    
    public func cancelDownload(){
        self.downloadmanager?.urlSession().dataTask(with:URL.init(string: self.file.url!)!).suspend()
    }
    
    
    func didCompleteTask(with success:Bool,location:URL?) {
        weak var weakSelf = self
        if success {
            if let tempLocation = location{
                let mimeType:MimeType? = CellModalHelper.moveFile(for: self.file.name!, from: tempLocation)
                weakSelf?.downloadmanager?.urlSession().finishTasksAndInvalidate()
                CellModalHelper.updateFile(file: &file, with: mimeType!, and: (weakSelf?.file.name!)!)
                weakSelf?.downloadmanager = nil
                self.uiRefreshBlock(true,file.path?.path)
            }else{
                self.uiRefreshBlock(false,nil)
            }
        }else{
            self.uiRefreshBlock(false,nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

final class CellModalHelper{
    
    static func moveFile(for name:String, from source:URL)->MimeType?{
        var mimeType:MimeType?
        do{
            var data:Data? = try Data.init(contentsOf: source)
            
             mimeType = Swime.mimeType(data: data!)
            if let tempMimeTye = mimeType {
                let destinationURL = Utility.url(mimeType: tempMimeTye,name: name)
                try data?.write(to: destinationURL)
                try? FileManager.default.removeItem(at: source)
                return tempMimeTye
            }
            data = nil
            
        }catch{
            print(error)
            return mimeType
        }
        
        return nil
    }
    
    
    static func thumbNail(mimeType:MimeType?,name:String)->(UIImage?,Bool){
        let fileURLPath = Utility.url(for: name, with: (mimeType?.ext)!)
        var data = try? Data.init(contentsOf:fileURLPath )

        if let tempMimeType = mimeType {
            switch tempMimeType.type {
            case .jpg,.png,.gif:
                if let image = UIImage.init(data: data!, scale: 1.0){
                    data = nil
                    return (Utility.generateThumbnail(for: image, with: CGSize.init(width: 100.0, height: 100.0)),false)
                }
            case .pdf,.rtf:
                break
            // generate thumbnail for PDf
            case .mov,.mp4,.m4v:
                // generate thumbnail for Video
                
                return (Utility.generateVideoThumbnail(with: fileURLPath),true)
                
            default: break
                
            }
        }
        return (UIImage.init(named: "Default")!,false)
    }
    
    static func updateFile( file:inout File,with mimeType:MimeType,and name:String){
        file.path = Utility.url(mimeType: mimeType,name:(file.name)!)
        file.fileExtension = mimeType.ext
        file.isDownloaded = NSNumber.init(value: true)
    }

}
