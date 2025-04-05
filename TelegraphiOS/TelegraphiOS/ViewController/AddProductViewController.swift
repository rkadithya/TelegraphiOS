//
//  AddProductViewController.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 04/04/25.
//

import UIKit

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var qrCodeTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @IBAction func addProductTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let priceString = priceTextField.text, let price = Double(priceString),
              let qrCode = qrCodeTextField.text, !qrCode.isEmpty,
              let image = productImageView.image,
                let imageData = image.jpegData(compressionQuality: 0.8) else {
                              showAlert(message: "Please fill in all fields and select an image.")
                              return
                          }
        
        let newProduct = Product(id: 0, name: name, price: price, qrCode: qrCode, image: imageData)
        
        ProductAPIManager.shared.perform(action: .add(newProduct)) { result in
            switch result {
            case .success:
                self.showAlert(message: "✅ Product added successfully!")
            case .failure(let error):
                self.showAlert(message: "❌ Failed to add product: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            productImageView.image = image
        }
    }

//    @IBAction func closeButtonPressed(_ sender: Any) {
//        
//        navigationController?.popViewController(animated: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        priceTextField.delegate = self
        qrCodeTextField.delegate = self

        title = "Add Product"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Product Upload", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in 
            self.navigationController?.popViewController(animated: true)

        }))
        present(alert, animated: true)
    }

}

extension AddProductViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

