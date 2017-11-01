//
//  FIleListViewModel.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 29/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit
import CoreData

private let __no_of_sections__ = 1

class FileViewModel {
     static let shared = FileViewModel()
    // using map
    lazy var files:[File]? = {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = CoreData.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "File")
        do {
            let arrFiles = try context.fetch(fetchRequest)
            return arrFiles as? [File]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }()
    
    lazy var selectedFiles:[File]? = {
        return [File]()
    }()
    
    lazy var dilesToDelete:[File]? = {
        return [File]()
    }()
    
    private init(){
        
    }

    internal static func numberOfItems(in section:Int)->Int{
        return FileViewModel.shared.files!.count
    }
    
    internal static func item(at indexPath:IndexPath)->File{
        return FileViewModel.shared.files![indexPath.row]
    }
    
    internal static func numberOfSections()->Int{
        return __no_of_sections__
    }
    
    internal static func selectItem(at index:NSInteger) -> Bool{
        let file:File = FileViewModel.shared.files![index]
        var success:Bool = true
        
        if (FileViewModel.shared.selectedFiles?.contains(file))! {
            let selectedIndex = FileViewModel.shared.selectedFiles?.index(of: file)
            FileViewModel.shared.selectedFiles?.remove(at: selectedIndex!)
        }else{
            if (file.isDownloaded?.boolValue)!{
                FileViewModel.shared.selectedFiles?.append(file)
            }else{
                success = false
            }
        }
        
        return success
    }
    
    internal static func cancelSelection(){
        
        FileViewModel.shared.selectedFiles?.removeAll()
    }
    
    internal static func deleteSelectedFiles(){
        let sharedSelf = FileViewModel.shared
        let selectedFiles:[File] = sharedSelf.selectedFiles!
        
        for aFile in selectedFiles {
            if(sharedSelf.files!.contains(aFile)){
                let indexToRemove = sharedSelf.files!.index(of: aFile)
                sharedSelf.files!.remove(at: indexToRemove!)
            }
        }
    }
    
    internal static func shareSelectedFiles(){
    }
    
    internal static func deleteAll(){
        FileViewModel.shared.files?.removeAll()
    }
    
    internal static func add(with name:String,and url:String){
        FileViewModel.shared.files?.append(CoreData.shared.addItem(with: name, and: url))
    }
}
