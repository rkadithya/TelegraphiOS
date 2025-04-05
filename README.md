# TelegraphiOS
📱 iOS Product Inventory App with Embedded HTTP Server & QR Code Integration
An all-in-one iOS inventory management system built using Swift that features local data storage, QR scanning, embedded web server, and product listing in a WebView.

🔹 Core Features:
✅ Add, Edit, Delete Products

Product has: Name, Price, Image, QR Code string

Image and QR data is preserved if not changed during editing

📷 QR Code Scanning

Scan a QR code using camera

Instantly fetch and display the matching product detail from the local database

🧾 QR Code Generation

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

QRScannerViewController – Scans QR and shows product info

ProductWebViewController – Displays server-hosted product list

ServerManager.swift – Centralized HTTP server setup using Telegraph

DatabaseHelper.swift – Handles SQLite interaction

Product.swift – Codable model for data representation
