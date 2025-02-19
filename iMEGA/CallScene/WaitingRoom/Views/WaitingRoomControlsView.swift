import SwiftUI

struct WaitingRoomControlsView: View {
    @Binding var isVideoEnabled: Bool
    @Binding var isMicrophoneEnabled: Bool
    @Binding var isSpeakerEnabled: Bool
    
    var body: some View {
        HStack(spacing: 32) {
            WaitingRoomControl(iconOff: Asset.Images.Chat.Calls.cameraOff.name,
                               iconOn: Asset.Images.Chat.Calls.cameraOn.name,
                               enabled: $isVideoEnabled)
            WaitingRoomControl(iconOff: Asset.Images.Chat.Calls.micOff.name,
                               iconOn: Asset.Images.Chat.Calls.micOn.name,
                               enabled: $isMicrophoneEnabled)
            WaitingRoomControl(iconOff: Asset.Images.Chat.Calls.speakerOff.name,
                               iconOn: Asset.Images.Chat.Calls.speakerOn.name,
                               enabled: $isSpeakerEnabled)
        }
        .padding()
    }
}

struct WaitingRoomControl: View {
    let iconOff: String
    let iconOn: String
    @Binding var enabled: Bool
    
    var body: some View {
        Button {
            enabled.toggle()
        } label: {
            Image(enabled ? iconOn : iconOff)
                .clipShape(Circle())
        }

    }
}

struct WaitingRoomControlsView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomControlsView(isVideoEnabled: .constant(false),
                                isMicrophoneEnabled: .constant(false),
                                isSpeakerEnabled: .constant(true))
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
