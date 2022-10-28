import XCTest
@testable import MEGA
import MEGADomain
import MEGADomainMock
import Combine

final class ChatRoomsListViewModelTests: XCTestCase {
    var subscription: AnyCancellable?
    let chatsListMock = [ChatListItemEntity(chatId: 1, title: "Chat1"), ChatListItemEntity(chatId: 3, title: "Chat2"), ChatListItemEntity(chatId: 67, title: "Chat3")]
    let meetingsListMock = [ChatListItemEntity(chatId: 11, title: "Meeting 1"), ChatListItemEntity(chatId: 14, title: "Meeting 2"), ChatListItemEntity(chatId: 51, title: "Meeting 3")]
    
    func test_remoteChatStatusChange() {
        let chatUseCase = MockChatUseCase()
        let viewModel = ChatRoomsListViewModel(chatUseCase: chatUseCase)
        
        let expectation = expectation(description: "Awaiting publisher")
        
        subscription = chatUseCase
            .statusChangePublisher
            .receive(on: DispatchQueue.main)
            .sink(){ _ in
                expectation.fulfill()
            }
        
        let chatStatus = ChatStatusEntity.allCases.randomElement()!
        chatUseCase.statusChangePublisher.send(chatStatus)
        
        waitForExpectations(timeout: 10)

        XCTAssert(viewModel.chatStatus == chatStatus)
        subscription = nil
    }
    
    func testAction_networkNotReachable() {
        let networkUseCase = MockNetworkMonitorUseCase(connected: false)
        let viewModel = ChatRoomsListViewModel(
            networkMonitorUseCase: networkUseCase
        )
        
        networkUseCase.networkPathChanged(completion: { _ in
            XCTAssert(viewModel.isConnectedToNetwork == networkUseCase.isConnected())
        })
    }
    
    func testAction_addChatButtonTapped() {
        let router = MockChatRoomsListRouter()
        let viewModel = ChatRoomsListViewModel(router: router)
        
        viewModel.addChatButtonTapped()
        
        XCTAssert(router.presentStartConversation_calledTimes == 1)
    }
    
    func testAction_selectChatsMode() {
        let viewModel = ChatRoomsListViewModel(
            chatUseCase:  MockChatUseCase(items: chatsListMock)
        )
        
        viewModel.selectChatMode(.chats)
        
        guard let chatRoomsCount  = viewModel.displayChatRooms?.count else {
            XCTFail("No Chat Rooms, count should be equal to chatsListMock.count")
            return
        }
        
        for index in 0..<chatRoomsCount {
            XCTAssert(viewModel.displayChatRooms?[index].chatListItem.chatId == chatsListMock[index].chatId)
        }
    }
    
    
    func testAction_selectMeetingsMode() {
        let viewModel = ChatRoomsListViewModel(
            chatUseCase:  MockChatUseCase(items: meetingsListMock)
        )
        
        viewModel.selectChatMode(.chats)
        
        guard let chatRoomsCount  = viewModel.displayChatRooms?.count else {
            XCTFail("No Chat Rooms, count should be equal to chatsListMock.count")
            return
        }
        
        for index in 0..<chatRoomsCount {
            XCTAssert(viewModel.displayChatRooms?[index].chatListItem.chatId == meetingsListMock[index].chatId)
        }
    }
    
    func test_EmptyChatsList() {
        let viewModel = ChatRoomsListViewModel()
        XCTAssert(viewModel.displayChatRooms?.count == 0)
    }
}

final class MockChatRoomsListRouter: ChatRoomsListRouting {
    
    var joinActiveCall_calledTimes = 0
    var presentStartConversation_calledTimes = 0
    var presentMeetingAlreayExists_calledTimes = 0
    var presentCreateMeeting_calledTimes = 0
    var presentEnterMeeting_calledTimes = 0
    var presentScheduleMeetingScreen_calledTimes = 0
    var showInviteContactScreen_calledTimes = 0
    var showContactsOnMegaScreen_calledTimes = 0
    var showDetails_calledTimes = 0
    var present_calledTimes = 0
    var presentMoreOptionsForChat_calledTimes = 0
    var showGroupChatInfo_calledTimes = 0
    var showContactDetailsInfo_calledTimes = 0
    var showArchivedChatRooms_calledTimes = 0
    var openChatRoom_calledTimes = 0
    
    var navigationController: UINavigationController?
    
    func presentStartConversation() {
        presentStartConversation_calledTimes += 1
    }
    
    func presentMeetingAlreayExists() {
        presentMeetingAlreayExists_calledTimes += 1
    }
    
    func presentCreateMeeting() {
        presentCreateMeeting_calledTimes += 1
    }
    
    func presentEnterMeeting() {
        presentEnterMeeting_calledTimes += 1
    }
    
    func presentScheduleMeetingScreen() {
        presentScheduleMeetingScreen_calledTimes += 1
    }
    
    func showInviteContactScreen() {
        showInviteContactScreen_calledTimes += 1
    }
    
    func showContactsOnMegaScreen() {
        showContactsOnMegaScreen_calledTimes += 1
    }
    
    func showDetails(forChatId chatId: MEGADomain.HandleEntity) {
        showDetails_calledTimes += 1
    }
    
    func present(alert: UIAlertController, animated: Bool) {
        present_calledTimes += 1
    }
    
    func presentMoreOptionsForChat(withDNDEnabled dndEnabled: Bool, dndAction: @escaping () -> Void, markAsReadAction: (() -> Void)?, infoAction: @escaping () -> Void, archiveAction: @escaping () -> Void) {
        presentMoreOptionsForChat_calledTimes += 1
    }
    
    func showGroupChatInfo(forChatId chatId: MEGADomain.HandleEntity) {
        showGroupChatInfo_calledTimes += 1
    }
    
    func showContactDetailsInfo(forUseHandle userHandle: MEGADomain.HandleEntity, userEmail: String) {
        showContactDetailsInfo_calledTimes += 1
    }
    
    func showArchivedChatRooms() {
        showArchivedChatRooms_calledTimes += 1
    }
    
    func joinActiveCall(_ call: MEGADomain.CallEntity) {
        joinActiveCall_calledTimes += 1
    }
    
    func openChatRoom(withChatId chatId: MEGA.ChatId, publicLink: String?, unreadMessageCount: Int) {
        openChatRoom_calledTimes += 1
    }
}