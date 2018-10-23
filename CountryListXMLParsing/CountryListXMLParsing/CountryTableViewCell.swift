//
//  CountryTableViewCell.swift
//  CountryListXMLParsing
//
//  Created by Bhushan Udawant on 24/10/18.
//  Copyright © 2018 Bhushan Udawant. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var continent: UILabel!
    @IBOutlet weak var iso: UILabel!
    @IBOutlet weak var countryCode: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
