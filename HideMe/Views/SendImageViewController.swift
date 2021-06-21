//
//  SendImageViewController.swift
//  HideMe
//
//  Created by Said Çankıran on 21.06.2021.
//

import UIKit
import CommonCrypto
import FirebaseFirestore
import FirebaseStorage
import ProgressHUD
import RNCryptor

class SendImageViewController:  UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var hiddenMessageField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let db = Firestore.firestore().collection("images")
    let storage = Storage.storage().reference()
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var switchView: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func selectImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
           
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
        })
        
        
        imageView.image = info[.originalImage] as? UIImage
        
    }
    
    @IBAction func sendImage(_ sender: Any) {
        let messageData = Data(hiddenMessageField.text!.utf8)
        let password = passwordField.text!
        let ciphertext = RNCryptor.encrypt(data: messageData, withPassword: password)
        
        let data = Encoder.init().encode(image: imageView.image!, data: ciphertext.base64EncodedString())?.pngData()!
        
        var ref: DocumentReference? = nil
        ref = db.addDocument(data: [
            "receiver" : "",
            "password": sha256(data: Data(passwordField.text!.utf8)),
            "sender" : "",
            "willDeletedAfterDownload": switchView.isOn
        ]) { (err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            ProgressHUD.show()
            self.storage.child("images/\(ref!.documentID).png").putData(data!, metadata: nil) { (metaData, err) in
                if let err = err {
                    ProgressHUD.showFailed(err.localizedDescription)
                    return
                }
                
                ProgressHUD.showSuccess()
                self.uidLabel.text = ref?.documentID ?? ""
                
                
            }
            
        }
    }
    
    func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    
    
}
