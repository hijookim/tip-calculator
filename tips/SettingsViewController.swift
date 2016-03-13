//
//  SettingsViewController.swift
//  tips
//
//  Created by Karen Kim on 3/12/16.
//  Copyright © 2016 Karen Kim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var defaultTipPercentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentageValue = defaults.integerForKey("default_tip_percentage")
        defaultTipPercentageLabel.text = String(defaultTipPercentageValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onDefaultTipSliderValueChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sliderValue = Int((sender as! UISlider).value)
        defaultTipPercentageLabel.text = String(format: "%d", sliderValue)
        defaults.setInteger(sliderValue, forKey: "default_tip_percentage")
        defaults.synchronize()
    }
}
