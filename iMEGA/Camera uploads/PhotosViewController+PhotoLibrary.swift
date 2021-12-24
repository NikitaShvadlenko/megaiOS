import Foundation
import SwiftUI

@available(iOS 14.0, *)
extension PhotosViewController {
    
    // MARK: - config views
    @objc func configPhotoLibraryView(in container: UIView) {
        let content = PhotoLibraryContentView(
            viewModel: photoLibraryContentViewModel,
            router: PhotoLibraryContentViewRouter()
        )
        
        photoLibraryPublisher.subscribe(photoLibraryContentViewModel)
        
        let host = UIHostingController(rootView: content)
        addChild(host)
        container.wrap(host.view)
        host.view.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        host.didMove(toParent: self)
    }
    
    @objc func updatePhotoLibrary(by nodeList: MEGANodeList) {
        guard let libraryChild = children.first(where: { $0 is UIHostingController<PhotoLibraryContentView> }),
              let host = libraryChild as? UIHostingController<PhotoLibraryContentView> else {
                  return
              }
        
        let photoLibrary = nodeList.toPhotoLibrary()
        host.view.isHidden = photoLibrary.isEmpty
        photoLibraryPublisher.updatePhotoLibrary(photoLibrary)
    }
    
    @objc func createPhotoLibraryContentViewModel() -> PhotoLibraryContentViewModel {
        PhotoLibraryContentViewModel(library: PhotoLibrary())
    }
}