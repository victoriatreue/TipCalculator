//
//  ViewController.swift
//  TipCalculatorStarter
//
//  Created by Chase Wang on 9/19/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    var isDefaultStatusBar = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDefaultStatusBar ? .default : .lightContent
    }
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    @IBOutlet weak var inputCardView: UIView!
    @IBOutlet weak var billAmountTextField: BillAmountTextField!
    @IBOutlet weak var tipPercentageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var outputCardView: UIView!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipAmountNumber: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalNumber: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setTheme(isDark: false)
        
        billAmountTextField.calculateButtonAction = {
            self.calculate()
        }
    }
    
    func setUpViews() {
        headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.05
        headerView.layer.shadowRadius = 35
        
        inputCardView.layer.cornerRadius = 8
        inputCardView.layer.masksToBounds = true
        
        outputCardView.layer.cornerRadius = 8
        outputCardView.layer.masksToBounds = true
        outputCardView.layer.borderColor = UIColor.tcHotPink.cgColor
        outputCardView.layer.borderWidth = 1
        
        resetButton.layer.cornerRadius = 8
        resetButton.layer.masksToBounds = true
    }
    
    func setTheme (isDark: Bool) {
        let theme = isDark ? ColorTheme.dark : ColorTheme.light
        
        view.backgroundColor = theme.viewControllerBackgroundColor
        
        headerView.backgroundColor = theme.primaryColor
        titleLabel.textColor = theme.primaryTextColor
        
        inputCardView.backgroundColor = theme.secondaryColor
        
        billAmountTextField.tintColor = theme.accentColor
        tipPercentageSegmentedControl.tintColor = theme.accentColor
        
        outputCardView.backgroundColor = theme.primaryColor
        outputCardView.layer.borderColor = theme.accentColor.cgColor
        
        tipAmountLabel.textColor = theme.primaryTextColor
        totalLabel.textColor = theme.primaryTextColor
        
        tipAmountNumber.textColor = theme.outputTextColor
        totalNumber.textColor = theme.outputTextColor
        
        resetButton.backgroundColor = theme.secondaryColor
        
        
        isDefaultStatusBar = theme.isDefaultStatusBar
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    
    func calculate() {
        // dismiss keyboard after it is used
         if self.billAmountTextField.isFirstResponder {
             self.billAmountTextField.resignFirstResponder()
         }
         
         // calculating the rounded Bill Amount
         guard let input = self.billAmountTextField.text,
               let billAmount = Double(input) else {
                    calculate()
                    return}
         
         let roundedBillAmount = (100 * billAmount).rounded() / 100
                  
         // calculating the tip percentage at fixed 15%
       
         let tipPercent:Double
         switch tipPercentageSegmentedControl.selectedSegmentIndex {
         case 0:
            tipPercent = 0.15
         case 1:
            tipPercent = 0.18
         case 2:
            tipPercent = 0.2
         default:
             preconditionFailure("Unexpected Index.")
         }
        
         let tipAmount = roundedBillAmount * tipPercent
         let roundedTipAmount = (100 * tipAmount).rounded() / 100
                  
         // calculating the TOTAL
         let total = roundedTipAmount + roundedBillAmount
         
         // Update UI in Output Card
         self.billAmountTextField.text = String(format: "%.2f", roundedBillAmount)
         self.tipAmountNumber.text = String(format: "%.2f", roundedTipAmount)
         self.totalNumber.text = String(format: "%.2f", total)
    }
    
    func clear () {
        // set the text field's text to nil
        billAmountTextField.text = nil
        
        // set the selectedSegmentControl to 0
        tipPercentageSegmentedControl.selectedSegmentIndex = 0
        
        // set both output labels in output card to $0.00
        tipAmountNumber.text = "$0.00"
        totalNumber.text = "$0.00"
    }
    
    // MARK: - IBActions
    @IBAction func switchTapped(_ sender: UISwitch) {
        setTheme(isDark: sender.isOn)
    }
    
    
    @IBAction func tipPercentageChanged(_ sender: UISegmentedControl) {
        calculate()
    }
    
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        clear()
    }
}

