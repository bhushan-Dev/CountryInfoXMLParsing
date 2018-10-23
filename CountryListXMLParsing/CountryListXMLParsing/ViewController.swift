//
//  ViewController.swift
//  CountryListXMLParsing
//
//  Created by Bhushan Udawant on 24/10/18.
//  Copyright © 2018 Bhushan Udawant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Constants

    let baseUrl = "https://firebasestorage.googleapis.com/v0/b/fierbasechat.appspot.com/o/country.xml?alt=media&token=fc9532a4-24d4-48c5-9f4a-42b40c3f37f6"
    var countryDict: Dictionary<String, Any>?
    var countriesList: Array<Dictionary<String, Any>>?
    var strCharacters: String? = nil
    var dataModel: [CountryListDataModel]?

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!


    // MARK: Life Cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch country list info
        fetchCountryList()

        print(dataModel?.count)

    }

    // MARK: Actions

    private func fetchCountryList() {
        let url = URL(string: baseUrl)
        dataModel = [CountryListDataModel]()
        if let _ = url {
            let xmlParser = XMLParser(contentsOf: url!)
            xmlParser?.delegate = self
            xmlParser?.parse()
        }
    }
}

// MARK: Delegates

extension ViewController: XMLParserDelegate {

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
        ) {
        print("Found: \(elementName)")

        if elementName == "country" {
            countryDict = [:]

            countryDict = attributeDict
        }
    }

    func parser(
        _ parser: XMLParser,
        foundCharacters string: String
        ) {
        print("Found: \(string)")
        strCharacters = string
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
        ) {
        print("Found: \(elementName)")

        if let _ = countryDict {
            countryDict![elementName] = strCharacters

            if elementName == "country" {

                if let countryName = countryDict!["country"] as? String,
                    let continent = countryDict!["continent"] as? String,
                    let iso = countryDict!["iso"] as? String,
                    let countryCode = countryDict!["code"] as? String {

                    dataModel?.append(CountryListDataModel(countryName: countryName, continent: continent, ios: iso, countryCode: countryCode))
                }
            }
        }

        strCharacters = nil
    }

}
