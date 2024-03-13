//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 14.03.2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchValue : String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchValue.isEmpty ? Color.theme.secondaryText  :
                        Color.theme.accent
                )
            TextField("Search by name or symbol", text: $searchValue)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchValue.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchValue = ""
                            
                        }
                    ,alignment: .trailing
                )
                
        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.theme.bg)
            .shadow(color : Color.theme.accent.opacity(0.15),radius: 10, x:0, y:0)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchValue: .constant(""))
}
