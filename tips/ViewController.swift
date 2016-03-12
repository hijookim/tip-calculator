//
//  ViewController.swift
//  tips
//
//  Created by Karen Kim on 3/11/16.
//  Copyright © 2016 Karen Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentages = [0.18, 0.20, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
    
        let billAmount = (billField.text! as NSString).doubleValue
        let tipAmount = billAmount * tipPercentage
        let totalAmount = billAmount + tipAmount
        
        tipLabel.text = "$\(tipAmount)"
        totalLabel.text = "$\(totalAmount)"
        
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)

    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

