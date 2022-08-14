//
//  ChatUser.swift
//  Test1
//
//  Created by Shamil Mazitov on 15.05.2022.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
    
}
