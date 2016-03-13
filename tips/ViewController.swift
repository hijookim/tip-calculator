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
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var splitView: UIView!
    @IBOutlet weak var multiSplitInfoView: UIView!
    
    @IBOutlet weak var split2PeopleAmountLabel: UILabel!
    @IBOutlet weak var split3PeopleAmountLabel: UILabel!
    @IBOutlet weak var split4PeopleAmountLabel: UILabel!
    
    var tipPercentSegControlValues = [0.18, 0.20, 0.22]
    var defaultTipPercent = 0.0
    var totalSplitViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        initializeTipFieldLabels()
        self.amountView.alpha = 1
        self.multiSplitInfoView.alpha = 0
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentageValue = defaults.integerForKey("default_tip_percentage")
        defaultTipPercent = Double(defaultTipPercentageValue) / 100
        
        setTipLabels()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // store current state to remember for next load
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text!, forKey: "bill_amount")
        defaults.setObject(NSDate(), forKey: "last_used_datetime")
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        setTipLabels()
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
        toggleTotalSplitView()
    }
    
    @IBAction func onTipPercentSegControlTap(sender: AnyObject) {
        let selectedIndex = (sender as! UISegmentedControl).selectedSegmentIndex
        defaultTipPercent = tipPercentSegControlValues[selectedIndex]
        setTipLabels()
    }
    
    func toggleTotalSplitView() {
        if totalSplitViewVisible {
           // hide the split view
            billField.becomeFirstResponder()
            UIView.animateWithDuration(0.4, animations: {
                let amountViewTopFrame = self.amountView.frame
                var splitViewTopFrame = self.splitView.frame
                splitViewTopFrame.origin.y += amountViewTopFrame.size.height
                self.splitView.frame = splitViewTopFrame
                
                self.amountView.alpha = 1
                self.multiSplitInfoView.alpha = 0
            })
            
            totalSplitViewVisible = false
        } else {
            // make split view visible
            view.endEditing(true)
            
            UIView.animateWithDuration(0.4, animations: {
                let amountViewTopFrame = self.amountView.frame
                var splitViewTopFrame = self.splitView.frame
                splitViewTopFrame.origin.y -= amountViewTopFrame.size.height
                self.splitView.frame = splitViewTopFrame
                
                self.amountView.alpha = 0
                self.multiSplitInfoView.alpha = 1
            })
            
            totalSplitViewVisible = true
        }
    }
    
    // used to set the last used bill amount if within 10 min of last used time. if not, set to default value
    func initializeTipFieldLabels() {
        var loadedLastBillAmount = false
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastUsedDateTime = defaults.objectForKey("last_used_datetime")
        
        if let lastUsedDate = lastUsedDateTime as! NSDate? {
            // compute expiration date by adding 10 min
            let minutesToAddInSeconds: NSTimeInterval = 10 * 60
            let expirationDate = lastUsedDate.dateByAddingTimeInterval(minutesToAddInSeconds)
            
            // if not past the expiration time, then load previous bill amount
            if expirationDate > NSDate() {
                let latestBillAmount = defaults.stringForKey("bill_amount")
                billField.text = latestBillAmount
                setTipLabels()
                loadedLastBillAmount = true
            }
        }
        
        if !loadedLastBillAmount {
            tipLabel.text = formatPrice(0.0)
            totalLabel.text = formatPrice(0.0)
        }
    }
    
    func formatPrice(price: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter.stringFromNumber(price)!
    }
    
    func setTipLabels() {
        let billAmount = Double(billField.text!)!
        let tipAmount = billAmount * defaultTipPercent
        let totalAmount = billAmount + tipAmount
        
        tipLabel.text = formatPrice(tipAmount)
        totalLabel.text = formatPrice(totalAmount)
        split2PeopleAmountLabel.text = formatPrice(totalAmount / 2)
        split3PeopleAmountLabel.text = formatPrice(totalAmount / 3)
        split4PeopleAmountLabel.text = formatPrice(totalAmount / 4)
    }
}

// NSDate comparator extensions
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

