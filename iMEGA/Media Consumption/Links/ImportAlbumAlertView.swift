import SwiftUI

struct ImportAlbumAlertView: UIViewControllerRepresentable {
    @Binding var textString: String
    @Binding var showingAlert: Bool
    
    let title: String
    let message: String
    let placeholderText: String
    let cancelButtonText: String
    let decryptButtonText: String
    let onTappingCancelButton: (() -> Void)?
    let onTappingDecryptButton: (() -> Void)?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImportAlbumAlertView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImportAlbumAlertView>) {
        guard context.coordinator.alert == nil else { return }
        guard showingAlert else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        context.coordinator.alert = alert
        
        alert.addTextField { textField in
            textField.placeholder = placeholderText
            textField.delegate = context.coordinator
            textField.addAction(UIAction(handler: { _ in
                guard let decryptAction = alert.actions.last else { return }
                decryptAction.isEnabled = textField.text?.trim?.isNotEmpty ?? false
                decryptAction.titleTextColor = decryptAction.isEnabled ? Colors.MediaConsumption.decryptTitleEnabled.color : Colors.MediaConsumption.decryptTitleDisabled.color
            }), for: .editingChanged)
        }
        
        alert.addAction(UIAlertAction(title: cancelButtonText, style: .cancel) { _ in
            alert.dismiss(animated: true) {
                self.showingAlert = false
                self.onTappingCancelButton?()
            }
        })
        
        let decryptAction = UIAlertAction(title: decryptButtonText, style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.textString = text
            }
            
            alert.dismiss(animated: true) {
                self.showingAlert = false
                self.onTappingDecryptButton?()
            }
        }
        decryptAction.titleTextColor = Colors.MediaConsumption.decryptTitleDisabled.color
        alert.addAction(decryptAction)
        alert.actions.last?.isEnabled = false
        
        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: {
                self.showingAlert = false
                context.coordinator.alert = nil
            })
        }
    }
    
    func makeCoordinator() -> ImportAlbumAlertView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: ImportAlbumAlertView
        
        init(_ control: ImportAlbumAlertView) {
            self.control = control
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textString = ""
            }
            return true
        }
    }
}

fileprivate extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
