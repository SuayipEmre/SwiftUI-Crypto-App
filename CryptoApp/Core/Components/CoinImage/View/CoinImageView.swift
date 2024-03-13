//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 14.03.2024.
//

import SwiftUI



struct CoinImageView: View {
    @StateObject var vm : CoinImageViewModel
    
    init(coin : CoinModel) {
     _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if vm.isLoading{
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.instance.coin)
}
