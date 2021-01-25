import Foundation

extension CustomModalAlertViewController {
    @objc func configureForCookieDialog() {
        image = UIImage(named: "cookie")
        viewTitle = NSLocalizedString("Before You Continue", comment: "")
        detailAttributed = detailTextAttributedString()
        
        let detailTapGR = UITapGestureRecognizer(target: self, action: #selector(cookiePolicyTouchUpInside))
        detailTapGR.cancelsTouchesInView = false
        detailTapGestureRecognizer = detailTapGR
        
        firstButtonTitle = NSLocalizedString("Accept Cookies", comment: "")
        dismissButtonTitle = NSLocalizedString("Cookie Settings", comment: "")
        
        firstCompletion = { [weak self] in
            self?.dismiss(animated: true, completion: {
                let cookieSettingsUseCase = CookieSettingsUseCase(repository: CookieSettingsRepository(sdk: MEGASdkManager.sharedMEGASdk()))
                cookieSettingsUseCase.setCookieSettings(with: CookiesBitmap.all.rawValue) { [weak self] in
                    switch $0 {
                    case .success(_):
                        self?.dismiss(animated: true, completion: nil)
                        
                    case .failure(let error):
                        switch error {
                        case .invalidBitmap:
                            SVProgressHUD.showError(withStatus: error.localizedDescription)
                            
                        default:
                            SVProgressHUD.showError(withStatus: error.localizedDescription)
                        }
                    }
                }
            })
        }
        
        dismissCompletion = { [weak self] in
            self?.dismiss(animated: true, completion: {
                let cookieSettingsFactory = CookieSettingsFactory()
                let cookieSettingsNC = cookieSettingsFactory.createCookieSettingsNC()
                
                UIApplication.mnz_visibleViewController().navigationController?.present(cookieSettingsNC, animated: true, completion: nil)
            })
        }
    }
    
    private func detailTextAttributedString() -> NSAttributedString {
        var detailText = NSLocalizedString("We use cookies and similar technologies (‘Cookies’) to provide our services to you, enhance your experience with our services and customize the adverts you see, including through third parties. Accept our use of Cookies from the beginning of your visit or customise Cookies in Cookie Settings. Read more in our [A]Cookie Policy[/A].", comment: "") as NSString
        let cookiePolicy = detailText.mnz_stringBetweenString("[A]", andString: "[/A]")
        detailText = detailText.mnz_removeWebclientFormatters() as NSString
        
        let cookiePolicyRange = detailText.range(of: cookiePolicy ?? "")
        let detailTextAttributedString = NSMutableAttributedString(string: detailText as String, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.mnz_subtitles(for: traitCollection)])
        detailTextAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.mnz_turquoise(for: traitCollection)], range: cookiePolicyRange)
        
        return detailTextAttributedString
    }
    
    @IBAction func cookiePolicyTouchUpInside(_ sender: UITapGestureRecognizer) {
        NSURL.init(string: "https://mega.nz/cookie")?.mnz_presentSafariViewController()
    }
}