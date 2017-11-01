//
//  CoreData.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 30/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    static let shared = CoreData()
    private init(){
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FileList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete(items files:[File]){
        
        }
    
    func addItem(with name:String,and url:String ){
        let managedObjectContext = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "File",
                                                in: self.persistentContainer.viewContext)!
        let file = File.init(entity: entity, insertInto: managedObjectContext)
        file.name = name
        file.url = url
        self.saveContext()
    }
}
