//
//  HomeView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel : HomeViewModel
    
    //animate right
    @State private var showPortfolio : Bool = false
    
    //new sheet
    @State private var showPortfolioView = false
    
    var body: some View {
        ZStack{
            Color.theme.bg
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(viewModel)
                })
            
            VStack{
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchValue: $viewModel.searchText)
                columnTitles
                
                if viewModel.searchText.count > 0, viewModel.allCoins.count == 0 {
                    Text("No result for \(viewModel.searchText)")
                        .foregroundStyle(Color.theme.red)
                        .padding(.vertical, 8)
                }
                
                if !showPortfolio{
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else{
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}



extension HomeView{
    private var homeHeader : some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(nil, value: UUID())
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(nil, value: UUID())
            
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring ()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
        
    }
    
    private var allCoinsList : some View{
        List{
            ForEach(viewModel.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                
            }
        }
        .scrollIndicators(.hidden)
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList : some View{
        List{
            ForEach(viewModel.portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles : some View{
        HStack{
            HStack(spacing:4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    viewModel.sortOption =  viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            
            if showPortfolio{
                HStack(spacing:4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0
                        )
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))

                }
                .onTapGesture {
                    withAnimation(.default){
                        viewModel.sortOption =  viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
               
            }
            HStack(spacing:4){
                Text("Prices")
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))

            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    viewModel.sortOption =  viewModel.sortOption == .price ? .priceReversed : .price
                }
            }
          
            
            
            Button {
                withAnimation(.linear(duration: 2.0)){
                    viewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}


#Preview {
    NavigationStack{
        HomeView()
            .navigationBarHidden(true)
            .environmentObject(DeveloperPreview.instance.homeVM)
    }
}
