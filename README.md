# PlaceUIKit

A description of this package.


## Copyright

© 2019 Jaesung. All Rights Reserved.


## License

MIT License

Copyright (c) 2019 Jaesung Lee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


## Supporting

### Supported Platform: iOS 13.0 or later

### Versions of Swift: Swift 5.0 or later


## Contact

### Jaesung
chic0815@icloud.com


## Version History

### 1.0.7

> Nov 25, 2019

### 1.0.6

> Nov 25, 2019

### 1.0.5

> Nov 25, 2019

### 1.0.4

> Nov 25, 2019

### 1.0.3

> Nov 25, 2019

### 1.0.2

> Nov 25, 2019

### 1.0.1

> Nov 24, 2019

### 1.0.0

> Nov 24, 2019


## How to import Swift Package

> **URL**: git@gitlab.com:chic0815/placeuikit.git

1. Go to Project > Swift Package

2. Press `+` button

3. Enter package repository URL (git@gitlab.com:chic0815/placeuikit.git)

4. Select Version and check the version(You can check current version on "Version History")



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
import UIKit
import PlaceUIKit
import AuthenticationServices

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
        SignInUI.setupSignInButton(self, in: signInButtonView, style: .black, action: #selector(didTapSignInButton))
        SignInUI.setupAppVersion(versionLabel)
        SignInUI.setupAppCopyright(copyrightLabel, text: "© 2019 Jaesung")
    }
    

    @objc func didTapSignInButton() {
        SignInUI.didTapSignInButton(on: self)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let userInfo = SignInUI.fetchAppleIDCredential(appleIDCredential)

            DispatchQueue.main.async {
                self.username = (userInfo[1] ?? "") + (userInfo[2] ?? "")
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
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

```
