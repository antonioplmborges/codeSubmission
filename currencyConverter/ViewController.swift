//
//  ViewController.swift
//  currencyConverter
//
//  Created by Antonio Borges on 3/27/17.
//  Copyright © 2017 Antonio Borges. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbview: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var exchangeRates = [String]()
    var currencySymbol = [String]()
    var subtitleName = [String]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tbview.dataSource = self
        tbview.delegate = self
        tbview.register(UINib(nibName: "RateTableViewCell", bundle: nil), forCellReuseIdentifier: "rateTableCell")
        
        fetchData()
        

    }
    
    func fetchData() {
        //print("FETCHING DATA")
        
        let apiBaseUsd = "http://api.fixer.io/latest?base=USD"
        guard let url = URL(string: apiBaseUsd) else {
            print("Url is not valid")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 {
                    print("Everything is ok")
                }
                else {
                    print("Error fetching data")
                }
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                guard let exchangeDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                    print("Could not convert JSON to dictionary")
                    return
                }
                print(exchangeDict.description)
                if let rates = exchangeDict["rates"] {
                    
                    let currencies = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
                    
                    
                    let subtitleDic: [String: String] =  [
                        "AUD": "Australian Dollar","BGN": "Bulgaria Lev",
                        "BRL": "Brazil Real","CAD": "Canada Dollar",
                        "CHF": "Switzerland Franc","CNY": "China Yuan/Renminbi",
                        "CZK": "Czech Koruna", "DKK": "Denmark Krone",
                        "GBP": "Great Britain Pound", "HKD": "Hong Kong Dollar",
                        "HRK": "Croatia Kuna", "HUF": "Hungary Forint",
                        "IDR": "Indonesia Rupiah", "ILS": "Israel New Shekel",
                        "INR": "India Rupee", "JPY": "Japan Yen",
                        "KRW": "South Korea Won", "MXN": "Mexico Peso",
                        "MYR": "Malaysia Ringgit", "NOK": "Norway Kroner",
                        "NZD": "New Zealand Dollar", "PHP": "Philippines Peso",
                        "PLN": "Poland Zloty", "RON": "Romania New Lei",
                        "RUB": "Russia Rouble", "SEK": "Sweden Krona",
                        "SGD": "Singapore Dollar", "THB": "Thailand Baht",
                        "TRY": "Turkish New Lira","ZAR": "South Africa Rand",
                        "EUR": "Euro"
                    ]
                    
                    for currency in currencies {
                        if let rate = rates[currency] as? Float {
                            self.exchangeRates.append("\(rate)")
                            self.currencySymbol.append(currency)
                            
                        }
                        
                        for (key,value) in subtitleDic {
                            if(key == currency) {
                                self.subtitleName.append(value)
                            }
                        }
                        
                    }
                }
                
                print(self.exchangeRates)
                
                OperationQueue.main.addOperation({
                    self.tbview.reloadData()
                    
                })
                
            }
            catch {
                print("Error trying to convert JSON to dictionary")
            }
        })
        
        task.resume()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates.count //number of sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "rateTableCell") as? RateTableViewCell {
            
            let rates = exchangeRates[indexPath.row]
            let title = currencySymbol[indexPath.row]
            let subtitle = subtitleName[indexPath.row]
            cell.setCell(moneyText: rates, titleText: title, subtitleText: subtitle)
            
            return cell;
        } else {
            let cell = UITableViewCell();
            cell.textLabel?.text = exchangeRates[indexPath.row]
            return cell
        }
      }
    
    func addRefreshHeader() {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: myActivityIndicator)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @IBAction func reloadTable(_ sender: Any) {
        //print("Reloading")
        //spinner
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: myActivityIndicator)
        self.navigationItem.rightBarButtonItem = barButtonItem

        fetchData()
        tbview.reloadData()
        
        //stop spinning
        print("stop animating")
        myActivityIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem = refreshButton
        
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

