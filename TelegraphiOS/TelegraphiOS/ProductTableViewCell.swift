//
//  ProductTableViewCell.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 05/04/25.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ProductTableViewCell"

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var txtQrCode: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
