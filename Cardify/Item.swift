//
//  Item.swift
//  Cardify
//
//  Created by Jack Hodges on 29/3/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
