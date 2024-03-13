//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 14.03.2024.
//

import Foundation
import SwiftUI
class LocalFileManager{
    static let instance = LocalFileManager()
    
    private init(){}
    
    
    func saveImage(image : UIImage, imageName : String, FolderName : String){
        //create folder
        createFolderIFNeeded(folderName: FolderName)
        
        //get path for image
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: FolderName)
        else{return}
        
        //save image to path
        do{
            try data.write(to: url)
        }catch let err{
            print("image could not saved. \(err)")
        }
    }
    
    
    func getImage(imageName : String, folderName : String) -> UIImage?  {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {return nil}
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIFNeeded(folderName : String){
        guard let url = getUrlForFolder(folderName: folderName) else {return}
        
        if !FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }catch let err{
                print(err)
            }
        }
            
    }
    
    
    private func getUrlForFolder(folderName : String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else{return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName : String, folderName : String) -> URL?{
        guard let folderURL = getUrlForFolder(folderName: folderName) else {return nil}
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
