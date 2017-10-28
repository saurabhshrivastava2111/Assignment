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
    
    static func url(mimeType:MimeType)->URL{
        
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let count = try? FileManager.default.contentsOfDirectory(atPath: Utility.documentDirectoryPath()).count
        
        url = url.appendingPathComponent(Bundle.main.bundleIdentifier! + "\(count!)"+"."+mimeType.ext)
        
        
        return url
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
    static func generateVideoThumbnail(with path:String) -> UIImage{
        do {
            let asset = AVURLAsset.init(url: URL.init(fileURLWithPath: path))
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 100), actualTime: nil)
            let uiImage = UIImage.init(cgImage: cgImage)
            
            return uiImage
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
        return UIImage.init(named: "Default")!
    }

}
