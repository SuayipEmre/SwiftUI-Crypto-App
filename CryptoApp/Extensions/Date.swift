//
//  Date.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 18.03.2024.
//

import Foundation


extension Date {

  // "2021-03-13T20:49:26.606Z"
  init(coinGeckoString: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = formatter.date(from: coinGeckoString) ?? Date()
    self.init(timeInterval: 0, since: date)
  }

  /// Creates a formatted string representation of the date in MM/dd/yyyy format.
  func asShortDateString(format: String = "MM/dd/yyyy") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}
