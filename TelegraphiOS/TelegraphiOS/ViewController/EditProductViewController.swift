//
//  EditProductViewController.swift
//  TelegraphiOS
//
//  Created by RK Adithya on 05/04/25.
//
//
import UIKit

class EditProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQRCode: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var btnPickImage: UIButton!
    var product: Product! // Set this from previous screen
    var selectedImageData: Data? // Optional, only if user changes image

    override func viewDidLoad() {
        super.viewDidLoad()

        txtName.delegate = self
        txtPrice.delegate = self
        txtQRCode.delegate = self

        title = "Edit Product"
        txtName.text = product.name
        txtPrice.text = "\(product.price)"
        txtQRCode.text = product.qrCode
        if let imageData = product.image {
            imageView.image = UIImage(data: imageData)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        btnPickImage.addGestureRecognizer(tapGesture)
    }

    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage,
           let data = pickedImage.jpegData(compressionQuality: 0.8) {
            imageView.image = pickedImage
            selectedImageData = data
        }
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        guard let name = txtName.text, !name.isEmpty,
              let priceString = txtPrice.text, let price = Double(priceString),
              let qrCode = txtQRCode.text, !qrCode.isEmpty else {
            print("⚠️ All fields are required.")
            return
        }

        // Use selected image if updated, else existing image
        guard let finalImage = selectedImageData ?? product.image else {
            print("⚠️ Image is required.")
            return
        }

        // Create updated product
        let updatedProduct = Product(
            id: product.id,
            name: name,
            price: price,
            qrCode: qrCode,
            image: finalImage
        )

        // First update via API
        ProductAPIManager.shared.perform(action: .update(updatedProduct)) { result in
            switch result {
            case .success:
                // ✅ If API success, update local DB
                DatabaseHelper.shared.updateProduct(
                    id: updatedProduct.id,
                    name: updatedProduct.name,
                    price: updatedProduct.price,
                    qrCode: updatedProduct.qrCode,
                    image: updatedProduct.image
                )

                DispatchQueue.main.async {
                    print("✅ Product updated successfully.")
                    self.navigationController?.popViewController(animated: true)
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "❌ Failed to update on server: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Product Upload", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension EditProductViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


