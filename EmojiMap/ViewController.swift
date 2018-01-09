//
//  ViewController.swift
//  EmojiMap
//
//  Created by Matias Villaverde on 09.01.18.
//  Copyright © 2018 Matias Villaverde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let mapping = EmojiMap()

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var userOutput: UILabel!
    @IBOutlet weak var map: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        userInput.delegate = self
        
        for match in mapping.getMatchesFor("Dog") {
            print(match.emoji)
        }
        
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        view.endEditing(true) // Hide keyboard
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        var result = "Result: "
        for match in mapping.getMatchesFor(text) {
            result += "\(match.emoji) "
        }
        
        userOutput.text = result
        
    }
}

