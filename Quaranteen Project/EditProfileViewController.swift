//
//  EditProfileViewController.swift
//  Quaranteen Project
//
//  Created by Charlize Dang on 2020-05-31.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var frogName: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        //save the information
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profPic.layer.masksToBounds = true
        profPic.layer.borderWidth = 6
        profPic.layer.borderColor = UIColor.white.cgColor
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
                       let email = value?["email"] as? String ?? ""
                       self.email.text = email
                       let frogName = value?["frogName"] as? String ?? ""
                       self.frogName.text = frogName
                       self.downloadImage(from: url!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
