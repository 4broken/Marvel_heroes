//
//  AnswerList.swift
//  Test1
//
//  Created by Shamil Mazitov on 17.05.2022.
//

import Foundation

public class AnswerList {
    static let wordList = [
    "Hello", "How are you?", "It's time to kill one more bad person", "I have a nice vibe and you?", "Just spend your time in gym", "No time to die", "Have a nice day", "Don't blame on me, I'm not your girlfriend", "Who are you without this suit"  ]
    
    
    public class func sentence() -> String {
        return wordList.random()!
    }
}

extension Array {
    func random() -> Element? {
        return (count > 0) ? self.shuffled()[0] : nil
    }
}
