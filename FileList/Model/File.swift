//
//  File.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 29/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit
import CoreData
import Swime
@objc(File)
class File: NSManagedObject {
    @NSManaged var name:String?
    @NSManaged var url:String?
    @NSManaged var path:URL?
    @NSManaged var fileExtension:String?
    @NSManaged var time:NSNumber?
    @NSManaged var isDownloaded:NSNumber?
    var thumbnail:UIImage?
    
    lazy var mimeType:MimeType? = {
        var data:Data?
        do{
            if let tempPath = self.path{
                var fileURLPath = Utility.url(for: self.name!, with: self.fileExtension!)
                data = try Data.init(contentsOf:fileURLPath )
                if let fileData = data{
                    self.mimeType = Swime.mimeType(data:fileData)
                    data = nil
                    return self.mimeType
                }
            }
        }catch{
            print(error)
        }
        
        data = nil
        return nil
    }()
    
}
