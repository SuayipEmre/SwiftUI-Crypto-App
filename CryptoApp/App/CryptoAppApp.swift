//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
