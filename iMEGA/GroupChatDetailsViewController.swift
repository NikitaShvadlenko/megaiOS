import Foundation
import MEGADomain

extension GroupChatDetailsViewController {
    
    @objc func addChatCallDelegate() {
        MEGASdkManager.sharedMEGAChatSdk().add(self as MEGAChatCallDelegate)
    }
    
    @objc func removeChatCallDelegate() {
        MEGASdkManager.sharedMEGAChatSdk().remove(self as MEGAChatCallDelegate)
    }
    
    @objc func showEndCallForAll() {
        let endCallDialog = EndCallDialog(
            type: .endCallForAll,
            forceDarkMode: false,
            autodismiss: true
        ) { [weak self] in
            self?.endCallDialog = nil
        } endCallAction: { [weak self] in
            guard let self = self,
                  let call = MEGASdkManager.sharedMEGAChatSdk().chatCall(forChatId: self.chatRoom.chatId) else {
                return
            }
            
            let statsRepoSitory = StatsRepository(sdk: MEGASdkManager.sharedMEGASdk())
            MeetingStatsUseCase(repository: statsRepoSitory).sendEndCallForAllStats()
            
            MEGASdkManager.sharedMEGAChatSdk().endChatCall(call.callId)
            self.navigationController?.popViewController(animated: true)
        }
        
        endCallDialog.show()
        self.endCallDialog = endCallDialog
    }
    
    private func createParticipantsAddingViewFactory() -> ParticipantsAddingViewFactory {
        let chatRoomUseCase = ChatRoomUseCase(
            chatRoomRepo: ChatRoomRepository(sdk: MEGASdkManager.sharedMEGAChatSdk()),
            userStoreRepo: UserStoreRepository(store: .shareInstance()))
        return ParticipantsAddingViewFactory(
            userUseCase: UserUseCase(repo: .live),
            chatRoomUseCase: chatRoomUseCase,
            chatId: chatRoom.chatId
        )
    }
    
    private func showInviteContacts() {
        guard let inviteController = createParticipantsAddingViewFactory().inviteContactController() else { return }
        navigationController?.pushViewController(inviteController, animated: true)
    }
    
    @objc func addParticipant() {
        let participantsAddingViewFactory = createParticipantsAddingViewFactory()
        
        guard participantsAddingViewFactory.hasVisibleContacts else {
            let noAvailableContactsAlert = participantsAddingViewFactory.noAvailableContactsAlert(inviteAction: showInviteContacts)
            present(noAvailableContactsAlert, animated: true)
            return
        }
        
        guard participantsAddingViewFactory.hasNonAddedVisibleContacts(withExcludedHandles: []) else {
            let allContactsAlreadyAddedAlert = participantsAddingViewFactory.allContactsAlreadyAddedAlert(inviteAction: showInviteContacts)
            present(allContactsAlreadyAddedAlert, animated: true)
            return
        }
        
        let contactsNavigationController = participantsAddingViewFactory.addContactsViewController(
            withContactsMode: .chatAddParticipant,
            additionallyExcludedParticipantsId: nil
        ) { [weak self] handles in
            guard let self = self else { return }
            for handle in handles {
                MEGASdkManager.sharedMEGAChatSdk().invite(
                    toChat: self.chatRoom.chatId,
                    user: handle,
                    privilege: MEGAChatRoomPrivilege.standard.rawValue
                )
            }
        }
        
        guard let contactsNavigationController = contactsNavigationController else { return }
        present(contactsNavigationController, animated: true)
    }
}

extension GroupChatDetailsViewController: MEGAChatCallDelegate {
    public func onChatCallUpdate(_ api: MEGAChatSdk!, call: MEGAChatCall!) {
        guard call.chatId == self.chatRoom.chatId else { return }
        
        let statusToReload: [MEGAChatCallStatus] = [.inProgress,
                                                    .userNoPresent,
                                                    .destroyed]
        if statusToReload.contains(call.status) {
            self.reloadData()
        }
    }
}
