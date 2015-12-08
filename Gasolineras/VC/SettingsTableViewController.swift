//
//  SettingsTableViewController.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 22/11/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
        
        //Save to settings
        if indexPath.section == 0 {
            //Save search type
            Storage.sharedInstance.settings.setValue(cell?.textLabel?.text, forKey: STORAGE_SEARCH_SETTINGS)
        } else  if indexPath.section == 1 {
            //Save distance
            Storage.sharedInstance.settings.setValue(cell?.textLabel?.text, forKey: STORAGE_DISTANCE_SETTINGS)
        }
        Storage.sharedInstance.saveSettings(Storage.sharedInstance.settings);
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.accessoryType = UITableViewCellAccessoryType.None;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (Storage.sharedInstance.settings[STORAGE_SEARCH_SETTINGS] as? String == cell.textLabel?.text || Storage.sharedInstance.settings[STORAGE_DISTANCE_SETTINGS] as? String == cell.textLabel?.text ) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else  {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
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
