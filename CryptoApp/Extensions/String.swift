//
//  String.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 19.03.2024.
//

import Foundation

extension String{
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
