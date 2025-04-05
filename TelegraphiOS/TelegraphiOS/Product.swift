//
//  Product.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 04/04/25.
//

import Foundation
struct Product: Codable {
    let id: Int64
    let name: String
    let price: Double
    let qrCode: String
    let image: Data? // Image is optional
}
enum APIActionType {
    case fetch
    case add(Product)
    case delete(Product)
    case update(Product)
}
