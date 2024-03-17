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
    @StateObject private var vm : DetailViewModel

    private let columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing : CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
 
    }
    var body: some View {
        ScrollView(){
            
            VStack{
                ChartView(coin: vm.coin)
                VStack(spacing:20){
                 
                    
                    overViewTitle
                    Divider()
                    overviewGrid
                                 
                    additionalTitle
                    Divider()
                    additionalGrid
                   
                    
                 
                    
                }
                .padding()
            }
            
        }
     
        .scrollIndicators(.hidden)
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

#Preview {
    NavigationStack{
        DetailView(coin:DeveloperPreview.instance.coin)
    }
    
}


extension DetailView{
    
    
    private var navigationBarTrailingItems : some View{
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundStyle(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overViewTitle : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var additionalTitle : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid : some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
    private var additionalGrid : some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            content: {
                ForEach(vm.additionalStatistics) { additional in
                    StatisticView(stat: additional)
                }
        })
    }
}
