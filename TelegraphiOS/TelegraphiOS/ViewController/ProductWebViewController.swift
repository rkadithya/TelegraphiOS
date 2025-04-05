//
//  ProductWebViewController.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 05/04/25.
//

import UIKit
import WebKit

class ProductWebViewController: UIViewController {
    
    var webView: WKWebView!

    var products: [Product] = [] // Pass this before presenting

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product List"

        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)

        loadProductHTML()
    }

    func loadProductHTML() {
        var html = """
        <html>
        <head>
        <style>
        body { font-family: -apple-system; padding: 20px; }
        h2 { color: #333; }
        .product { margin-bottom: 30px; border-bottom: 1px solid #ccc; padding-bottom: 15px; }
        .price { color: #007AFF; }
        img { max-width: 100%; height: auto; margin-top: 10px; border-radius: 8px; }
        </style>
        </head>
        <body>
        <h1>Product List</h1>
        """

        for product in products {
            html += """
            <div class='product'>
                <h2>\(product.name)</h2>
                <p class='price'>Price: ₹\(product.price)</p>
                <p>QR Code: \(product.qrCode)</p>
            """

            // 🔽 Convert image data to base64
            if let imageData = product.image {
                let base64String = imageData.base64EncodedString()
                html += "<img src='data:image/png;base64,\(base64String)' alt='Product Image' />"
            }

            html += "</div>"
        }

        html += "</body></html>"

        webView.loadHTMLString(html, baseURL: nil)
    }
}
