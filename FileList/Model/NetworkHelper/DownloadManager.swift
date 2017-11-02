//
//  FileDownloader.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import Foundation
import Swime

protocol DownloadmanagerDelegate:class {
//    func didCompleteTask(with success:Bool)
    func didCompleteTask(with success:Bool,location:URL?)
}

final class DownloadManager:NSObject,URLSessionTaskDelegate,URLSessionDownloadDelegate{
    
    weak var delegate: DownloadmanagerDelegate!
    var downloadCompletionBlock:DownloadCompletionHandler!
    var bytesRecieved:Int64 = 0
    var totalBytesRecieved:Int64 = 1 // to avoid exception devide by 0
    var config:URLSessionConfiguration!
    var onProgress : ProgressHandler? {
        didSet {
            if onProgress != nil {
                let _ = urlSession()
            }
        }
    }
    
    func urlSession()->URLSession{
        return URLSession(configuration: self.config, delegate: self, delegateQueue: OperationQueue())
    }

    init(with configuration:URLSessionConfiguration) {
        self.config = configuration
    }
    
  /*  static let shared = FileDownloader()
    private var configuration:URLSessionConfiguration!
    private var url:URL!
    
    private init(){
        
    }
    
    func initiateConfiguration(with url:String, type:TaskType){
        
        switch type {
        case .data:
            self.configuration = URLSessionConfiguration.default
        case .download,.upload:
            self.configuration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier!)
        }
        
        self.url = URL.init(string: url)!
    }
    */
    func downloadFile(with url:String, delegate:DownloadmanagerDelegate){
        self.delegate = delegate
        let downloadTask = self.urlSession().downloadTask(with: URL.init(string: url)!)
        downloadTask.resume()
    }
    
    deinit {
    }
}


//This extesnion implements the methods declared in URLSessionDownloadDelegate
extension DownloadManager{
    
    // This method to track the progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesWritten > 0  {
            calculateProgress(session: session, completionHandler: onProgress!)
        }
    }
    
    
    private func calculateProgress(session : URLSession, completionHandler : @escaping (Float) -> ()) {
        session.getTasksWithCompletionHandler { (tasks, uploads, downloads) in
            let progress = downloads.map({ (task) -> Float in
                if task.countOfBytesExpectedToReceive > 0 {
                    return Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
                    
                } else {
                    return 0.0
                }
            })
            completionHandler(progress.reduce(0.0, +))
        }
    }

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        weak var weakself = self
        do{
            var data:Data? = try Data.init(contentsOf: location)
            
            let mimeType = Swime.mimeType(data: data!)
            
            if let _ = mimeType {
                weakself?.delegate?.didCompleteTask(with: true, location: location)
            }else{
                weakself?.delegate?.didCompleteTask(with: false,location: location)
            }
            data = nil
            
        }catch{
            print(error)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.delegate?.didCompleteTask(with: false,location:nil)
        debugPrint("Task completed: \(task), error: \(String(describing: error))")
    }
}

