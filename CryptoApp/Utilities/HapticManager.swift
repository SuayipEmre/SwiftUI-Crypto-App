//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Şuayip Emre on 16.03.2024.
//

import Foundation
import SwiftUI

class HapticManager{
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type : UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}

