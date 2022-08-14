//
//  SampleData.swift
//  Test1
//
//  Created by Shamil Mazitov on 17.05.2022.
//

import Foundation
import MessageKit
import CoreLocation
import AVFoundation

final internal class SampleData {

    static let shared = SampleData()

    private init() {}

    enum MessageTypes: String, CaseIterable {
        case Text
        case AttributedText
        case Photo
        case PhotoFromURL = "Photo from URL"
        case Video
        case Audio
        case Emoji
        case Location
        case Url
        case Phone
        case Custom
        case ShareContact
    }
    
    var now = Date()
    
    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }
    
    func randomMessageType() -> MessageTypes {
        return MessageTypes.allCases.compactMap {
            guard UserDefaults.standard.bool(forKey: "\($0.rawValue)" + " Messages") else { return nil }
            return $0
        }.random()!
    }
    
    func randomMessage(allowedSenders: [ChatUser]) -> ChatMessage {
        let uniqueID = UUID().uuidString
        let user = allowedSenders.random()!
        let date = dateAddingRandomTime()

        switch randomMessageType() {
        case .Text:
            let randomSentence = AnswerList.sentence()
            return ChatMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
        default:
            return ChatMessage(text: AnswerList.sentence(), user: user, messageId: uniqueID, date: date)
        }
    }
    
    let system = ChatUser(senderId: "00000", displayName: "System")
    

    func getMessages(count: Int, completion: ([ChatMessage]) -> Void) {
        var messages: [ChatMessage] = []
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = system
            let date = dateAddingRandomTime()
            let randomSentence = AnswerList.sentence()
            let message = ChatMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        completion(messages)
    }
    
    func getMessages(count: Int) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        UserDefaults.standard.set(false, forKey: "Custom Messages")
        for _ in 0..<count {
            let uniqueID = UUID().uuidString
            let user = system
            let date = dateAddingRandomTime()
            let randomSentence = AnswerList.sentence()
            let message = ChatMessage(text: randomSentence, user: user, messageId: uniqueID, date: date)
            messages.append(message)
        }
        return messages
    }
}

