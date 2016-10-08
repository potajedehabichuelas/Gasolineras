//
//  GasTableViewCell.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 18/11/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit

class GasTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var gasName: UILabel!
    @IBOutlet weak var distanceKm: UILabel!
    
    @IBOutlet weak var petrol95Price: UILabel!
    
    @IBOutlet weak var petrol98Price: UILabel!
    
    @IBOutlet weak var dieselPrice: UILabel!
    
    @IBOutlet weak var dieselPlusPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
