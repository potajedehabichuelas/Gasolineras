//
//  GasPointAnnotation.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 8/12/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit
import MapKit

class GasPointAnnotation: MKPointAnnotation {
    
    var name : String = "";
    var address : String = "";
    
    var precioGas98: String = ""
    var precioGas95: String = ""
    var precioDiesel: String = ""
    var precioDieselPlus: String = ""
    
    var pinColor = UIColor.blackColor();
    
    var callOutView : GasAnnotationView?
}
