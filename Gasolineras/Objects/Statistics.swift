//
//  Statistics.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 13/12/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit


class Statistics: NSObject {
    
    //Singleton
    static let sharedInstance = Statistics()

    var gas98Array : Array<Double> = Array();
    var gas95Array : Array<Double> = Array();
    var dieselArray : Array<Double> = Array();
    var dieselPlusArray : Array<Double> = Array();
    
    var sorted : Bool = false;
    
    func removeStats(){
        sorted = false;
        gas95Array.removeAll()
        gas98Array.removeAll()
        dieselPlusArray.removeAll()
        dieselArray.removeAll()
    }
    
    func calculateStats(){
        //Sort the arrays
        gas98Array.sort()
        gas95Array.sort()
        dieselArray.sort()
        dieselPlusArray.sort()
        sorted = true;
    }
    
    //Checks how the provided value relates to the whole
    //Returns the percentile of the fuel price
    //This is useful to mark the fuel following a color scheme based on its price
    // Red -> expensive, Orange -> Close to avg price (+/- 20%), Green -> Cheap price
    func getRangeForValue(_ price : Double, fuelType : String) -> Double {
        
        //Get sorted ( - to +) array, iterate from 0 to N stop where value is greater than given value
        //Get the position n of the array where that happened
        //Then n/N(count of array) x 100 to get % of value
        //up to 30 % cheap / from 30% to 70 % normal price / more than 70% expensive

        var array : Array <Double>;
        
        //Set the array based on the fuel type
        if fuelType == DIESEL {
             array = dieselArray;
        } else if fuelType == DIESELPLUS {
            array = dieselPlusArray;
        } else if fuelType == GAS95 {
            array = gas95Array;
        } else /*if fuelType == GAS98  && gas95Array != nil */{
            array = gas98Array;
        }
        
        for i in 0  ..< array.count  {
            if array[i] >= price {
                let percentage : Double = (Double(i) / Double(array.count)) * 100;
                return percentage;
            }
        }
        //Fail?
        return 0;
    }
}
