//
//  AdCellTableViewCell.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 15/12/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit
import GoogleMobileAds;

class AdCellTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Google ads - load
        bannerView.adUnitID = "ca-app-pub-7267181828972563/7783621534"
        bannerView.load(GADRequest())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
