//
//  ProductDetailViewController.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 05/04/25.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var product: Product?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrCodeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Product Details"
        showProductDetails()
    }

    func showProductDetails() {
        guard let product = product else { return }

        nameLabel.text = "📦 Name: \(product.name)"
        priceLabel.text = "💰 Price: ₹\(product.price)"

        if let imageData = product.image {
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}

