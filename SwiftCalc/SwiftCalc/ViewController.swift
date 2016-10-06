//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var sequence: [String] = []
    var currentValue: String = ""
    var lastButtonIsOperator: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
        resultLabel.text! = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSequence(_ content: String) {
        sequence.append(content)
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String, replaceResultLabel: Bool) {
        if !replaceResultLabel {
            if resultLabel.text!.characters.count < 7 {
                resultLabel.text = resultLabel.text! + content
            }
        } else {
            resultLabel.text = content
            }
        }

    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String { // rewrite to handle double + double, int + double
        //return String(intCalculate(a: first_button,b: second_button, operation: single_operator))
        print(sequence)
        simplifySequence()
        print(sequence)
        var result: String = String(doubleCalculate(a: sequence[0], b: sequence[2], operation: sequence[1]))
        //result = String(intCalculate(a: Int(sequence[0])!, b: Int(sequence[2])!, operation: sequence[1]))
        var count: Int = 3
        while count < sequence.count {
            
            //result = String(intCalculate(a: Int(result)!, b: Int(sequence[count + 1])!, operation: sequence[count]))
            result = String(doubleCalculate(a: result, b: sequence[count + 1], operation: sequence[count]))
            let isInteger = floor(Double(result)!) == Double(result)!
            if isInteger == true {
                result = String(Int(result)!)
            }
            count = count + 2
        }
        let isInteger = floor(Double(result)!) == Double(result)!
        if isInteger == true {
            result = String(Int(Double(result)!))
        }
        updateResultLabel(result, replaceResultLabel: true)
        sequence = [result]
        return result
    }

    //
    func simplifySequence() {// simplifies sequence into [number, operator, number, operator,...]
        var simplifiedSequence: [String] = []
        var beginNumber: String = ""
        var counter: Int = 0
// CMND + /
//        for item in sequence {
//            counter = counter + 1
//            if Int(item) != nil { //Next element is a number
//                beginNumber = beginNumber + item
//            } else{ //Next element if an operator
//                if beginNumber != "0"{
//                    simplifiedSequence.append(beginNumber)
//                }
//                simplifiedSequence.append(item)
//                beginNumber = ""
//            }
//            if counter == sequence.count { //Since last element should be a number, we could hardcode the last number
//                simplifiedSequence.append(beginNumber)
//            }
//        }
//        sequence = simplifiedSequence
        var itemBefore: String = "" //Used to see if number has been negated
        for item in sequence {
            counter = counter + 1
            if Int(item) != nil { //Next element is a number
                if itemBefore == "+/-" {
                    beginNumber = String((-1)*Int(beginNumber)!)
                }
                beginNumber = beginNumber + item
                itemBefore = item
            } else{ //Next element if an operator
                print(item)
                if item == "+/-" {
                    beginNumber = String((-1)*Int(beginNumber)!)
                    print(beginNumber)
                } else {
                    //if beginNumber != "0"{
                simplifiedSequence.append(beginNumber)
                    //}
                    simplifiedSequence.append(item)
                    beginNumber = ""
                    itemBefore = item
                }
            }
            if counter == sequence.count {
                //if item == "+/-" {
                //    beginNumber = String((-1)*Int(beginNumber)!)
                //}
                simplifiedSequence.append(beginNumber)
            }
        }
        sequence = simplifiedSequence
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        if operation == "+" {
            return a + b
        } else if operation == "-" {
            return a - b
        } else if operation == "/" {
            return a/b
        } else {
            return a*b
        }
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func doubleCalculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        let aDouble: Double = Double(a)!
        let bDouble: Double = Double(b)!
        if operation == "+" {
            return aDouble + bDouble
        } else if operation == "-" {
            return aDouble - bDouble
        } else if operation == "/" {
            return aDouble/bDouble
        } else {
            return aDouble*bDouble
        }
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        // Fill me in!
        sequence.append(sender.content)
        if resultLabel.text == "0" || lastButtonIsOperator == true {
            updateResultLabel(sender.content, replaceResultLabel: true)
        } //else if lastButtonIsOperator == true {
            //updateResultLabel(sender.content, replaceResultLabel: true)
        //}
        else {
            updateResultLabel(sender.content, replaceResultLabel: false)
        }
        lastButtonIsOperator = false
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        print("The operator \(sender.content) was pressed")
        lastButtonIsOperator = true
        if sender.content == "=" {
            currentValue = calculate()
            //single_operator = ""
            //sequence = []
            updateResultLabel(currentValue, replaceResultLabel: true)
        } else if sender.content == "C" {
            //single_operator = ""
            sequence = []
            updateResultLabel("0", replaceResultLabel: true)
        } else if sender.content == "+/-" {
            updateResultLabel(String((-1)*Int(resultLabel.text!)!), replaceResultLabel: true)
            sequence.append(sender.content)
        }
        else {
//            if Int(sequence.last!) != nil{ //Is an integer
//                if sequence.count > 2 {
//                    sequence = [calculate()] + sequence
//                }
//            }
            
            if sequence.contains("+") || sequence.contains("-") || sequence.contains("*") || sequence.contains("/") {
                currentValue = calculate()
            }
            updateSequence(sender.content)
            updateResultLabel(currentValue, replaceResultLabel: true)
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        if sender.content == "0" {
            updateSequence(sender.content)
        } else if sender.content == "." {
            updateSequence(".")
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

