//
//  FileListHelper.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit

import Swime
import AVKit
import AVFoundation
import Foundation

class FileHelper{
    
    
    
    static func timeForFile(at path:String)->CMTime{
        
        if FileManager.default.fileExists(atPath: path) {
            let asset:AVAsset = AVAsset.init(url: URL.init(string: path)!)
            let time:CMTime = asset.duration
            print(time)
            return time
        }
        
        return CMTime.init()
    }
    
    static func write(file to:File){
        
    }
}

enum FileType:String {
    case doc = "doc"
    case image = "image"
    case video = "video"
}

class FileListHelper: NSObject {
    static let shared = FileListHelper()
    
    
    private override init() {
        // made private to avoid a different instance of it.
    }
}
