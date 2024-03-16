//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 15.03.2024.
//

import Foundation
import Combine

class MarketDataService{
    @Published var marketData : MarketDataModel? = nil
    
    var cancellables =  Set<AnyCancellable>()
    var marketDataSubscription : AnyCancellable?
    
    init() {
        getMarketData()
    }
    
     func getMarketData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        
        marketDataSubscription =  NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
    
    
}


