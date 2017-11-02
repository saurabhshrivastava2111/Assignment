//
//  Utility.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 14/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import Foundation
import Swime
import AVFoundation
import UIKit

class Utility: NSObject {
    
    static func url(mimeType:MimeType,name:String)->URL{
        
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = name.appending("."+mimeType.ext)

        url.appendPathComponent(fileName)
        
        print(url)
        
        return url
    }
    
    
    static func plistURL()->URL{
        var url = FileManager.default.urls(for:.cachesDirectory, in: .userDomainMask).first!
        url = url.appendingPathComponent("Files.plist")
        return url
    }
    
    static func url(for name:String,with pathExtension:String)->URL{
        var path:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        path  = path.appendingPathComponent(name+"."+pathExtension)
        return path

    }
    
    static func documentDirectoryPath()->String{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let docDirectoryPath = paths.first{
            return docDirectoryPath
        }
        
        return ""// return empty string if document directory path is null
    }
    
    
    static func isImage(mimeType:MimeType)->Bool{
        var isImage:Bool
        switch mimeType.type {
        case .jpg,.png,.gif:
            isImage = true
        default:
            isImage = false
        }
        return isImage
    }
    
    
    // This method generates thumbnail from UIIMage
    
    static func generateThumbnail(for image:UIImage, with size:CGSize)-> UIImage{
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    
    // This method generates thumbnail from the Video
    static func generateVideoThumbnail(with url:URL) -> UIImage{
        do {
            let asset = AVURLAsset.init(url: url)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(30, 50), actualTime: nil)
            let uiImage = UIImage.init(cgImage: cgImage)
            
            return uiImage
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
        return UIImage.init(named: "Default")!
    }

    
//    static func write(files:[File]){
//        
//        let plistFiles:NSMutableArray = NSMutableArray.init(contentsOf: Utility.plistURL())!
//        
//        for aFile in files {
//            let predicate = NSPredicate.init(format: "SELF.name=%@", aFile.name!)
//            
//            let filteredArray = plistFiles.filtered(using: predicate)
//            
//            
//            let dictFile = [keyName:aFile.name,
//                            keyPath:aFile.path,
//                            keyURL:aFile.url,
//                            keyExtension:aFile.mimeType.ext,
//                            keyIsDownloaded:aFile.isDownloaded,
//                            keyTime:aFile.time?.seconds ?? 0.0] as [String : Any]
//
//            
//            if filteredArray.count > 0{
//                plistFiles.replaceObject(at: plistFiles.index(of: filteredArray.first ), with: dictFile)
//            }else{
//                plistFiles.add(dictFile)
//            }
//        }
//        
//        plistFiles.write(to: Utility.plistURL(), atomically: true)
//        
//    }
}
