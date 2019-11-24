# PlaceUIKit

A description of this package.

## Authenticating Users with Sign in with Apple

### Overview

After the user chooses to use Sign in with Apple to log in, your app receives **token**s and **user information** that you then verify from a server.

https://docs-assets.developer.apple.com/published/b533b31070/b70a98c4-5ff3-4630-aa0c-d4be51426a5d.png

> **App -> API**: Request with scopes

> **API**: Request user information

> **API -> Apple ID servers**: Verify user and get token

> **Apple ID servers -> App**: Real user indicator, email if requested

### Authenicate the User and Request Information

Users logged in to an Apple device can quickly sign in to your app in the following ways:

- Face ID or Touch ID on passcode-protected devices

- Passcode, if Touch ID or Face ID isn’t available

- Apple ID password, if the passcode isn’t set

### Prevent Duplicate Accounts

- Implement the ASAuthorizationPasswordProvider class to detect and offer keychain credentials that the system already knows about. This works seamlessly to detect and use existing accounts, and prevents new accounts from being created using Sign in with Apple.


### How to use `SignInUI`

```Swift
class SignInViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var signInButtonView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!

    var username: String?
    var useremail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SignInUI.requestExistingAccount(from: self)
    }
    
    func setupUI() {
        SignInUI.setupAppLogo(appLogoImageView, url: "img_app_logo")
        SignInUI.setupAppTitle(appTitleLabel, text: "My App")
        SignInUI.setupSignInButton(in: signInButtonView, style: .black, action: #selector(didTapSignInButton()))
        SignInUI.setupAppVersion(versionLabel)
        SignInUI.setupAppCopyright(copyrightLabel, text: "© 2019 Jaesung")
    }
    
    @objc func didTapSignInButton() {
        SignInUI.didTapSignInButton(on: self)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userInfo = SingInUI.fetchAppleIDCredential(appleIDCredential)
            
            DispatchQueue.main.async {
                self.username = userInfo[1] + userInfo[2]
                self.useremail = userInfo[3]
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let userInfo = SignInUI.fetchPasswordCredential(passwordCredential)
            DispatchQueue.main.async {
                self.username = userInfo[1] + userInfo[2]
                self.useremail = userInfo[3]
            }
        }
    }
}

```
