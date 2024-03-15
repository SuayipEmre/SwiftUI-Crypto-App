//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 16.03.2024.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let containerName = "PortfolioContainer"
    private let container : NSPersistentContainer
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntitites : [PortfolioEntity] = []
    
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let err = error{
                print("error loading core data! \(err)")
            }
            self.getPortfolio()
        }
    }
    
    
    
    // MARK: PUBLIC FUNCTIONS
    func updatePortfolio(coin : CoinModel, amount : Double){
        
        //check if coin is already in portfolio
        if let entity = savedEntitites.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity)
            }
        } else{
            add(coin: coin, amount: amount)
        }
        
            
            
            
    }
    
    
    // MARK: PRIVATE FUNCTIONS
    
    private func getPortfolio(){
        let req = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do{
            savedEntitites =  try container.viewContext.fetch(req)
        }catch let error{
            print("error fetching portfolio entities \(error)")
        }
    }
    
    private func add(coin : CoinModel, amount : Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity : PortfolioEntity, amount:  Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity : PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do{
            try container.viewContext.save()
            
        }catch let err{
            print("error saving to core data \(err)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
}
