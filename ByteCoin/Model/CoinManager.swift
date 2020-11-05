//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate {
    func didUpdateCoin(coin:CoinData)
//    func did
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B46E4445-B88F-4155-86C6-51578696784F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency:String){
        print(currency)
        performRequest(with:"\(baseURL)/\(currency)?apikey=\(apiKey)")
        
    }
    
    func performRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: dataHandler(data:  response:  error: ))
            task.resume()
        }
    }
    func dataHandler(data:Data?,response:URLResponse?,error:Error?)-> Void{
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data{
            if let coinData = parseJSON(safeData){
                delegate?.didUpdateCoin(coin: coinData)

            }

        }
    }
    
    func parseJSON(_ data:Data) -> CoinData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            print(decodedData)
            return decodedData
        }catch{
            print(error)
            return nil
        }
    }
}
