//
//  StationsXCountry.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 29/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import Foundation
import CoreData

class StationsXCountry: NSManagedObject {

    @NSManaged var lastUpdated: NSDate
    @NSManaged var notes: String
    @NSManaged var hasStates: StationsXState

}
