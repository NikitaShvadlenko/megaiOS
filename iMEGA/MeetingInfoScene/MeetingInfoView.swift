import SwiftUI

@available(iOS 14.0, *)
struct MeetingInfoView: View {
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject var viewModel: MeetingInfoViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                MeetingInfoHeaderView()
                    .environmentObject(viewModel)
                
                MeetingLinkToogleView(
                    image: Asset.Images.Meetings.Info.meetingLink.name,
                    text: Strings.Localizable.Meetings.Info.meetingLink,
                    disabled: $viewModel.isMeetingLinkDisabled,
                    isOn: $viewModel.isMeetingLinkOn) { newValue in
                        viewModel.meetingLinkValueChanged(to: newValue)
                    } action: {
                        viewModel.shareMeetingLinkTapped()
                    }
                 
                if let chatRoomNotificationsViewModel = viewModel.chatRoomNotificationsViewModel {
                    ChatRoomNotificationsView(
                        viewModel: chatRoomNotificationsViewModel,
                        image: Asset.Images.Meetings.Info.enableChatNotifications.name,
                        text: Strings.Localizable.chatNotifications
                    )
                }
                
                ToogleView(
                    image: Asset.Images.Meetings.Info.allowNonHostToAddParticipant.name,
                    text: Strings.Localizable.Meetings.AddContacts.AllowNonHost.message,
                    isOn: $viewModel.isAllowNonHostToAddParticipantsOn) { newValue in
                        viewModel.allowNonHostToAddParticipantsValueChanged(to: newValue)
                    }
                
                DisclosureView(
                    image: Asset.Images.Meetings.Info.sharedFilesInfo.name,
                    text: Strings.Localizable.sharedFiles) {
                        viewModel.sharedFilesViewTapped()
                    }
                
                DisclosureView(
                    image: Asset.Images.Meetings.Info.manageChatHistory.name,
                    text: Strings.Localizable.manageChatHistory) {
                        viewModel.manageChatHistoryViewTapped()
                    }
                
                KeyRotationView(
                    title: Strings.Localizable.enableEncryptedKeyRotation,
                    rightDetail: Strings.Localizable.enabled,
                    footer: Strings.Localizable.keyRotationIsSlightlyMoreSecureButDoesNotAllowYouToCreateAChatLinkAndNewParticipantsWillNotSeePastMessages,
                    isPublicChat: $viewModel.isPublicChat) {
                        viewModel.enableEncryptionKeyRotationViewTapped()
                    }
                
                if $viewModel.isUserInChat.wrappedValue {
                    LeaveChatButtonView(text: viewModel.isChatPreview() ? Strings.Localizable.close : Strings.Localizable.leaveGroup) {
                        viewModel.leaveGroupViewTapped()
                    }
                }
            }
        }
        .padding(.vertical)
        .background(colorScheme == .dark ? Color(Colors.General.Black._1c1c1e.name) : Color(Colors.General.White.f7F7F7.name))
    }
}
