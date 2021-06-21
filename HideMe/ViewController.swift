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

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var firstImage: UIImageView!
    @IBOutlet weak var hidenMesaheField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet weak var imageUid: UITextField!
    @IBOutlet weak var imagePassword: UITextField!
    
    let db = Firestore.firestore().collection("images")
    let storage = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    var imagePicker = UIImagePickerController()

    


    @IBAction func butonClicked(_ sender: UIButton) {
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
        
        
        firstImage.image = info[.originalImage] as? UIImage
        
    }
    
    @IBAction func uploadProcess(_ sender: Any) {
        let data = Encoder.init().encode(image: UIImage(named: "asd")!, data: hidenMesaheField.text!)?.pngData()!
        
        var ref: DocumentReference? = nil
        ref = db.addDocument(data: [
            "receiver" : "",
            "password": sha256(data: Data(passwordField.text!.utf8)),
            "sender" : "",
            "willDeletedAfterDownload": true
        ]) { (err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            self.storage.child("images/\(ref!.documentID).png").putData(data!, metadata: nil) { (metaData, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
            }
            
        }
    }
    
    @IBAction func downloadProcess(_ sender: Any) {
        db.document(imageUid.text!).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let password = snapshot?.data()!["password"] as? Data
            if let pass = password, pass == self.sha256(data: Data(self.imagePassword.text!.utf8)) {
                self.storage.child("images/\(snapshot!.documentID).png").getData(maxSize: 40 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                      // Data for "images/island.jpg" is returned
                      let image = UIImage(data: data!)
                        self.secondImage.image = image
                    }
                  }
            }
        }
    }
    
    
    @IBAction func decodeProcess(_ sender: Any) {
        if let image = secondImage.image {
            print(Decoder.init().decode(image: image))
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

