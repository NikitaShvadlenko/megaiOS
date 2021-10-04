import UIKit

final class EnterMeetingLinkControllerWrapper: NSObject {

    private let viewModel: EnterMeetingLinkViewModel
    private var link: String?
    private lazy var joinButton = UIAlertAction(title: NSLocalizedString("join", comment: ""), style: .default) { (action) in
        guard let link = self.link else { return }
        self.viewModel.dispatch(.didTapJoinButton(link))
    }
    
    init(viewModel: EnterMeetingLinkViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    class func createViewController(withViewModel viewModel: EnterMeetingLinkViewModel) -> UIViewController {
        let wrapper = EnterMeetingLinkControllerWrapper(viewModel: viewModel)
        return wrapper.createAlertController()
    }
    
    private func createAlertController() -> UIAlertController {
        let alertController = UIAlertController(
            title: NSLocalizedString("meetings.enterMeetingLink.title", comment: ""),
            message: nil,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel))
        joinButton.isEnabled = false
        alertController.addAction(joinButton)
        
        alertController.addTextField { textfield in
            textfield.addTarget(self, action: #selector(self.textFieldTextChanged(_:)), for: .editingChanged)
            textfield.delegate = self
        }
        
        return alertController
    }
    
    @objc private func textFieldTextChanged(_ textField: UITextField) {
        link = textField.text
        guard let link = link, !link.isEmpty else {
            joinButton.isEnabled = false
            return
        }
        joinButton.isEnabled = true
    }
}

extension EnterMeetingLinkControllerWrapper: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        OperationQueue.main.addOperation {
            textField.select(nil)
            let menuController = UIMenuController.shared
            menuController.setMenuVisible(true, animated: true)
        }
    }
}