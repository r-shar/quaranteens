//
//  SignUpViewController.swift
//  Quaranteen Project
//
//  Created by Can Dang on 2020-05-02.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class SignUpViewController: UIViewController, GIDSignInDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
          withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "category")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "hasLoggedIn")
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

}
