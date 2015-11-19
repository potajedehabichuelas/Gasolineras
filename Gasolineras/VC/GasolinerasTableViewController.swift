//
//  GasolinerasTableViewController.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 18/11/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit

class GasolinerasTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            // Request petrol station data
            NetworkManager.sharedInstance.requestSpanishPetrolStationData();
            //Data and everything is now updated in the storage
            //Reload Data (Update references, UI,...)
            //self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 10
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let gasCell : GasTableViewCell = tableView.dequeueReusableCellWithIdentifier("GasCell", forIndexPath: indexPath) as! GasTableViewCell

        // Configure the gas Cell
        gasCell.gasName.text = "Peste Station"

        return gasCell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
