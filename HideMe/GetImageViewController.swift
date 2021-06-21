//
//  ViewController.swift
//  HideMe
//
//  Created by Said Çankıran on 9.06.2021.
//

import UIKit
import CommonCrypto
import FirebaseFirestore
import FirebaseStorage
import ProgressHUD
import RNCryptor

class GetImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var secondImage: UIImageView!
    @IBOutlet weak var imageUid: UITextField!
    @IBOutlet weak var imagePassword: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    let db = Firestore.firestore().collection("images")
    let storage = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func downloadProcess(_ sender: Any) {
        ProgressHUD.show()
        db.document(imageUid.text!).getDocument { (snapshot, error) in
            if let error = error {
                ProgressHUD.showFailed(error.localizedDescription)
                return
            }
            
            let password = snapshot?.data()!["password"] as? Data
            let willDeleted = snapshot?.data()!["willDeletedAfterDownload"] as? Bool
            if let pass = password, pass == self.sha256(data: Data(self.imagePassword.text!.utf8)) {
                self.storage.child("images/\(snapshot!.documentID).png").getData(maxSize: 40 * 1024 * 1024) { data, error in
                    if let error = error {
                        ProgressHUD.showFailed(error.localizedDescription)
                        return
                    } else {
                      // Data for "images/island.jpg" is returned
                        if let deleted = willDeleted, deleted {

                        }
                        ProgressHUD.showSuccess()
                      let image = UIImage(data: data!)
                        self.secondImage.image = image
                    }
                  }
            }
        }
    }
    
    
    @IBAction func decodeProcess(_ sender: Any) {
        if let image = secondImage.image {
            do {
                ProgressHUD.show()
                let data = Data(base64Encoded: Decoder.init().decode(image: image)!, options: .ignoreUnknownCharacters)
                let originalData = try RNCryptor.decrypt(data: data!, withPassword: imagePassword.text!)
                messageLabel.text = String(decoding: originalData, as: UTF8.self)
                ProgressHUD.showSuccess()

            } catch {
                print(error)
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

