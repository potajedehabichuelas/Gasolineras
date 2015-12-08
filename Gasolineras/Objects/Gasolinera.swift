//
//  PetrolStation.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 19/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit

/*
    *Petrol Station Object
*/

private let JSON_CODIGO_POSTAL_KEY : String = "C.P.";
private let JSON_DIRECCION_KEY : String = "Dirección";
private let JSON_HORARIO_KEY : String = "Horario";
private let JSON_LATITUD_KEY : String = "Latitud";
private let JSON_LONGITUD_KEY : String = "Longitud (WGS84)";
private let JSON_MARGEN_KEY : String = "Margen";
private let JSON_MUNICIPIO_KEY : String = "Municipio";
private let JSON_PROVINCIA_KEY : String = "Provincia";
private let JSON_LOCALIDAD_KEY : String = "Localidad";

private let JSON_REMISION_KEY : String = "Remisión";
private let JSON_ROTULO_KEY : String = "Rótulo";
private let JSON_TIPO_VENTA_KEY : String = "Tipo Venta";

private let JSON_PRECIO_BIOALCOHOL_KEY : String = "% Bioalcohol";
private let JSON_PRECIO_ESTER_METILICO_KEY : String = "% Éster metílico";

private let JSON_PRECIO_BIODIESEL_KEY : String = "Precio Biodiesel";
private let JSON_PRECIO_GAS_NATURAL_COMPRIMIDO_KEY : String = "Precio Gas Natural Comprimido";
private let JSON_PRECIO_BIOETANOL_KEY : String = "Precio Bioetanol";
private let JSON_PRECIO_GASOLEO_A_KEY : String = "Precio Gasoleo A";
private let JSON_PRECIO_NUEVO_GASOLEO_A_KEY : String = "Precio Nuevo Gasoleo A";
private let JSON_PRECIO_GASOLINA95_KEY : String = "Precio Gasolina 95 Protección";
private let JSON_PRECIO_GASOLINA98_KEY : String = "Precio Gasolina  98";


class Gasolinera: NSObject {

    //Informacion general
    
    var margen : String = "";
    
    var rotulo : String = "";
    
    var remision : String = "";
    
    var horario : String = "";
    
    var tipoVenta : String = "";
    
    //Localizacion
    
    var latitud : Double!;
    
    var longitud : Double!;
    
    var localidad : String = "";
    
    var municipio : String = "";
    
    var provincia : String = "";
    
    var cp : String  = "";
    
    var direccion : String?;
    
    //Precio de los carburantes
    
    var biodiesel : Double?;
    
    var bioetanol : Double?;
    
    var bioalcohol : Double?;
    
    var gasNaturalComprimido : Double?;
    
    var gasoleoA : Double?;
    var nuevoGasoleoA : Double?;
    
    var gasolina95 : Double?;
    
    var gasolina98 : Double?;
    
    var esterMetilico : Double?;
    
    
    // MARK : INIT
    
    override init() {
        super.init()
    }
    
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init(self)
    }
    
    required init(_ object: Gasolinera) {
        //Init the model based on the one given
        margen = object.margen;
        rotulo = object.rotulo;
        remision = object.remision
        horario = object.tipoVenta
        
        latitud = object.latitud
        longitud = object.longitud
        localidad = object.localidad
        municipio = object.municipio
        provincia = object.provincia
        cp = object.cp
        direccion = object.direccion
        
        biodiesel = object.biodiesel
        bioetanol = object.bioetanol
        gasNaturalComprimido = object.gasNaturalComprimido
        gasoleoA = object.gasoleoA
        nuevoGasoleoA = object.nuevoGasoleoA
        gasolina95 = object.gasolina95
        gasolina98 = object.gasolina98
        esterMetilico = object.esterMetilico
    }

    
    // MARK : Class Functions
    
    class func gasolineraFromJSON(gasDict: NSDictionary) -> Gasolinera {
        
        let newGas : Gasolinera = Gasolinera();
        
        //Informacion general
        newGas.margen = gasDict[JSON_MARGEN_KEY] as! String;
        newGas.rotulo = gasDict[JSON_ROTULO_KEY] as! String;
        newGas.remision = gasDict[JSON_REMISION_KEY] as! String;
        newGas.horario = gasDict[JSON_HORARIO_KEY] as! String;
        newGas.tipoVenta = gasDict[JSON_TIPO_VENTA_KEY] as! String;
        
        //Localizacion
        newGas.latitud =  (gasDict[JSON_LATITUD_KEY] as! String).doubleConverter
        newGas.longitud = (gasDict[JSON_LONGITUD_KEY] as! String).doubleConverter
        
        newGas.localidad = gasDict[JSON_LOCALIDAD_KEY] as! String;
        newGas.municipio = gasDict[JSON_MUNICIPIO_KEY] as! String;
        newGas.provincia = gasDict[JSON_PROVINCIA_KEY] as! String;
        newGas.cp = gasDict[JSON_CODIGO_POSTAL_KEY] as! String;
        
        newGas.direccion = gasDict[JSON_DIRECCION_KEY] as? String; // Can be null
        
        //Precio de los carburantes - optional values - any of it could be null
        
        newGas.biodiesel = self.processDoubleJSON(gasDict, key: JSON_PRECIO_BIODIESEL_KEY);
        
        newGas.bioetanol = self.processDoubleJSON(gasDict, key: JSON_PRECIO_BIOETANOL_KEY);
        
        newGas.bioalcohol = self.processDoubleJSON(gasDict, key: JSON_PRECIO_BIOALCOHOL_KEY);
        
        newGas.gasNaturalComprimido = self.processDoubleJSON(gasDict, key: JSON_PRECIO_GAS_NATURAL_COMPRIMIDO_KEY);
        
        newGas.gasoleoA = self.processDoubleJSON(gasDict, key: JSON_PRECIO_GASOLEO_A_KEY);
        
        newGas.nuevoGasoleoA = self.processDoubleJSON(gasDict, key: JSON_PRECIO_NUEVO_GASOLEO_A_KEY);
        
        newGas.gasolina95 = self.processDoubleJSON(gasDict, key: JSON_PRECIO_GASOLINA95_KEY);

        newGas.gasolina98 = self.processDoubleJSON(gasDict, key: JSON_PRECIO_GASOLINA98_KEY);
        
        newGas.esterMetilico = self.processDoubleJSON(gasDict, key: JSON_PRECIO_ESTER_METILICO_KEY);
        
        return newGas;
    }
    
    /*
    * Helper to process json value, get the number and returns nil if value is not valid (NULL or <= 0 which means it is not available)
    */
    
    class func processDoubleJSON(gasDict : NSDictionary, key : String) -> Double? {
        
        if let value : Double = (gasDict[key] as? String)?.doubleConverter { // Valid string and a double
            if value > 0 { // Bigger than 0, means it's sold in the station
                return value;
            }
        }
        
        //Safer version
        /*if let stringValue = (gasDict[key] as? String) { // Valid string
            if let value = stringValue.doubleConverter as Double? { // is a double
                if value > 0 {return value} // Bigger than 0, means it's sold in the station
            }
        }*/
        
        return nil;
    }
    
    // MARK : NSCODING
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.margen, forKey:JSON_MARGEN_KEY)
        aCoder.encodeObject(self.remision, forKey:JSON_REMISION_KEY)
        
        aCoder.encodeObject(self.rotulo, forKey: JSON_ROTULO_KEY)
    
        aCoder.encodeObject(self.horario, forKey: JSON_HORARIO_KEY)
        
        aCoder.encodeObject(self.tipoVenta, forKey: JSON_TIPO_VENTA_KEY)
        
        aCoder.encodeDouble(self.latitud, forKey: JSON_LATITUD_KEY)
        
        aCoder.encodeDouble(self.longitud, forKey: JSON_LONGITUD_KEY)
        
        aCoder.encodeObject(self.localidad, forKey: JSON_LOCALIDAD_KEY)
        
        aCoder.encodeObject(self.municipio, forKey: JSON_MUNICIPIO_KEY)
        
        aCoder.encodeObject(self.provincia, forKey: JSON_PROVINCIA_KEY)
        
        aCoder.encodeObject(self.cp, forKey: JSON_CODIGO_POSTAL_KEY)
        
        if self.direccion != nil {
            aCoder.encodeObject(self.direccion, forKey: JSON_DIRECCION_KEY)
        }
        
        
        //Precios - they could be null - meaning that the gas station doesn't provide them
        
        if self.biodiesel != nil {
            aCoder.encodeDouble(self.biodiesel!, forKey: JSON_PRECIO_BIODIESEL_KEY)
        }
        
        if self.bioetanol != nil {
            aCoder.encodeDouble(self.bioetanol!, forKey: JSON_PRECIO_BIOETANOL_KEY)
        }
        
        if self.bioalcohol != nil {
            aCoder.encodeDouble(self.bioalcohol!, forKey: JSON_PRECIO_BIOALCOHOL_KEY)
        }
        
        if self.gasNaturalComprimido != nil {
            aCoder.encodeDouble(self.gasNaturalComprimido!, forKey: JSON_PRECIO_GAS_NATURAL_COMPRIMIDO_KEY)
        }
        
        if self.gasoleoA != nil {
            aCoder.encodeDouble(self.gasoleoA!, forKey: JSON_PRECIO_GASOLEO_A_KEY)
        }
        
        if self.nuevoGasoleoA != nil {
            aCoder.encodeDouble(self.nuevoGasoleoA!, forKey: JSON_PRECIO_NUEVO_GASOLEO_A_KEY)
        }
        
        if self.gasolina95 != nil {
            aCoder.encodeDouble(self.gasolina95!, forKey: JSON_PRECIO_GASOLINA95_KEY)
        }
        
        if self.gasolina98 != nil {
            aCoder.encodeDouble(self.gasolina98!, forKey: JSON_PRECIO_GASOLINA98_KEY)
        }
        
        if self.esterMetilico != nil {
            aCoder.encodeDouble(self.esterMetilico!, forKey: JSON_PRECIO_ESTER_METILICO_KEY)
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.margen = aDecoder.decodeObjectForKey(JSON_MARGEN_KEY) as! String
        
        self.rotulo = aDecoder.decodeObjectForKey(JSON_ROTULO_KEY) as! String
        
        self.remision = aDecoder.decodeObjectForKey(JSON_REMISION_KEY) as! String
        
        self.horario = aDecoder.decodeObjectForKey(JSON_HORARIO_KEY) as! String
        
        self.tipoVenta = aDecoder.decodeObjectForKey(JSON_TIPO_VENTA_KEY) as! String
        
        self.latitud = aDecoder.decodeDoubleForKey(JSON_LATITUD_KEY)
        
        self.longitud = aDecoder.decodeDoubleForKey(JSON_LONGITUD_KEY)
        
        self.localidad = aDecoder.decodeObjectForKey(JSON_LOCALIDAD_KEY) as! String
        
        self.municipio = aDecoder.decodeObjectForKey(JSON_MUNICIPIO_KEY) as! String
        
        self.provincia = aDecoder.decodeObjectForKey(JSON_PROVINCIA_KEY) as! String
        
        self.cp = aDecoder.decodeObjectForKey(JSON_CODIGO_POSTAL_KEY) as! String
        
        self.direccion = aDecoder.decodeObjectForKey(JSON_DIRECCION_KEY) as? String
        
        //Precios
        
        self.biodiesel = aDecoder.decodeDoubleForKey(JSON_PRECIO_BIODIESEL_KEY)
        
        self.bioetanol = aDecoder.decodeDoubleForKey(JSON_PRECIO_BIOETANOL_KEY)
        
        self.bioalcohol = aDecoder.decodeDoubleForKey(JSON_PRECIO_BIOALCOHOL_KEY)
        
        self.gasNaturalComprimido = aDecoder.decodeDoubleForKey(JSON_PRECIO_GAS_NATURAL_COMPRIMIDO_KEY)
        
        self.gasoleoA = aDecoder.decodeDoubleForKey(JSON_PRECIO_GASOLEO_A_KEY)
        
        self.nuevoGasoleoA = aDecoder.decodeDoubleForKey(JSON_PRECIO_NUEVO_GASOLEO_A_KEY)
        
        self.gasolina95 = aDecoder.decodeDoubleForKey(JSON_PRECIO_GASOLINA95_KEY)
        
        self.gasolina98 = aDecoder.decodeDoubleForKey(JSON_PRECIO_GASOLINA98_KEY)
        
        self.esterMetilico = aDecoder.decodeDoubleForKey(JSON_PRECIO_ESTER_METILICO_KEY)
        
    }
    
}

//Extension to read number with comma as a decimal point
extension String {
    var doubleConverter: Double {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(self) {
            return result.doubleValue
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
