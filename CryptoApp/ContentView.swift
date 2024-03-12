//
//  ContentView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 12.03.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
   

    var body: some View {
        ZStack{
            Color.theme.bg
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing:24){
                Text("accent color")
                    .foregroundStyle(Color.theme.accent)
                Text("secondary text color")
                    .foregroundStyle(Color.theme.secondaryText)
                Text("Red Color color")
                    .foregroundStyle(Color.theme.red)
                Text("green color")
                    .foregroundStyle(Color.theme.green)
            }
                
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
