//
//  Constant.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit

let imagePath   = ""
let videoPath   = ""
let docPath     = ""

let settingsURLKey = "url_preference"

var baseURL: String{
    if let urlString = UserDefaults.standard.string(forKey: settingsURLKey){
        return urlString
    }
    return "https://clientarea.indegene.com/sharemax/retrieve.jsp"
}

let fileListCellReuseIdentifier = "FileListReuseIdentifier"
let fileGridCellReuseIdentifier = "FileGridReuseIdentifier"

let documentVCSegueIdentifier = "DocumentVCSegueIdentifier"


enum TaskType: String {
    case download   =   "download"
    case upload     =   "upload"
    case data       =   "data"
}

typealias ProgressHandler = (Float) -> ()

typealias UIRefreshBlock = (Bool)->Void


var urlCollection:[String:String] = ["Policy":"id=93d64af9-d43e-4d83-8786-f20d7c78fe17",
                                     "Apple":"id=93ac5b8a-69c1-44cd-803d-81701176ba3e",
                                     "Keyboard":"id=23d93642-0b6c-40fd-9ca2-d4b5d3a930c8",
                                     "Dummy":"id=fd7b185a-58e7-4e1f-9870-654736d9fa2d",
                                     "Dummy2":"id=eeda377a-aecb-4a22-8180-4214f5983967",
                                     "WWDC":"id=462688db-ad8d-405d-a823-bb9824a2c912"]
