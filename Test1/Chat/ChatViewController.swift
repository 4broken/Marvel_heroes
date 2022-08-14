//
//  ChatViewController.swift
//  Test1
//
//  Created by Shamil Mazitov on 11.05.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatViewController: MessagesViewController, MessagesDataSource,  MessagesDisplayDelegate {
    
    var messageList: [ChatMessage] = []
    
    let currentUser = ChatUser(senderId: "self", displayName: "Chat")
    
    let otherUser = ChatUser(senderId: "system", displayName: "Chat")
    
    var messages = [MessageType]()
    
   
    
    override func viewDidLoad() {
            super.viewDidLoad()
        messagesCollectionView.register(CustomCell.self)
        self.view.backgroundColor = .white
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        configureMessageCollectionView()
        configureMessageInputBar()
        giveAnAnswer()
    }
    
        
        
    
    var now = Date()
    
    var namesOfCharacters: String?
    
    var profileImages: UIImage?
    
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == currentSender().senderId
    }
    func currentSender() -> SenderType {
        
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
         messageList[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.image = profileImages!
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }

        if isSectionReservedForTypingIndicator(indexPath.section) {
            return messagesDataSource.typingIndicator(at: indexPath, in: messagesCollectionView)
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        switch message.kind {
        case .text, .attributedText, .emoji:
            if let cell = messagesDataSource.textCell(for: message, at: indexPath, in: messagesCollectionView) {
                return cell
            } else {
                let cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                return cell
            }
        default:
            break
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section + 1].user
    }
    
    
    @objc func loadMoreMessages(_ count: Int) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: count) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                }
            }
        }
    }
   
    func giveAnAnswer() {
        SampleData.shared.getMessages(count: 1){ messages in
            DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: self.messageList.count)
                self.messagesCollectionView.reloadData()
                
    }
        }
        
        if messageInputBar.sendButton.isEnabled  {
            
            SampleData.shared.getMessages(count: 1){ messages in
                DispatchQueue.main.async {
                        self.messageList.insert(contentsOf: messages, at: self.messageList.count)
                    self.messagesCollectionView.reloadData()
            }
    }
        }
    }
    
    
    
    func insertMessage(_ message: ChatMessage) {
        messageList.append(message)
       giveAnAnswer()
    }
        
        
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
        
    }
    
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .green
        messageInputBar.sendButton.setTitleColor(.green, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.green.withAlphaComponent(0.3),
            for: .highlighted
        )
    }

    func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let count = UserDefaults.standard.chatMessagesCount()
            SampleData.shared.getMessages(count: count) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                }
            }
        }
    }
    
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }

    func processInputBar(_ inputBar: InputBarAccessoryView)  {
        
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
                
            }
            
        }
      
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = currentSender()
            if let str = component as? String {
                let message = ChatMessage(text: str, user: user as! ChatUser , messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

extension ChatViewController: MessagesLayoutDelegate {

   
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        }
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }

}



