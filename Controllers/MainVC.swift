//
//  ViewController.swift
//  ParkChampTest
//
//  Created by macbook pro on 12/6/20.
//

import UIKit
import Firebase

class MainVC: UIViewController {
    
    @IBOutlet weak var wordsCount: UILabel!
    
    @IBOutlet weak var wordTextField: UITextField!
    
    var wordsArray: [String] = [String]()

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        wordsCount.text = "We'd like to find anograms"
        wordTextField.returnKeyType = .done
        wordTextField.delegate = self
        
        ref = Database.database().reference(withPath: "words")
        getWords()
    }
    
    func getWords() {
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let wordsArr = snapshot.value as? Array<Any> {
                for word in wordsArr {
                    if word is String {
                        self.wordsArray.append(word as! String)
                        print("The values from the database: \(self.wordsArray)")
                    }
                }
            }
        })
    }
    
    private func checkForAnogram() -> Int {
        var anogramCount = 0
        if let searchWord = wordTextField.text, searchWord != "" {
            //taking each word in array from database
            for eachWord in wordsArray {
                if eachWord.count == searchWord.count {
                    //get each character in "eachWord" to check
                    var isAnogram = 0
                    for character in Array(eachWord) {
                        let searchWordCount = checkForQuality(inArray: Array(searchWord), character: character)
                        let eachWordCount = checkForQuality(inArray: Array(eachWord), character: character)
                        if searchWord.contains(character) && searchWordCount == eachWordCount {
                            isAnogram = isAnogram + 1
                        }
                    }
                    if isAnogram == searchWord.count {
                        print("searchWord - \(searchWord) and anogram is - \(eachWord)")
                        anogramCount = anogramCount + 1
                    }
                }
            }
            return anogramCount
        }
        return anogramCount
    }
    
    private func checkForQuality(inArray: Array<Any>, character: Character) -> Int {
        var count = 0
        for symbol in inArray {
            if symbol as! Character == character {
                count = count + 1
            }
        }
        return count
    }
}

extension MainVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        wordTextField.resignFirstResponder()
        let counter = checkForAnogram()
        wordsCount.text = "We found \(counter) anogram(s)"
        print("run the anogram logic")
        return true
    }
}
