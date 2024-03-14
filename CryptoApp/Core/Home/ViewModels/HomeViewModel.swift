//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 13.03.2024.
//

import Foundation
import Combine


class HomeViewModel : ObservableObject{
    
    @Published var stats : [StatisticModel] = [
        StatisticModel(title: "title", value: "value", percantageChange: 1),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value", percantageChange: 1),
        StatisticModel(title: "title", value: "value", percantageChange: -1)
    ]
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var searchText : String = ""
    private var cancellables = Set<AnyCancellable>()
    private let dataService = CoinDataService()
    
    init() {
        addSubsribers()
    }
    
    
    func addSubsribers(){
        
        //updates all coins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        
    }
    
    private func filterCoins(text : String, coins : [CoinModel]) -> [CoinModel]{
        
        //if text is empty return all coins
        guard !text.isEmpty else{
            return coins
        }
        
        
        let lowerCasedText = text.lowercased()
        
        return  coins.filter { coin in
            return coin.name.lowercased().contains(lowerCasedText) ||
            coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
        }
    }
    
    
    
    
}
