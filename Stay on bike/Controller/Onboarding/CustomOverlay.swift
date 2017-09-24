//
//  CustomOverlay.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard

class CustomOverlay: SwiftyOnboardOverlay {
    
    let locale = Locale.current
    
    @IBOutlet weak var skipBT: UIButton!
    @IBOutlet weak var authorizBT: UIButton!
    @IBOutlet weak var contentControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        skipBT.setTitle(NSLocalizedString("S K I P", comment: ""), for: .normal)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomOverlay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
