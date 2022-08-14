//
//  Settings+UserDefaults.swift
//  Test1
//
//  Created by Shamil Mazitov on 20.05.2022.
//

import Foundation

extension UserDefaults {
    static let messagesKey = "chatMessages"
    
    // MARK: Mock Messages
    
    func setChatMessages(count: Int) {
        set(count, forKey: UserDefaults.messagesKey)
        synchronize()
    }
    
    func chatMessagesCount() -> Int {
        if let value = object(forKey: UserDefaults.messagesKey) as? Int {
            return value
        }
        return 1
    }
    
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
