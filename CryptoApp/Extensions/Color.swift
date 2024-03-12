//
//  Color.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import Foundation
import SwiftUI


extension Color{
    static let theme = ColorTheme()
}



struct ColorTheme{
    let accent = Color("AccentColor")
    let bg = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
