//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName : String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .frame(width: 50, height: 50)
            .foregroundStyle(Color.theme.accent)
            
            .background(
                Circle()
                    .foregroundStyle(Color.theme.bg)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius:10, x:0, y:0 )
            .padding()
            
    }
}

#Preview {
    CircleButtonView(iconName: "heart.fill")
        .padding()
        .previewLayout(.sizeThatFits)
}
