//
//  EditProfileViewController.swift
//  Quaranteen Project
//
//  Created by Charlize Dang on 2020-05-31.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var frogName: UITextField!
    @IBOutlet weak var profPic: UIImageView!
    
    @IBOutlet weak var growth1: UILabel!
    @IBOutlet weak var growth2: UILabel!
    @IBOutlet weak var growth3: UILabel!
    
    var imageURL: String = ""
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var birthday: UITextView!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        //save the information
        //save to database
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        if (imageURL.isEmpty) {
            ref.child("users").child(userID).updateChildValues(["name": name.text!, "frogName" : frogName.text!])
        } else {
            ref.child("users").child(userID).updateChildValues(["name": name.text!, "imgURL": imageURL, "frogName" : frogName.text!])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        /*growth1.layer.masksToBounds = true
        growth1.layer.cornerRadius = 20
        growth2.layer.masksToBounds = true
        growth2.layer.cornerRadius = 20 */
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profPic.layer.masksToBounds = true
        profPic.layer.cornerRadius = profPic.frame.height/2
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        if (!userID.isEmpty) {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let imgURL = value?["imgURL"] as? String ?? ""
                self.name.text = name
                let url = URL(string: imgURL)
                let frogName = value?["frogName"] as? String ?? ""
                self.frogName.text = frogName
                if (!imgURL.isEmpty) {
                    self.downloadImage(from: url!)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.profPic.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func editImageClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .savedPhotosAlbum
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        //self.imageURL = info[.imageURL]

        //finish edit image then add done button to keyboard when first naming frog 
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                guard let metadata = metadata else {
                    return
                }
                
                let size = metadata.size
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    
                    self.imageURL = downloadURL.absoluteString
                    
                }
                
                
            }
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneButton], animated: true)
        
        birthday.inputAccessoryView = toolbar
        birthday.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc public func donePressed() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthday.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
}
