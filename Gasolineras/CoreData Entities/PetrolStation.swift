//
//  PetrolStation.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 29/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import Foundation
import CoreData

class PetrolStation : NSManagedObject, NSCopying {

    @NSManaged var bioalcohol: NSNumber
    @NSManaged var biodiesel: NSNumber
    @NSManaged var bioetanol: NSNumber
    @NSManaged var cp: String
    @NSManaged var direccion: String
    @NSManaged var esterMetilico: NSNumber
    @NSManaged var gasNatural: NSNumber
    @NSManaged var gasoleoA: NSNumber
    @NSManaged var gasolina95: NSNumber
    @NSManaged var gasolina98: NSNumber
    @NSManaged var horario: String
    @NSManaged var id: NSNumber
    @NSManaged var latitud: NSNumber
    @NSManaged var localidad: String
    @NSManaged var longitud: NSNumber
    @NSManaged var margen: String
    @NSManaged var municipio: String
    @NSManaged var nuevoGasoleoA: NSNumber
    @NSManaged var provincia: String
    @NSManaged var remision: String
    @NSManaged var rotulo: String
    @NSManaged var tipoVenta: String
    @NSManaged var belongsToState: StationsXState
    
    func copy(with zone: NSZone?) -> Any {
        return PetrolStation()
    }

}
