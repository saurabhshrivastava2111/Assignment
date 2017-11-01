//
//  FilePreviewModel.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 01/11/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit

class FilePreviewModel {
     var file:File!
    
    init(with file:File){
        self.file = file
    }
    
    lazy var isDownloaded:Bool = {
       return self.file.isDownloaded!.boolValue
    }()
    
    
    lazy var url:URL = {
       return URL.init(string: self.file.url!)!
        }()
    lazy var filePath:URL? = {
        if self.isDownloaded {
            return self.file.path!
        }
        return nil
    }()
    
    lazy var isImage:Bool = {
        if self.isDownloaded{
            return Utility.isImage(mimeType: self.file.mimeType!)
        }else{
            return false
        }
    }()
}
