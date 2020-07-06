//
//  PTrackerViewController.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 5/28/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import Firebase
import SWSegmentedControl

class PTrackerViewController: UIViewController, SWSegmentedControlDelegate {
   
    
    var ref: DatabaseReference!
    @IBOutlet weak var segmentedControl: SWSegmentedControl!
    
    @IBOutlet weak var devStage: UILabel!
    @IBOutlet weak var streakStage: UILabel!
    @IBOutlet weak var cRemainingStage: UILabel!
    @IBOutlet weak var cCompletedStage: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var percentage: UILabel!
    
    
    @IBOutlet weak var nameStage: UILabel!
    
    // get these values from array in database
    // numTotal should be total challenges in category
    // numComplete should be completed challenges in category
    let numComplete = 2
    let numT = 5
    
    
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
        
        let p = 100*numComplete/numT
        print("percentage:", p)
        percentage.text = String(p) + "%"
        
        
        // draw track for progress to be laid on
        let trackLayer = CAShapeLayer()
        
        let circularPathTrack = UIBezierPath(arcCenter: .init(x: 310, y: 700), radius: 55, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let d = calcDeg(numChallengesDone: 2, numTotal: 5)
        print("radians:", d)
        
        let circularPath = UIBezierPath(arcCenter: .init(x: 310, y: 700), radius: 55, startAngle: -CGFloat.pi / 2, endAngle: (d - (CGFloat.pi / 2) ), clockwise: true)
        
        trackLayer.path = circularPathTrack.cgPath
        
        
        trackLayer.strokeColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 5
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
        // draw progress circle
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        // uncomment below once animation fixed
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        
        shapeLayer.strokeEnd = 0
        
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(shapeLayer)
        
      
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        progressAnimation.toValue = 1
        progressAnimation.duration = 1
        progressAnimation.fillMode = CAMediaTimingFillMode.forwards
        progressAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(progressAnimation, forKey: "loadProgress")
    
        
    // loading info from database
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        if (!userID.isEmpty) {
            
            ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                let name = value?["name"] as? String ?? ""
                
                let frogName = value?["frogName"] as? String ?? ""
                
                let imgURL = value?["imgURL"] as? String ?? ""
                
                let url = URL(string: imgURL)
                
                let challenges = value?["challenges"] as? [String] ?? []
                
                if (!imgURL.isEmpty){
                    self.downloadImage(from: url!)
                }
                
                // need to test if names were correctly changed in database
                // can't edit my challenges rn
                
                self.name.text = name
                
                let segmentedControl = SWSegmentedControl(items: [challenges[0], challenges[1], challenges[2]])
                
                
                segmentedControl.delegate = self
                
                segmentedControl.selectedSegmentIndex = 1
                
                segmentedControl.frame = CGRect(x: 0, y: 290, width: 430, height: 60)
                
                segmentedControl.center.x = self.view.center.x
                segmentedControl.indicatorColor = UIColor(red: 0.93, green: 0.46, blue: 0.18, alpha: 1.00)
                segmentedControl.titleColor = UIColor(red: 0.93, green: 0.46, blue: 0.18, alpha: 1.00)
                
                segmentedControl.font = UIFont(name: "Quicksand-Light_Bold", size: 15.0)!
                
                
                self.view.addSubview(segmentedControl)
              
                
                self.nameStage.text = frogName + "\'s Stage"
                
            }
        }
    }
    func calcDeg(numChallengesDone: CGFloat, numTotal: CGFloat) -> CGFloat {
        let percentage = (numChallengesDone/numTotal)
        let deg = percentage * 360
        
        // convert deg to radian
        let rad = (CGFloat.pi/180) * deg
        
        return rad
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


