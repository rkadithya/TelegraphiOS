//
//  DatabaseHelper.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 04/04/25.
//

import SQLite

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private var db: Connection?
    
    // Table and columns
    private let products = Table("products")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let price = Expression<Double>("price")
    private let qrCode = Expression<String>("qr_code") // QR Code as string
    private let imageData = Expression<Data?>("image") // Image stored as Data (optional)

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/products.sqlite3")
            
            // Create table
            try db?.run(products.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement) // Auto-incrementing ID
                table.column(name)
                table.column(price)
                table.column(qrCode)
                table.column(imageData)
            })
            
            print("✅ Database initialized")
        } catch {
            db = nil
            print("❌ Failed to initialize database: \(error)")
        }
    }

    // 🔹 GET: Retrieve all products
    func getAllProducts() -> [Product] {
        var productList: [Product] = []
        do {
            for product in try db!.prepare(products) {
                let productItem = Product(
                    id: product[id],
                    name: product[name],
                    price: product[price],
                    qrCode: product[qrCode],
                    image: product[imageData] // Image is optional
                )
                productList.append(productItem)
            }
        } catch {
            print("❌ Error retrieving products: \(error)")
        }
        return productList
    }

    // 🔹 POST: Insert a new product
    func addProduct(name: String, price: Double, qrCode: String, image: Data?) {
        do {
            let insert = products.insert(
                self.name <- name,
                self.price <- price,
                self.qrCode <- qrCode,
                self.imageData <- image
            )
            try db?.run(insert)
            print("✅ Product added successfully")
        } catch {
            print("❌ Failed to add product: \(error)")
        }
    }
    
    // 🔹 DELETE: Remove a product by ID
    func deleteProduct(withId productId: Int64) {
        do {
            let productToDelete = products.filter(id == productId)
            try db?.run(productToDelete.delete())
            print("✅ Product deleted from database")
        } catch {
            print("❌ Failed to delete product: \(error)")
        }
    }

    
    // 🔹 UPDATE: Update a product
    func updateProduct(id: Int64, name: String, price: Double, qrCode: String, image: Data?) {
        let productToUpdate = products.filter(self.id == id)

        do {
            try db?.run(productToUpdate.update(
                self.name <- name,
                self.price <- price,
                self.qrCode <- qrCode,
                self.imageData <- image
            ))
            print("✅ Product updated successfully")
        } catch {
            print("❌ Failed to update product: \(error)")
        }
    }
    
    func fetchProductByQRCode(_ qrCodeToSearch: String) -> Product? {
        do {
            let filteredProduct = products.filter(self.qrCode == qrCodeToSearch)
            
            if let productRow = try db?.pluck(filteredProduct) {
                return Product(
                    id: productRow[id],
                    name: productRow[name],
                    price: productRow[price],
                    qrCode: productRow[qrCode],
                    image: productRow[imageData]
                )
            }
        } catch {
            print("❌ Error fetching product by QR Code: \(error)")
        }
        
        return nil
    }



    
    
}
