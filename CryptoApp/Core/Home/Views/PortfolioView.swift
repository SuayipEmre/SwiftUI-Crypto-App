//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 15.03.2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var selectedCoin : CoinModel? = nil
    
    @State private var quantityText : String = ""
    
    @State private var showCheckmark = false
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment:.leading, spacing: 0){
                    SearchBarView(searchValue: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil{
                        portfoloInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading){
                    XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing){
                    trailingNavBarItems
                }
            })
            
            
            
            
        }
        
    }
}
/*
 
 
 #Preview {
     PortfolioView()
         .environmentObject(DeveloperPreview.instance.homeVM)
 }

 */

extension PortfolioView{
    
    private var coinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing:10){
                ForEach(vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 70)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                selectedCoin = coin
                            }
                        }
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private var portfoloInputSection : some View{
        VStack(spacing:20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "") :")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(nil, value: UUID())
        .padding()
        .font(.headline)
    }
    
    
    
    private var trailingNavBarItems : some View{
        HStack(spacing:20){
           Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPresed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ?
                1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0 )
        }
        return 0.0
    }
    
    private func saveButtonPresed(){
        guard let coin = selectedCoin else{return}
        
        //save to portfolio
        
        //show checkmark
        withAnimation(.easeIn){
            showCheckmark = true
            removeSelectedCoin()
        }
        
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
