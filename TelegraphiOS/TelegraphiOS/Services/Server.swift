//
//  Server.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 05/04/25.
//

import Telegraph
import Foundation

class ProductServer {
    private var server: Server?

    func start() {
        server = Server()

        do {
            try server?.start(port: 9000)
            print("✅ Server started")
            setupRoutes()
        } catch {
            print("❌ Failed to start server: \(error)")
        }
    }

    private func setupRoutes() {
        server?.route(.GET, "/products") { request in
            let products = DatabaseHelper.shared.getAllProducts()
            do {
                let jsonData = try JSONEncoder().encode(products)
                var response = HTTPResponse(.ok, data: jsonData)
                response.headers["Content-Type"] = "application/json"
                return response
            } catch {
                return HTTPResponse(.internalServerError, content: "Failed to encode products")
            }
        }

        server?.route(.POST, "/products") { request in
            if let json = try? JSONSerialization.jsonObject(with: request.body) as? [String: Any],
               let name = json["name"] as? String,
               let price = json["price"] as? Double,
               let qrCode = json["qrCode"] as? String,
               let imageDataString = json["image"] as? String,
               let imageData = Data(base64Encoded: imageDataString) {
                
                DatabaseHelper.shared.addProduct(name: name, price: price, qrCode: qrCode, image: imageData)
                return HTTPResponse(.created, content: "Product added successfully")
            }
            return HTTPResponse(.badRequest, content: "Invalid data")
        }

        server?.route(.PUT, "/products/:id") { request in
            guard let idString = request.params["id"],
                  let id = Int64(idString),
                  let json = try? JSONSerialization.jsonObject(with: request.body) as? [String: Any],
                  let name = json["name"] as? String,
                  let price = json["price"] as? Double,
                  let qrCode = json["qrCode"] as? String,
                  let imageDataString = json["image"] as? String,
                  let imageData = Data(base64Encoded: imageDataString) else {
                return HTTPResponse(.badRequest, content: "Invalid or missing data")
            }

            DatabaseHelper.shared.updateProduct(id: id, name: name, price: price, qrCode: qrCode, image: imageData)
            return HTTPResponse(.ok, content: "✅ Product updated successfully")
        }

        server?.route(.DELETE, "/products/:id") { request in
            guard let idString = request.params["id"],
                  let id = Int64(idString) else {
                return HTTPResponse(.notFound, content: "Product not found")
            }

            DatabaseHelper.shared.deleteProduct(withId: id)
            return HTTPResponse(.ok, content: "Product deleted successfully")
        }
    }
}
