//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 17.03.2024.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject {
 
    private let coinDetailService:  CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    init(coin : CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    
    func addSubscribers(){
        coinDetailService.$coinDetails
            .sink { returnedDetails in
                print("got the data")
                print(returnedDetails)
            }
            .store(in: &cancellables)
    }
}
