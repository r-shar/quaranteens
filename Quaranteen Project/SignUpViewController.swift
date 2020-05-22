//
//  SignUpViewController.swift
//  Quaranteen Project
//
//  Created by Can Dang on 2020-05-02.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        // Do any additional setup after loading the view.
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
