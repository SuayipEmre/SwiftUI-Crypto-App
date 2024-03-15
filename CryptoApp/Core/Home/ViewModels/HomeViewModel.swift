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
    @Published var statistics : [StatisticModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    
    
    
    init() {
        addSubsribers()
    }
    
    
    func addSubsribers(){
        
        //updates all coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        //updates market data
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink {[weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        
        //update portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntitites)
            .map { (coinModels, portfolioentities) -> [CoinModel] in
                coinModels
                    .compactMap { coin -> CoinModel? in
                        guard let entity = portfolioentities.first(where : {$0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        
    }
    
    func updatePortfolio(coin : CoinModel, amount : Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
    
    
    private func mapGlobalMarketData(marketDataModel:  MarketDataModel?) -> [StatisticModel]{
        var stats : [StatisticModel] = []
        guard let data = marketDataModel else {return stats}
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percantageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24H Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percantageChange: 0)
        
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
    
    
    
}
