//
//  ProfileViewController.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 5/28/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var profPic: UIImageView!
        
    @IBOutlet weak var name: UILabel!
        
    @IBOutlet weak var signOutButton: UIButton!
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
        name.layer.masksToBounds = true
        name.layer.cornerRadius = name.frame.height/2
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        if (!userID.isEmpty) {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let imgURL = value?["imgURL"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                self.name.text = name
                let url = URL(string: imgURL)
                
                self.downloadImage(from: url!)
                
                print(email)
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func tappedEditProfile(_ sender: Any) {
    }
    
    @IBAction func tappedSignOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let userDefault = UserDefaults.standard
            userDefault.set(false, forKey: "hasLoggedIn")
            print("User signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
