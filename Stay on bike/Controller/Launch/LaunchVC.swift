import UIKit
import  CoreLocation

class LaunchVC: UIViewController {
    
    var launch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.value(forKey: "launch") == nil) {
            
            self.performSegue(withIdentifier: "toOnboard", sender: self)
            
        } else self.performSegue(withIdentifier: "toSearchSB", sender: self)
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
