//
//  DetailView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 17.03.2024.
//

import SwiftUI



struct DetailLoadingView : View{
    @Binding var coin  : CoinModel?
    var body: some View {
        ZStack{
            if let coin = coin{
                DetailView(coin: coin)
            }
        }
    }
}


struct DetailView: View {
    @StateObject var vm : DetailViewModel

    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("initializing detail view for \(coin.name)")
    }
    var body: some View {
        ZStack{
            
            Text("hello")
            
        }
    }
}

#Preview {
    DetailView(coin:DeveloperPreview.instance.coin)
}
