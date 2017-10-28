//
//  FileListHelper.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit

import Swime
struct File {
    var name: String
    var path:String
    var mimeType:MimeType!
}

class FileListHelper: NSObject, DownloadmanagerDelegate {

    static let shared = FileListHelper()
    
    var uiRefreshBlock: UIRefreshBlock!
    
    var onProgress : ProgressHandler?{
        didSet {
            if onProgress != nil {
                DownloadManager.shared.onProgress = onProgress
            }
        }
    }
    
    private override init() {
        // made private to avoid a different instance of it.
    }
    
    
    func startDownLoad(with urls:[String],refreshBlock:@escaping UIRefreshBlock){
        DownloadManager.shared.downloadFile(with: urls, delegate: self)
        self.uiRefreshBlock = refreshBlock
    }
    
    
    
    func getFiles()->[File]{
        
    var files = [File]()
        
        let documentDirectoryPath = Utility.documentDirectoryPath()
        do{
            let array = try FileManager.default.contentsOfDirectory(atPath: documentDirectoryPath)
            
            for anItem in array {
                
                let path = documentDirectoryPath + "/" + anItem
                
                var data:Data? = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
                
                let mimeType = Swime.mimeType(data: data!)
                
                let file = File.init(name: anItem, path: path,mimeType: mimeType)
                
                data = nil
                
                files.append(file)
            }
        }catch{
            print(error)
        }
        return files
    }
    
    
    func refreshContent()->[File]{
        return [File]()
    }
    
    
    func clearAllContent(){
        let documentDirPath = Utility.documentDirectoryPath()
        
        let fileManager = FileManager.default
        
        let array = try? fileManager.contentsOfDirectory(atPath: documentDirPath)
        
        for anItem in array! {
            let path = documentDirPath + "/"+anItem
            if fileManager.fileExists(atPath: documentDirPath + "/"+anItem) {
               try? fileManager.removeItem(atPath: path)
            }
        }
    }
    
    
    func didCompleteTask(with success:Bool) {
        
        if success {
          self.uiRefreshBlock(true)
        }else{
            self.uiRefreshBlock(false)
        }
    }
}
