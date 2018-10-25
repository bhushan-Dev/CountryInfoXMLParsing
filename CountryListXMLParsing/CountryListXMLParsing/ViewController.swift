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
    let countryCellIdentifier = "CountryCell"

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Life Cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch country list info
        fetchCountryList()
    }

    // MARK: Private Helpers

    private func fetchCountryList() {

        let url = URL(string: baseUrl)
        dataModel = [CountryListDataModel]()

        guard let _ = url else {
            return
        }

        // Show activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in

            // Hide activity indicator
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }

            if let error = error {
                DispatchQueue.main.async {
                    // Show network alert
                    self.showAlert(with: String(describing: error.localizedDescription))
                }
            }

            if data == nil {
                return
            }

            // Parse xml data
            let xmlParser = XMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()

            DispatchQueue.main.async {
                // Set delegate and data source for table view
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: XML Delegates

extension ViewController: XMLParserDelegate {

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
        ) {
        if elementName == "country" {
            countryDict = [:]
            countryDict = attributeDict
        }
    }

    func parser(
        _ parser: XMLParser,
        foundCharacters string: String
        ) {
        if (!string.isEmpty) {
            strCharacters = string
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
        ) {
        if let _ = countryDict {
            countryDict![elementName] = strCharacters

            if elementName == "country" {
                if let countryName = countryDict!["country"] as? String,
                    let continent = countryDict!["continent"] as? String,
                    let iso = countryDict!["iso"] as? String,
                    let countryCode = countryDict!["code"] as? String {

                    dataModel?.append(CountryListDataModel(countryName: countryName, continent: continent, iso: iso, countryCode: countryCode))
                }
            }
        }

        strCharacters = nil
    }
}


// MARK: Table View Delegate

extension ViewController: UITableViewDelegate {

}


// MARK: Table View Data Source

extension ViewController: UITableViewDataSource {

    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {
        guard let dataModel = dataModel else {
            return 0
        }

        return dataModel.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cell: CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: countryCellIdentifier) as! CountryTableViewCell

        if let dataModel = dataModel {
            let data = dataModel[indexPath.row]

            cell.countryName.text = data.countryName
            cell.continent.text = data.continent
            cell.iso.text = data.iso
            cell.countryCode.text = data.countryCode

            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.gray.cgColor
        }

        return cell
    }

}
