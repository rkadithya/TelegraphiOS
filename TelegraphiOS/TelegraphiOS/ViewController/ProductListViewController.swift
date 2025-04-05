//
//  ViewController.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 03/04/25.
//

import UIKit
import Telegraph
import CoreImage.CIFilterBuiltins

class ProductListViewController: UIViewController {

    var products: [Product] = []
    
    let productServer = ProductServer()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ProductTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: ProductTableViewCell.cellIdentifier)
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductTapped))
        
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "globe"),
            style: .plain,
            target: self,
            action: #selector(openWebView)
        )
        
   
        
        let scanButton = UIBarButtonItem(
            image: UIImage(systemName: "qrcode.viewfinder"),
            style: .plain,
            target: self,
            action: #selector(scanTapped))
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItems = [leftButton, scanButton]
        productServer.start()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10) // Make it larger
            let scaledImage = outputImage.transformed(by: transform)
            return UIImage(ciImage: scaledImage)
        }
        
        return nil
    }
    
    @objc func openWebView(){
        let webVC = ProductWebViewController()
        webVC.products = DatabaseHelper.shared.getAllProducts()
        navigationController?.pushViewController(webVC, animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchProducts()
    }
    
    
    
    func fetchProducts() {
        ProductAPIManager.shared.perform(action: .fetch) { result in
            switch result {
            case .success(let products):
                self.products = products
                self.tableView.reloadData()
            case .failure(let error):
                print("Fetch error: \(error)")
            }
        }
    }
    
    
    @objc func addProductTapped(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Product Upload", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func deleteProduct(at indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        ProductAPIManager.shared.perform(action: .delete(product)) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.products.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "❌ Failed to delete product: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func scanTapped() {
        let scannerVC = QRScannerViewController()
        scannerVC.delegate = self
        present(scannerVC, animated: true)
    }
    
}


extension ProductListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier, for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.row]
        cell.txtName.text = product.name
        cell.txtPrice.text = "$\(product.price)"
        let qrImage = generateQRCode(from: product.qrCode)
        cell.qrImageView.image = qrImage
        if let image = UIImage(data: product.image!) {
            cell.productImage.image = image
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProductViewController") as! EditProductViewController
        vc.product = selectedProduct
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteProduct(at: indexPath)
        }
    }
    
}

extension ProductListViewController : QRScannerDelegate {
    func didScan(qrCode: String) {
        print("Scanned QR: \(qrCode)")
        
        if let product = DatabaseHelper.shared.fetchProductByQRCode(qrCode) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
                detailVC.product = product
                navigationController?.pushViewController(detailVC, animated: true)
            }
        } else {
            showAlert(message: "❌ No product found for scanned QR code.")
        }
    }
    
}

