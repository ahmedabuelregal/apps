//
//  ViewController.swift
//  HangManGame
//
//  Created by Ahmed abu elregal on 11/11/18.
//  Copyright © 2018 Ahmed abu elregal. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{
    
    let LIST_OF_WORDS : [String] = ["goodbye","ahmed","fatema","yassen","coffee"]
    let LIST_OF_HINTS : [String] = ["greeting","letter guessing game","a good way to wake up","farewell","extinct"]
    var WORDTOGUESS : String!
    var WORDASUNDERSCORES : String = ""
    let MAX_NUM_OF_GESSES :Int = 5
    var GUESSESREMAINING : Int!
    var OldNumberRandom : Int = 0
    let smileChar : Character = Character("😊")
    let sadChar : Character = Character("😌")
    
    @IBOutlet weak var newWordButton: UIButton!
    @IBOutlet weak var hintWordLable: UILabel!
    @IBOutlet weak var wordGuessLable: UILabel!
    @IBOutlet weak var remainingGuessesLable: UILabel!
    @IBOutlet weak var inputletterToGuessTextfield: UITextField!
    @IBOutlet weak var letterBankLable: UILabel!
    
    @IBAction func newWordButtonAction(_ sender: UIButton) {
        reset()
        let index = chooseRandonNum()
        WORDTOGUESS = LIST_OF_WORDS[index]
        //wordGuessLable.text = WORDTOGUESS
        for _ in 1...WORDTOGUESS.count
        {
            WORDASUNDERSCORES.append("_")
        }
        print(WORDASUNDERSCORES.count)
        wordGuessLable.text = WORDASUNDERSCORES
        
        let hint = LIST_OF_HINTS[index]
        hintWordLable.text = "Hint : \(hint), \(WORDTOGUESS.count) letter"
    }
    
    
    
    
    override func viewDidLoad() {
        
        inputletterToGuessTextfield.delegate = self
        inputletterToGuessTextfield.isEnabled = false
        inputletterToGuessTextfield.becomeFirstResponder()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func chooseRandonNum ()-> Int
    {
        var newRandomNumbere : Int = Int (arc4random_uniform(UInt32(LIST_OF_WORDS.count)))
        print(newRandomNumbere)
        
        if (newRandomNumbere == OldNumberRandom){
            
            newRandomNumbere = chooseRandonNum()
            
        }
        else {
            OldNumberRandom = newRandomNumbere
        }
        
        return newRandomNumbere
    }
    func reset()
    {
        GUESSESREMAINING = MAX_NUM_OF_GESSES
        remainingGuessesLable.text = "\(GUESSESREMAINING!) guesses left"
        WORDASUNDERSCORES = ""
        inputletterToGuessTextfield.text?.removeAll()
        letterBankLable.text?.removeAll()
        inputletterToGuessTextfield.isEnabled = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
     
        //print(textField.text!)
        
        guard let LetterGuessed = textField.text else {return}
        inputletterToGuessTextfield.text?.removeAll()
        let CurrentLableBank : String = letterBankLable.text ?? ""
        if CurrentLableBank.contains(LetterGuessed)
        {
            return
        }
        else
        {
            if WORDTOGUESS.contains(LetterGuessed)
            {
                processCorrectGuess(LetterGuessed: LetterGuessed)
            }
            else
            {
                processIncorrectGuess()
            }
            letterBankLable.text?.append("\(LetterGuessed), ")
        }
        
        
        
     }
    
    func processCorrectGuess(LetterGuessed : String)
    {
        
        let characterGuessed = Character(LetterGuessed)
        for x_index in WORDTOGUESS.indices
        {
            if WORDTOGUESS[x_index] == characterGuessed{
            
                let endIndex = WORDTOGUESS.index(after: x_index)
                let charRange = x_index..<endIndex
                WORDASUNDERSCORES = WORDASUNDERSCORES.replacingCharacters(in: charRange, with: LetterGuessed)
                wordGuessLable.text = WORDASUNDERSCORES
            }
        }
        if (WORDASUNDERSCORES.contains("_"))
        {
            remainingGuessesLable.text = "You Win \(smileChar)"
            inputletterToGuessTextfield.isEnabled = false
            
        }
//        else{
//            remainingGuessesLable.text = "You Win \(smileChar)"
//        }
    }
    func processIncorrectGuess()
    {
        GUESSESREMAINING! -= 1
        if GUESSESREMAINING == 0
        {
            remainingGuessesLable.text = "You lose \(sadChar)"
            inputletterToGuessTextfield.isEnabled = false
        }
        else
        {
            remainingGuessesLable.text = "\(GUESSESREMAINING!) guesses left"
        }
    }
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
     }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = NSCharacterSet.lowercaseLetters
        let StartingLength = textField.text?.count ?? 0
        let LengthToAdd = string.count
        let LengthToReplace = range.length
        let NewLength = StartingLength + LengthToAdd - LengthToReplace
        if (string.isEmpty)
        {
            return true
        }
        else if (NewLength == 1)
        {
            if let _ = string.rangeOfCharacter(from: allowedCharacters , options: .caseInsensitive)
            {
                return true
            }
        }
        return false
        
     }
}
