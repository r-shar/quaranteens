//
//  PTrackerViewController.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 5/28/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import Firebase

class PTrackerViewController: UIViewController {
   
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var devStage: UILabel!
    @IBOutlet weak var streakStage: UILabel!
    @IBOutlet weak var cRemainingStage: UILabel!
    @IBOutlet weak var cCompletedStage: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        devStage.layer.cornerRadius = 20.0
        streakStage.layer.cornerRadius = 20.0
        cRemainingStage.layer.cornerRadius = 20.0
        cCompletedStage.layer.cornerRadius = 20.0
        
        profPic.layer.cornerRadius = 65.0
        profPic.clipsToBounds = true
        devStage.clipsToBounds = true
        streakStage.clipsToBounds = true
        cRemainingStage.clipsToBounds = true
        cCompletedStage.clipsToBounds = true
        
        devStage.backgroundColor = UIColor(red: 0.33, green: 0.77, blue: 0.42, alpha: 1.00)
        
        streakStage.backgroundColor = UIColor(red: 0.93, green: 0.46, blue: 0.18, alpha: 1.00)
        
        cRemainingStage.backgroundColor = UIColor(red: 1.00, green: 0.78, blue: 0.31, alpha: 1.00)
        
        cCompletedStage.backgroundColor = UIColor(red: 0.38, green: 0.58, blue: 0.95, alpha: 1.00)
        
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        if (!userID.isEmpty) {
            
            ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                let name = value?["name"] as? String ?? ""
                
                let imgURL = value?["imgURL"] as? String ?? ""
                
                let url = URL(string: imgURL)
                
                if (!imgURL.isEmpty){
                    self.downloadImage(from: url!)
                }
                
                self.name.text = name
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


