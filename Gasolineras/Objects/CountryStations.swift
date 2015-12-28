//
//  CountryStations.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 19/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit

/*
Use ? if the value can become nil in the future, so that you test for this.
Use ! if it really shouldn't become nil in the future, but it needs to be nil initially.
*/

/*
* List of all the petrol stations for a country
*/

private let COUNTRY_NAME_KEY : String = "countryName";

private let STATIONS_ARRAY_KEY : String = "stationsArray";

private let STATIONS_FECHA_KEY : String = "Fecha"; //Last updated date

private let STATIONS_NOTA_KEY : String = "Nota";

private let SPANISH_STATIONS_ARRAY_KEY : String = "ListaEESSPrecio"; //Key del array de gasolineras

class CountryStations: NSObject {
    
    var countryName : String!;
    
    var stationsArray : Array <Gasolinera> = Array();
    
    var lastUpdated : NSDate!;
    
    var notes : String = "";
    
    // MARK : Public Functions
    
    class func countryStationsFromJSON(gasDict: NSDictionary, countryName: String) -> CountryStations {
        
        let countryStations : CountryStations = CountryStations();
        
        countryStations.countryName = countryName;
        
        let dateFormatter = NSDateFormatter()
        //Spanish time zone!
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss +0200"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        //There should always be a date
        countryStations.lastUpdated = dateFormatter.dateFromString(gasDict.objectForKey(STATIONS_FECHA_KEY) as! String)
        //Notes
        countryStations.notes = gasDict.objectForKey(STATIONS_NOTA_KEY) as! String;
        
        //Array of petrol stations
        if let stationArray = gasDict[SPANISH_STATIONS_ARRAY_KEY] as? NSArray {
            print("Log: parsing petrol stations for " + countryName)
            
            for stationDict in stationArray {
                //Parse the station and add it to the array
                let petrolStation : Gasolinera? = Gasolinera.gasolineraFromJSON(stationDict as! NSDictionary);
                if petrolStation != nil {
                    countryStations.stationsArray.append(petrolStation!);
                }
                
            }
            print("Log: Finished parsing petrol stations for " + countryName)
        }
        
        return countryStations;
    }
    
    // MARK : INIT
    
    override init() {
        super.init()
    }
   
}
