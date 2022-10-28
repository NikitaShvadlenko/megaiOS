import Combine

// MARK: - Use case protocol -
public protocol ChatUseCaseProtocol {
    func chatStatus() -> ChatStatusEntity
    func changeChatStatus(to status: ChatStatusEntity)
    func monitorChatStatusChange(forUserHandle userHandle: HandleEntity) -> AnyPublisher<ChatStatusEntity, Never>
    func monitorChatListItemUpdate() -> AnyPublisher<ChatListItemEntity, Never>
    func existsActiveCall() -> Bool
    func activeCall() -> CallEntity?
    func chatsList(ofType type: ChatTypeEntity) -> [ChatListItemEntity]?
    func isCallInProgress(for chatRoomId: HandleEntity) -> Bool
    func myFullName() -> String?
    func archivedChatListCount() -> UInt
    func unreadChatMessagesCount() -> Int
    func monitorChatCallStatusUpdate() -> AnyPublisher<CallEntity, Never>
}

// MARK: - Use case implementation -
public struct ChatUseCase<T: ChatRepositoryProtocol>: ChatUseCaseProtocol {
    private var chatRepo: T

    public init(chatRepo: T) {
        self.chatRepo = chatRepo
    }
    
    public func chatStatus() -> ChatStatusEntity {
        chatRepo.chatStatus()
    }
    
    public func changeChatStatus(to status: ChatStatusEntity) {
        chatRepo.changeChatStatus(to: status)
    }
    
    public func monitorChatStatusChange(forUserHandle userHandle: HandleEntity) -> AnyPublisher<ChatStatusEntity, Never> {
        chatRepo.monitorChatStatusChange(forUserHandle: userHandle)
    }
    
    public func monitorChatListItemUpdate() -> AnyPublisher<ChatListItemEntity, Never> {
        chatRepo.monitorChatListItemUpdate()
    }
    
    public func existsActiveCall() -> Bool {
        chatRepo.existsActiveCall()
    }
    
    public func activeCall() -> CallEntity? {
        chatRepo.activeCall()
    }
    
    public func chatsList(ofType type: ChatTypeEntity) -> [ChatListItemEntity]? {
        chatRepo.chatsList(ofType: type)?.sorted(by: { $0.lastMessageDate.compare($1.lastMessageDate) == .orderedDescending })
    }
    
    public func isCallInProgress(for chatRoomId: HandleEntity) -> Bool {
        chatRepo.isCallInProgress(for: chatRoomId)
    }
    
    public func myFullName() -> String? {
        chatRepo.myFullName()
    }
    
    public func archivedChatListCount() -> UInt {
        chatRepo.archivedChatListCount()
    }
    
    public func unreadChatMessagesCount() -> Int {
        chatRepo.unreadChatMessagesCount()
    }
    
    public func monitorChatCallStatusUpdate() -> AnyPublisher<CallEntity, Never> {
        chatRepo.monitorChatCallStatusUpdate()
    }
}