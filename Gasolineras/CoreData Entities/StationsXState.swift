//
//  StationsXState.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 29/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import Foundation
import CoreData

class StationsXState: NSManagedObject {

    @NSManaged var stateName: String
    @NSManaged var belongsToCountry: StationsXCountry
    @NSManaged var hasStation: PetrolStation

}
