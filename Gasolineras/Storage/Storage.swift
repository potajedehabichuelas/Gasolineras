//
//  Storage.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 19/01/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit
import CoreData

//For filter configuration
private let STORAGE_DEFAULT_SETTINGS : String = "defaultSettings";

//Main folder name
private let STORAGE_MAIN_FOLDER_NAME : String = "PetrolStations";

private let COUNTRY_STATIONS_ENTITY : String = "StationsXCountry";
private let STATIONS_ENTITY : String = "PetrolStation";
private let STATE_ENTITY : String = "StationsXState";

class Storage: NSObject {
   
    //Singleton
    static let sharedInstance = Storage()
    
    var stations = [NSManagedObject]()
    
    var settings : NSDictionary = Storage.retrieveSettings();
    
    /*class func getCountryStationsArrayForCountry(countryName : String) -> CountryStations
    {
        /*var starredArray  = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getStarredArrayPath()) as! Array<Definition>?
        
        if starredArray != nil {
            return starredArray!
        } else {
            return Array();
        }*/
        return CountryStations.alloc()
    }
    
    class func getCountryStationsArrayForCountry(countryName : String, dictionaryFilter: NSDictionary) -> CountryStations
    {
        //Check for any filters
        
            //State filter
        
            //Distance filter
        
            //...
        
        //Retrieve data
        
        /*var starredArray  = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getStarredArrayPath()) as! Array<Definition>?
        
        if starredArray != nil {
        return starredArray!
        } else {
        return Array();
        }*/
        
        return CountryStations.alloc()
    }
    
    class func saveCountryStations(stationsForCountry: CountryStations)
    {
    //Estructura - carpeta con nombre de pais -> archivo con nombre de la provincia y ese archivo contiene
    // array de todas las gasofalineras en el municipio
    
    /*var path : String = getHistoryArrayPath()
    
    if NSKeyedArchiver.archiveRootObject(historyArray, toFile: path) {
    println("Success saving history words file")
    } else {
    println("Unable to write history words file")
    }*/
    }
    
    class func getCountryStationPathForCountry(countryName: String) -> String
    {
        // Create a filepath for archiving.
        var libraryDirectories : NSArray = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        // Get document directory from that list
        var libraryDirectory:String = libraryDirectories.objectAtIndex(0) as! String
        
        //Build full path
        var fullPath = libraryDirectory.stringByAppendingPathComponent(STORAGE_MAIN_FOLDER_NAME)
        fullPath = libraryDirectory.stringByAppendingPathComponent(countryName)
        
        //Check folder estructure exists
        var isDir : ObjCBool = false
        if !NSFileManager.defaultManager().fileExistsAtPath(fullPath, isDirectory:&isDir) {
            //Create directories
            var err: NSErrorPointer = nil
            NSFileManager.defaultManager().createDirectoryAtPath(fullPath, withIntermediateDirectories: true, attributes: nil, error: err)
        }
        
        return fullPath
    }*/
    
    class func retrieveSettings() -> NSDictionary
    {
        /*var historyArray  = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getHistoryArrayPath()) as! Array<Definition>?
        
        if historyArray != nil {
            return historyArray!
        } else {
            return Array();
        }*/
        
        return NSDictionary()
        
    }
    
    class func saveSettings(filterDict: NSDictionary)
    {
        /*var path : String = self.getStarredArrayPath()
        
        if NSKeyedArchiver.archiveRootObject(starredArray, toFile: path) {
            println("Success saving starred words file")
        } else {
            println("Unable to write starred words file")
        }*/
    }
    
    class func saveCountryStations(stationsForCountry: CountryStations)
    {
        
        print("Log: Saving to Core Data....")
        let managedContext = sharedInstance.managedObjectContext
        
        //First of all dump all the data
        do {
            try Storage.deleteEverything()
        } catch {
            print(error)
        }
        
        //Create a country entity description
        let countryEntityDescription =  NSEntityDescription.entityForName(COUNTRY_STATIONS_ENTITY,
            inManagedObjectContext: managedContext)
        
        let countryStations = StationsXCountry(entity: countryEntityDescription!,
            insertIntoManagedObjectContext: managedContext)
        
        //Set the country object
        if stationsForCountry.lastUpdated != nil {
            countryStations.lastUpdated = stationsForCountry.lastUpdated;
        }
        countryStations.notes = stationsForCountry.notes;
        
        //Entity array for states
        var statesEntities : Array<StationsXState> = Array<StationsXState>()
        
        //Create all the objects
        
        //Now we need to fill in the data for the States and PetrolStations
        
        for stationObject : Gasolinera in stationsForCountry.stationsArray {
            //Create a petrolStation entity description
            let stationEntityDescription =  NSEntityDescription.entityForName(STATIONS_ENTITY,
                inManagedObjectContext: managedContext)
            
            let station = PetrolStation(entity: stationEntityDescription!,
                insertIntoManagedObjectContext: managedContext)
            
            //Fill in the details of the station
            station.margen = stationObject.margen;
            station.rotulo = stationObject.rotulo;
            station.remision = stationObject.remision;
            station.horario = stationObject.horario;
            station.tipoVenta = stationObject.tipoVenta;
            station.longitud = stationObject.longitud;
            station.latitud = stationObject.latitud;
            station.localidad = stationObject.localidad;
            station.municipio = stationObject.municipio;
            station.provincia = stationObject.provincia;
            station.cp = stationObject.cp;
            
            //Optional Values
            if stationObject.direccion != nil {
                station.direccion = stationObject.direccion!;
            }
            
            if stationObject.biodiesel != nil {
                station.biodiesel = stationObject.biodiesel!;
            }
            
            if stationObject.bioetanol != nil {
                station.bioetanol = stationObject.bioetanol!;
            }
            
            if stationObject.bioalcohol != nil {
                station.bioalcohol = stationObject.bioalcohol!;
            }
            
            if stationObject.bioalcohol != nil {
                station.bioalcohol = stationObject.bioalcohol!;
            }
            
            if stationObject.gasNaturalComprimido != nil {
                station.gasNatural = stationObject.gasNaturalComprimido!;
            }
            
            if stationObject.gasoleoA != nil {
                station.gasoleoA = stationObject.gasoleoA!;
            }
            
            if stationObject.nuevoGasoleoA != nil {
                station.nuevoGasoleoA = stationObject.nuevoGasoleoA!;
            }
            
            if stationObject.gasolina95 != nil {
                station.gasolina95 = stationObject.gasolina95!;
            }
            
            if stationObject.gasolina98 != nil {
                station.gasolina98 = stationObject.gasolina98!;
            }
            
            if stationObject.esterMetilico != nil {
                station.esterMetilico = stationObject.esterMetilico!;
            }
            
            // Create Relationship with the state
            var isNew = true;
            for state : StationsXState in statesEntities {
                if state.stateName == stationObject.provincia {
                    //Add reference - state entity already exists
                    isNew = false;
                    station.belongsToState = state
                }
            }
            
            if isNew {
                //Create new StationsXState entity
                let stateEntityDescription =  NSEntityDescription.entityForName(STATE_ENTITY,
                    inManagedObjectContext: managedContext)
                
                let stateEntity = StationsXState(entity: stateEntityDescription!,
                    insertIntoManagedObjectContext: managedContext)
                //set name
                stateEntity.stateName = stationObject.provincia
                //Ref to country
                stateEntity.belongsToCountry = countryStations
                //Add the stations
                station.belongsToState = stateEntity
                
                //add the entity to the array to avoid recreating it
                statesEntities.append(stateEntity)
                
                print(station.provincia)
            }
            
        } // End of for
        
        //Save
        var error: NSError?
        do {
            try managedContext.save()
            print("Log: Saved to Core Data....")

        } catch let error1 as NSError {
            error = error1
            print("Log : Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func deleteEverything() throws {
        //Delete the persistent store and file
        let storeCoordinator:NSPersistentStoreCoordinator = sharedInstance.persistentStoreCoordinator
        let store:NSPersistentStore = storeCoordinator.persistentStores[0]
        let storeURL:NSURL = store.URL!
        
        try storeCoordinator.removePersistentStore(store)
        try NSFileManager.defaultManager().removeItemAtPath(storeURL.path!)
        
        //Recreate persisten store
        try sharedInstance.managedObjectContext.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: store.URL, options: nil)
    }
    
    //Returns an array of Stations for a condition given, i.e distance
    
    class func getPetrolStations(lat : Double, long : Double, range : Double) -> Array<PetrolStation>? {
        
        
        let requestStation = NSFetchRequest(entityName: STATIONS_ENTITY)
        requestStation.predicate = NSPredicate(format: "provincia LIKE 'GRANADA'")
        
        do {
            let fetchResults = try sharedInstance.managedObjectContext.executeFetchRequest(requestStation) as? [PetrolStation]
            
            if (fetchResults != nil) {
                for state : PetrolStation in fetchResults! {
                    print(state.provincia)
                    print(state.rotulo)
                }
                return fetchResults
                
            } else {
                return nil
            }
            
        } catch let fetchError as NSError {
            print("Fetching Stations Error: \(fetchError.localizedDescription)")
            return nil
        }
        
    }
    
    //Fills a Gasolinera object from a Petrol station entity from Core Data
    
    class func stationEntityToObject(stationDBObject : PetrolStation) -> Gasolinera {
        
        let estacion : Gasolinera = Gasolinera();
    
    
        return estacion;
    }
    
    //Fills a Petrol station entity from Core Data to a Gasolinera Object
    
    class func stationObjectToEntity(stationObject : Gasolinera) -> PetrolStation {
        
        let managedContext = sharedInstance.managedObjectContext
        
        let stationEntityDescription =  NSEntityDescription.entityForName(STATIONS_ENTITY,
            inManagedObjectContext: managedContext)
        
        let station = PetrolStation(entity: stationEntityDescription!,
            insertIntoManagedObjectContext: managedContext)
        

        
        return station;
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Xquare.test" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Gasolineras", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Gasolineras.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}