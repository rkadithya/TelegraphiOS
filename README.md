# TelegraphiOS
iOS Product Inventory App with Embedded HTTP Server

🔹 Core Features:
Local Database: Uses SQLite via a DatabaseHelper to persist product data (name, price, QR code, image).

CRUD Operations:

✅ Create: Add products with image, price, and QR string.

🔄 Update: Edit any product details, while preserving unchanged data (like images).

🗑️ Delete: Swipe to delete products, both from local DB and via HTTP route.

🔍 Read: Display a table of products with name, price, product image, and generated QR code.

QR Code Generation: Dynamically generates a QR image from the provided string using CoreImage.

🌐 Embedded HTTP Server:
Uses Telegraph to host an internal RESTful API server on device.

Available routes:

GET /products — Returns all stored products as JSON.

POST /products — Accepts a product JSON with base64 image to save it.

DELETE /products/:id — Deletes a product by ID from the database.

📦 Architecture:
Modularized ServerManager.swift to handle all server logic.

Clean MVC separation:

ViewController for UI & networking

DatabaseHelper for persistence

Product model (Codable)

ServerManager for Telegraph routes


