# TelegraphiOS
📱 iOS Product Inventory App with Embedded HTTP Server & QR Code Integration
An all-in-one iOS inventory management system built using Swift that features local data storage, QR scanning, embedded web server, and product listing in a WebView.





🔹 Core Features:
✅ Add, Edit, Delete Products

Product has: Name, Price, Image, QR Code string

<!-- Markdown (won't resize) -->
![Product View](https://github.com/user-attachments/assets/012eb4c6-7cf0-417f-bf24-835a2205bd49/IMG_4901)



Image and QR data is preserved if not changed during editing

📷 QR Code Scanning

Scan a QR code using camera

Instantly fetch and display the matching product detail from the local database

🧾 QR Code Generation
![IMG_4902](https://github.com/user-attachments/assets/3eed1e47-a80e-4d4d-81c6-1e5e79328be4)

Generates a scannable QR code for every product’s QR string using CoreImage

QR image is displayed within product cells

🌐 Embedded HTTP Server (via Telegraph)

GET /products — Fetch all products

POST /products — Add a new product (with image encoded in base64)

DELETE /products/:id — Delete a product

Serves all data from local SQLite DB

🗂️ Local SQLite Storage

Uses a DatabaseHelper class to interact with SQLite for storing product info

🌍 Product List in WebView

The server also provides a web-accessible version of the product list

A simple HTML-based product catalog is rendered inside a WKWebView in-app

📦 Architecture:
ProductListViewController – UI, product list & table view logic

EditProductViewController – Edit screen for updating items

AddProductViewController – New product screen
![IMG_4903](https://github.com/user-attachments/assets/db1bb15f-9379-498f-9784-1f09d4859598)

QRScannerViewController – Scans QR and shows product info

ProductWebViewController – Displays server-hosted product list
![IMG_4905](https://github.com/user-attachments/assets/7c916e90-2a0c-4f9a-af16-eeaca376502b)

ServerManager.swift – Centralized HTTP server setup using Telegraph

DatabaseHelper.swift – Handles SQLite interaction

Product.swift – Codable model for data representation
