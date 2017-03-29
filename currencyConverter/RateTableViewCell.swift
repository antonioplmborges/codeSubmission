//
//  RateTableViewCell.swift
//  currencyConverter
//
//  Created by Antonio Borges on 3/29/17.
//  Copyright © 2017 Antonio Borges. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(moneyText: String, titleText: String, subtitleText: String) {
        moneyLabel.text = moneyText
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
    }
    
}
