//
//  HomeView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio : Bool = false
    var body: some View {
        ZStack{
            Color.theme.bg
                .ignoresSafeArea()
            
            VStack{
                homeHeader
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationStack{
        HomeView()
            .navigationBarHidden(true)
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
}
