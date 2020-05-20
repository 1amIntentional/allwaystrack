//
//  CommodityTableViewCell.swift
//  Allways
//
//  Created by Jairo Batista on 12/8/16.
//  Copyright © 2016 AllWays. All rights reserved.
//

import UIKit

class CommodityTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var poLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    func configureCell(commodity : Commodity) {
        itemLabel.text = commodity.item
        descriptionLabel.text = commodity.itemDescription
        poLabel.text = commodity.poIdentity
        qtyLabel.text = commodity.quantity
        weightLabel.text = commodity.weight
    }
}
