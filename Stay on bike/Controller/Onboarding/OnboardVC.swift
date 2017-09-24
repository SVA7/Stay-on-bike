//
//  StoryboardExampleViewController.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SwiftyOnboard

class OnboardVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    
    let locationManager = CLLocationManager()
    let status = CLLocationManager.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checLoc()
    }
    
    var locEnabled: Bool?
    
    func checLoc() {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            locEnabled = true
            
        } else {
            
            locEnabled = false
        }
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleAuthorization() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: NSLocalizedString("Background Location Access Disabled", comment: ""), message: NSLocalizedString("In order to show the location weather forecast, please open this app's settings and set location access to 'While Using'.", comment: ""), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Open Settings", style: .`default`, handler: { action in
                    if #available(iOS 10.0, *) {
                        let settingsURL = URL(string: UIApplicationOpenSettingsURLString)!
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    } else {
                        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(url as URL)
                        }
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                self.performSegue(withIdentifier: "getStarted", sender: nil)
                UserDefaults.standard.set(true, forKey: "launch")
            }
        }

    }
    
    @objc func handlePrivacy() {
        self.performSegue(withIdentifier: "toPrivacy", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension OnboardVC: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.image.image = UIImage(named: "Onboard_\(index)")
        if index == 0 {
            //On the first page, change the text in the labels to say the following:
            view?.titleLabel.text = "WELCOME TO STAY ON BIKE"
            view?.subTitleLabel.text = "We present best app for your bike riding"
        } else if index == 1 {
            //On the second page, change the text in the labels to say the following:
            view?.titleLabel.text = "JUST FIND WHAT YOU NEED"
            view?.subTitleLabel.text = "-Water -Bike shop -Parking -Trail/bike park -Bicycle repair shop -Bicycle rental"
            
        } else {
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "GO TO RIDE"
            view?.subTitleLabel.text = "Make easy your ride"
        }
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skipBT.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.authorizBT.addTarget(self, action: #selector(handleAuthorization), for: .touchUpInside)
        overlay?.privasyBT.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
        
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.authorizBT.tag = Int(position)
        overlay.authorizBT.isHidden = true
        
        if currentPage == 0 {
        
            overlay.authorizBT.isHidden = true
            overlay.skipBT.setTitle(NSLocalizedString("S K I P", comment: ""), for: .normal)
            overlay.skipBT.isHidden = false
            
        }else if currentPage == 1 {
            overlay.authorizBT.isHidden = true
            overlay.skipBT.isHidden = true
            
        } else {
            overlay.authorizBT.isHidden = false
            overlay.authorizBT.setTitle("Get Started", for: .normal)
            overlay.skipBT.isHidden = true
        }
    }
}
