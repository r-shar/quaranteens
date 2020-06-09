//
//  AppDelegate.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 4/22/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize sign-in
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        Database.database().isPersistenceEnabled = true
//        let loggedIn = UserDefaults.standard.bool(forKey: "hasLoggedIn")
//
//        if (loggedIn) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "challengeTab") as? UITabBarController
//            self.window?.rootViewController = vc
//        }
        
        if (Auth.auth().currentUser != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "signUp")
            
            let currentUser = Auth.auth().currentUser?.uid ?? ""
                        
            if (!currentUser.isEmpty) {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                ref.child("users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let frogName = value?["frogName"] as? String ?? ""
                    let challenges = value?["challenges"] as? [String] ?? []
                    
                    if (challenges.isEmpty) {
                        let vc = storyboard.instantiateViewController(withIdentifier: "category")
                        vc.modalPresentationStyle = .fullScreen
                        self.window?.rootViewController = vc
                    } else if (frogName.isEmpty) {
                        let vc = storyboard.instantiateViewController(withIdentifier: "frog")
                        vc.modalPresentationStyle = .fullScreen
                        self.window?.rootViewController = vc
                    } else {
                        let vc = storyboard.instantiateViewController(withIdentifier: "challengeTab") as? UITabBarController
                        self.window?.rootViewController = vc
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            
            } else {
                vc.modalPresentationStyle = .fullScreen
                self.window?.rootViewController = vc
            }
            
        }
        
        // for tab bar and tab bar button appearance
        UITabBar.appearance().tintColor = .darkGray
        return true
        
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //Use this to get information from signed in user, ex: getting their name, etc.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("Failed to log into Google", error)
            return
        }
        // Perform any operations on signed in user here.
       
        // Firebase Sign In
        print("Successfully logged into Google")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error")
                print(error)
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "category")
            vc.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = vc
            
//            UserDefaults.standard.set(true, forKey: "hasLoggedIn")
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let givenName = user.profile.givenName
            let email = user.profile.email
            
            let dimension = round(100 * UIScreen.main.scale)
            let pic = user.profile.imageURL(withDimension: UInt(dimension))
            
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let frogName = value?["frogName"] as? String ?? ""
                let challenges = value?["challenges"] as? [String] ?? []
                let name = value?["name"] as? String ?? ""
                let userEmail = value?["email"] as? String ?? ""
                let imgURL = value?["imgURL"] as? String ?? ""
                
                if (name.isEmpty) {
                    ref.child("users").child(userID).updateChildValues(["name": givenName!])
                }
                
                if (userEmail.isEmpty) {
                    ref.child("users").child(userID).updateChildValues(["email": email!])
                }
                
                if (imgURL.isEmpty) {
                    ref.child("users").child(userID).updateChildValues(["imgURL": pic?.absoluteString])
                }
                
                if (challenges.isEmpty) {
                    let vc = storyboard.instantiateViewController(withIdentifier: "category")
                    vc.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = vc
                } else if (frogName.isEmpty) {
                    let vc = storyboard.instantiateViewController(withIdentifier: "frog")
                    vc.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = vc
                } else {
                    let vc = storyboard.instantiateViewController(withIdentifier: "challengeTab") as? UITabBarController
                    vc?.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = vc
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            print("User is signed in with Firebase")
        }
        
    }
    
    
    //This function handles operations when the user disconnects from the app
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
}

