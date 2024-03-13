//
//  HomeView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel : HomeViewModel
    
    @State private var showPortfolio : Bool = false
    var body: some View {
        ZStack{
            Color.theme.bg
                .ignoresSafeArea()
            
            VStack{
                homeHeader
                SearchBarView(searchValue: $viewModel.searchText)
                columnTitles
               
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
            Text("Coin")
            Spacer()
            if showPortfolio{
                Text("Holdings")
            }
         
            Text("Prices")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
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
