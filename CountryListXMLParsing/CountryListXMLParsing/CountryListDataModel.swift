//
//  CountryListDataModel.swift
//  CountryListXMLParsing
//
//  Created by Bhushan Udawant on 24/10/18.
//  Copyright © 2018 Bhushan Udawant. All rights reserved.
//

import Foundation

class CountryListDataModel {
    var countryName: String
    var continent: String
    var iso: String
    var countryCode: String

    init(countryName: String, continent: String, iso: String, countryCode: String) {
        self.countryName = countryName
        self.continent = continent
        self.iso = iso
        self.countryCode = countryCode
    }
}
