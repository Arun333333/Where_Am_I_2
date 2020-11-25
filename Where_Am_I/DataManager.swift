//
//  DataManager.swift
//  Where_Am_I
//
//  Created by John Poku on 2020-11-20.
//  Copyright © 2020 MacsSuck. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Where_Am_I")
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

    func save () {
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
    
    func location(latitude: Double, longitude: Double, mailingAddress:String?, time:Date) -> Location {
        let loc = Location(context: persistentContainer.viewContext)
        loc.latitude  = latitude
        loc.longitude = longitude
        loc.address = mailingAddress ?? ""
        loc.time = time
        return loc
    }
    
    func locations() -> [Location] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Location.time), ascending: false)
        request.sortDescriptors = [sort]
        var fetchedLocations: [Location] = []
        do {
            fetchedLocations = try persistentContainer.viewContext.fetch(request)
        }
        catch {
            print("Error fetching locations")
        }
        return fetchedLocations
    }
}

extension Location {
    var locationString : String! {
        get {
            return String(format: "(lat:%0.3f, lon:%0.3f)", latitude, longitude)
        }
    }
    
    var coordinate : CLLocationCoordinate2D! {
        get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
    }
    
    var location : CLLocation! {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
}

