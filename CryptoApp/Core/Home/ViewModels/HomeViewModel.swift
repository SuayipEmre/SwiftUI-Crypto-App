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
    @Published var isLoading : Bool = false
    @Published var sortOption : SortOption = .holdings
    
    private var cancellables = Set<AnyCancellable>()
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    
    
    
    init() {
        addSubsribers()
    }
    
    
    enum SortOption{
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    func addSubsribers(){
        
        //updates all coins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        //update portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntitites)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
                
            }
            .store(in: &cancellables)
        
        
        
        //updates market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink {[weak self] (returnedStats) in
                self?.isLoading = false
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        
        
    }
    
    func updatePortfolio(coin : CoinModel, amount : Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins : [CoinModel], portfolioEntities : [PortfolioEntity]) -> [CoinModel]{
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where : {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    
    private func mapGlobalMarketData(marketDataModel:  MarketDataModel?,  portfolioCoins : [CoinModel]) -> [StatisticModel]{
        var stats : [StatisticModel] = []
        guard let data = marketDataModel else {return stats}
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percantageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24H Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        
        let previousValue = portfolioCoins
            .map { coin in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0.0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percantageChange: percentageChange
        )
        
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
    
    private func filterAndSortCoins(text : String, coins : [CoinModel], sort : SortOption) -> [CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort : SortOption, coins : inout [CoinModel])  {
        switch sort {
        case .rank, .holdings:  coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:  coins.sort(by: {$0.rank > $1.rank})
        case .price :  coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed :  coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
        
    }
    
    
    private func sortPortfolioCoinsIfNeeded(coins : [CoinModel]) -> [CoinModel] {
        
        //will only sort by holdings or reversedHoldings if needed
        switch sortOption {
        case .holdings: return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed: return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default : return coins
        }
        
        
    }
    func filterCoins(text : String, coins : [CoinModel]) -> [CoinModel]{
        
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
