//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 19.03.2024.
//

import SwiftUI

struct SettingsView: View {
    let linkedinUrl = URL(string: "https://www.linkedin.com/in/suayip-emre-sozen-b013b1218/")!
    let githubUrl = URL(string: "https://github.com/SuayipEmre")!
    let portfolioUrl = URL(string: "https://portfoliosuayipemresozen.netlify.app/")!

    
    var body: some View {
        NavigationStack{
            List {
                Section(content: {
                    VStack(alignment:.leading){
                        Image("logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("This is a crypto currency app. It uses MVVM Architecture And Core Data")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.theme.accent)
                    }
                }, header: {
                    Text("The App")
                })
                
                Section(content: {
                    VStack(alignment:.leading, spacing:12){
                            
                        HStack{
                            AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/140286752?v=4")) { image in
                                image.resizable()
                            
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            
                            VStack(alignment:.leading, spacing:12){
                                Text("Şuayip Emre Sözen")
                                    .bold()
                                    
                                Text("Mobile Developer")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            
                        }
                        
                        Group{
                            Link(destination: portfolioUrl) {
                                Text("Portfolio")
                            }
                            Link(destination: linkedinUrl) {
                                Text("Linkedin")
                            }
                            Link(destination: githubUrl) {
                                Text("Github")
                            }
                        }
                        .tint(.blue)
                       
                    }
                    
                }, header: {
                    Text("Developer")
                })
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }

        }
    }
    
}

#Preview {
    SettingsView()
}
