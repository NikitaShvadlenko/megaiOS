import SwiftUI
import Combine

final class PhotoAlbumContainerViewModel: ObservableObject {
    @Published var editMode: EditMode = .inactive
    @Published var shouldShowSelectBarButton = false
    var disableSelectBarButton = false
}