//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 14.03.2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image : UIImage? = nil
    private let coin : CoinModel
    private var imageSubscription : AnyCancellable?
    
    init(coin : CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    func getCoinImage(){
        
        guard let url = URL(string: coin.image) else {return}
        
        
        imageSubscription =  NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedImage) in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
