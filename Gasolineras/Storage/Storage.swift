//
//  Storage.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 19/01/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

//For filter configuration
private let STORAGE_DEFAULT_SETTINGS : String = "defaultSettings";

let DIESEL : String = "Diesel";
let DIESELPLUS : String = "Diesel Plus";
let GAS95 : String = "Gasolina 95";
let GAS98 : String = "Gasolina 98";

let DISTANCE5 : String = "5 Km";
let DISTANCE10 : String = "10 Km";
let DISTANCE20 : String = "20 Km";
let DISTANCE50 : String = "50 Km";

//Keys for default settings
let STORAGE_DISTANCE_SETTINGS : String = "distanceSettings";
let STORAGE_SEARCH_SETTINGS : String = "searchSettings";

let STORAGE_LAST_LAT_SETTINGS : String = "lastLatSettings";
let STORAGE_LAST_LON_SETTINGS : String = "lastLonSettings";

//Main folder name
private let STORAGE_MAIN_FOLDER_NAME : String = "PetrolStations";

private let COUNTRY_STATIONS_ENTITY : String = "StationsXCountry";
private let STATIONS_ENTITY : String = "PetrolStation";
private let STATE_ENTITY : String = "StationsXState";

class Storage: NSObject {
   
    //Singleton
    static let sharedInstance = Storage()
    
    //Variable that holds the last retrieval on stations
    var gasStations : Array<Gasolinera> = Array();
    
    var stats : Statistics = Statistics.sharedInstance;
    
    var settings : NSMutableDictionary = Storage.retrieveSettings();
    
    class func retrieveSettings() -> NSMutableDictionary
    {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(STORAGE_DEFAULT_SETTINGS) as? NSData {
            let set : NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableDictionary
            return set;
        } else {
            //No settings, recreate dictionary
            let set : NSMutableDictionary = [STORAGE_SEARCH_SETTINGS : DIESEL, STORAGE_DISTANCE_SETTINGS : DISTANCE5, STORAGE_LAST_LAT_SETTINGS : 0, STORAGE_LAST_LON_SETTINGS : 0]
            return set;
        }
    }
    

    func saveSettings(setDict: NSMutableDictionary)
    {
        //Update the class var
        Storage.sharedInstance.settings = setDict;
        //Save to defaults object
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(setDict), forKey: STORAGE_DEFAULT_SETTINGS)
    }


    class func saveCountryStations(stationsForCountry: CountryStations)
    {
        print("Log: Saving to Core Data....")

        /*Problem: CRASH when saving
        //Cause : NSManagedcontext being accessed by a diferent thread other than the one which created it
        //Solution : Because this is called from a bg thread, wrap the code in performBlock
        //Other thoughts: Tried this:
        //let managedContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        //managedContext.parentContext = moc
        //And it worked, using a different context to work with stuff, though it didn't save shit when the code was wrapped in perform block
        //Update: you should not access context across threads, so coming back to other thoughts approach
        */
        
        let moc = sharedInstance.managedObjectContext
        
        let managedContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedContext.parentContext = moc
        
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
                
            }
            
        } // End of for
        
        //Save
        var error: NSError?
        do {
            //Save the child and master context
            try managedContext.save()
            try sharedInstance.managedObjectContext.save()
            print("Log: Saved to Core Data....")
            
        } catch let error1 as NSError {
            error = error1
            print("Log : Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func checkpricesUpdated() -> Bool {
        
        let requestStation = NSFetchRequest(entityName: COUNTRY_STATIONS_ENTITY)
        
        do {
            let fetchResults = try Storage.sharedInstance.managedObjectContext.executeFetchRequest(requestStation) as? [StationsXCountry]
            
            if (fetchResults != nil && fetchResults?.count > 0) {
                if let countryStation : StationsXCountry = (fetchResults?.first)! {
                    //Compare the dates
                    let todayDate = NSDate(timeIntervalSinceNow: 0)
                    let calendar = NSCalendar.currentCalendar()
                    
                    let comps1 = calendar.components([NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Day], fromDate:countryStation.lastUpdated)
                    let comps2 = calendar.components([NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Day], fromDate:todayDate)
                    
                    return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
                } else { return false}
                
            } else {
                return false
            }
            
        } catch let fetchError as NSError {
            print("Fetching Stations Error: \(fetchError.localizedDescription)")
            return false
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
    //It also sets the instance variable gasStations to the last retrieved stations to avoid reloading
    //the same data again and again
    
    func getPetrolStations(lat : Double, long : Double, range : Double) -> Array<Gasolinera>? {
        
        
        let requestStation = NSFetchRequest(entityName: STATIONS_ENTITY)
        
        do {
            let fetchResults = try Storage.sharedInstance.managedObjectContext.executeFetchRequest(requestStation) as? [PetrolStation]
            
            if (fetchResults != nil) {
                
                let userLoc : CLLocation = CLLocation.init(latitude: lat, longitude: long)
                var filteredArray : Array<PetrolStation> = Array()
                
                //Clear the stats
                stats.removeStats()
                
                for state : PetrolStation in fetchResults! {
                    //Filter gas stations by distance
                    let stationLoc : CLLocation = CLLocation.init(latitude: state.latitud.doubleValue, longitude: state.longitud.doubleValue)
                    let distanceToUser = userLoc.distanceFromLocation(stationLoc)
                    
                    if distanceToUser <= range {
                        filteredArray.append(state);
                    
                        if Double(state.gasolina95) > 0 {
                            stats.gas95Array.append(Double(state.gasolina95))
                        }
                        
                        if Double(state.gasolina98) > 0 {
                            stats.gas98Array.append(Double(state.gasolina98))
                        }
                        
                        if Double(state.gasoleoA) > 0 {
                            stats.dieselArray.append(Double(state.gasoleoA))
                        }
                        
                        if Double(state.nuevoGasoleoA) > 0 {
                            stats.dieselPlusArray.append(Double(state.nuevoGasoleoA))
                        }
                    
                    }
                }
                
                //Set the instance variable so it holds the last items retrieved
                gasStations = Storage.stationEntityToObject(filteredArray)
                
                //Sort the stats
                stats.calculateStats()
                
                return gasStations
                
            } else {
                return nil
            }
            
        } catch let fetchError as NSError {
            print("Fetching Stations Error: \(fetchError.localizedDescription)")
            return nil
        }
        
    }
    
    //Fills a Gasolinera object from a Petrol station entity from Core Data
    
    class func stationEntityToObject(stationsDB : Array<PetrolStation>) -> Array<Gasolinera> {
        
        var estaciones : Array<Gasolinera> =  Array<Gasolinera>();
        
        //Copy values to the object
        for object in stationsDB {
            let station = Gasolinera();
            station.margen = object.margen;
            station.rotulo = object.rotulo;
            station.remision = object.remision
            station.horario = object.tipoVenta
            
            station.latitud = object.latitud.doubleValue
            station.longitud = object.longitud.doubleValue
            station.localidad = object.localidad
            station.municipio = object.municipio
            station.provincia = object.provincia
            station.cp = object.cp
            station.direccion = object.direccion
            
            station.biodiesel = object.biodiesel.doubleValue
            station.bioetanol = object.bioetanol.doubleValue
            station.gasNaturalComprimido = object.gasNatural.doubleValue
            station.gasoleoA = object.gasoleoA.doubleValue
            station.nuevoGasoleoA = object.nuevoGasoleoA.doubleValue
            station.gasolina95 = object.gasolina95.doubleValue
            station.gasolina98 = object.gasolina98.doubleValue
            station.esterMetilico = object.esterMetilico.doubleValue
            
            estaciones.append(station)
        }
    
        return estaciones;
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