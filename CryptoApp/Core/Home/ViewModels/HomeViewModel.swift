//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 13.03.2024.
//

import Foundation
import Combine


class HomeViewModel : ObservableObject{
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var searchText : String = ""
    private var cancellables = Set<AnyCancellable>()
    private let dataService = CoinDataService()
    
    init() {
       addSubsribers()
    }
    
    
    func addSubsribers(){
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins  = returnedCoins
                
            }
            .store(in: &cancellables)
    }
    
    
    
    
}
