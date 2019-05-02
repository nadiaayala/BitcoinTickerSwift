//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    var finalURL = ""

    //IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self 
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView , numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //This method is going to be called by the UIPicker upon loading up and its going to look for the titles and the data that it should put into the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencySelected = currencySymbols[row]
        getBitcoinData(url: finalURL)
        
        
    }
    
    
//    
//   Networking
//   ***************************************************************
    
    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the currency data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
  

    
// JSON Parsing
//    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {

//        if let tempResult = json["main"]["temp"].double {
//
//
//        }
        
        if let bitcoinResults = json["ask"].double {
            bitcoinPriceLabel.text = currencySelected + String(bitcoinResults)
        }
        else{
            bitcoinPriceLabel.text = "Price unavailable"
        }
}


}

