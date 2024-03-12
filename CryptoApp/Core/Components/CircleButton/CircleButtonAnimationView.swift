//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate : Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1)
            .animation(animate ? Animation.easeOut(duration: 1.0) : nil, value: UUID())
            
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
}
