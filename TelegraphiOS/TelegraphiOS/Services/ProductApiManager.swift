//
//  ProductApiManager.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 05/04/25.
//

import Foundation
import UIKit


class ProductAPIManager {
    
    static let shared = ProductAPIManager()
    private init() {}
    
    let baseURL = "http://localhost:9000/products"
    
    func perform(action: APIActionType, completion: @escaping (Result<[Product], Error>) -> Void) {
        
        var request: URLRequest
        
        switch action {
            
        case .fetch:
            guard let url = URL(string: baseURL) else { return }
            request = URLRequest(url: url)
            request.httpMethod = "GET"
            
        case .delete(let product):
            guard let url = URL(string: "\(baseURL)/\(product.id)") else { return }
            request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
        case .add(let product), .update(let product):
            let isUpdate = {
                if case .update = action { return true }
                return false
            }()
            
            let urlString = isUpdate ? "\(baseURL)/\(product.id)" : baseURL
            guard let url = URL(string: urlString),
                  let imageData = product.image else { return }
            
            let imageBase64 = imageData.base64EncodedString()
            let params: [String: Any] = [
                "name": product.name,
                "price": product.price,
                "qrCode": product.qrCode,
                "image": imageBase64
            ]
            
            request = URLRequest(url: url)
            request.httpMethod = isUpdate ? "PUT" : "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                
                if let json = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),
                   let jsonString = String(data: json, encoding: .utf8) {
                    print("📦 JSON Payload:\n\(jsonString)")
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: params)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DataNil", code: 0)))
                }
                return
            }
            
            switch action {
                
            case .fetch:
                do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(products))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                
            case .delete(let product):
                DispatchQueue.main.async {
                    DatabaseHelper.shared.deleteProduct(withId: product.id)
                    completion(.success([]))
                }
                
            case .add, .update:
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 201 || httpResponse?.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                } else {
                    let error = NSError(domain: "AddOrUpdateError", code: httpResponse?.statusCode ?? 500)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
}
