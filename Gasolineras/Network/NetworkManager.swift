//
//  SlangNet.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

private let SPAIN_BASE_URL : String = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/";

class NetworkManager: NSObject {
  
    //Singleton
    static let sharedInstance = NetworkManager()
    
    //Request information for all the stations , and saves the result to db
    func requestSpanishPetrolStationData()
    {
        print("Requesting petrol station data for Spain: ");
        
        let requestResult : AnyObject? = HttpHelper.httpGetURL(SPAIN_BASE_URL, postPath:nil, parametersDict:nil);
        
        if let jsonDict = requestResult as? NSDictionary {
            //Translate JSON data into a collection of Gas Station Objects (Country sations
            let stationsForSpain : CountryStations? = CountryStations.countryStationsFromJSON(jsonDict, countryName: "Spain");
            //Save to file or DB
            //Save to Core Data
            if stationsForSpain != nil {
                Storage.saveCountryStations(stationsForSpain!);
            }
            
        }
    }
}
