//
//  FirstViewController.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 10/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            // Request petrol station data
            NetworkManager.sharedInstance.requestSpanishPetrolStationData();
            //Data and everything is now updated in the storage
            //Reload Data (Update references, UI,...)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

