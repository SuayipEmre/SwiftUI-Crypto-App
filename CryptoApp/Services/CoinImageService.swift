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
    private let fileManager = LocalFileManager.instance
    private let imageName : String
    
    private let folderName = "coin_images"
    init(coin : CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
           
        } else{
            downloardCoinImage()
         
        }
    }
    
    func downloardCoinImage(){
        
        guard let url = URL(string: coin.image) else {return}
        
        
        imageSubscription =  NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else{return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, FolderName: self.folderName)
            })
    }
}
