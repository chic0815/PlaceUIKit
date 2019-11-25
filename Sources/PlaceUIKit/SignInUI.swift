//
//  SignInUI.swift
//  
//
//  Created by Jaesung on 2019/11/24.
//

import UIKit
import AuthenticationServices

/**
 - Since: 1.0.0
 
 - Copyright: © 2019 Jaesung.
 */
public class SignInUI {
    /**
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     */
    public static func setupAppLogo(_ imageView : UIImageView, url: String) {
        imageView.image = UIImage(named: url)
    }
    
    
    /**
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     */
    public static func setupAppTitle(_ label: UILabel, text: String) {
        label.text = text
        label.textColor = PlaceUI.color(.purple)
        label.textAlignment = .center
//        label.font
    }
    
    
    /**
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     */
    public static func setupAppVersion(_ label: UILabel) {
        // info.plist ????
        guard let dictionary = Bundle.main.infoDictionary, let text = dictionary["CFBundleShortVersionString"] as? String else { return }
        label.text = text
        label.textColor = PlaceUI.color(.purple)
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        
    }
    
    
    /**
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     */
    public static func setupAppCopyright(_ label: UILabel, text: String) {
        label.text = text
        label.textColor = PlaceUI.color(.purple)
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
    }
}


@ available(iOS 13.0, *)
extension SignInUI {
    
    /**
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     
     - Available: iOS 13.0 or later
     */
    public static func setupSignInButton(on view: UIView, yValue: CGFloat, style: ASAuthorizationAppleIDButton.Style, action: Selector) {
        // TODO: If there is userdefault value about auto-signIn, type must be `.continue`
        
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: style)
        button.frame = CGRect(x: 20, y: yValue, width: view.frame.width - 40, height: 60)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        button.cornerRadius = button.frame.height / 4   // 15.0
        button.layer.masksToBounds = true
        
        view.addSubview(button)
    }
    
    
    /**
     This method requires specific `UIView` only for SignIn Button.  SignIn Button will be fit on the view.
     
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     
     - Available: iOS 13.0 or later
     
     */
    public static func setupSignInButton(in view: UIView, style: ASAuthorizationAppleIDButton.Style, action: Selector) {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: style)
        button.frame = view.frame
        button.addTarget(self, action: action, for: .touchUpInside)
        
        button.cornerRadius = button.frame.height / 4   // 15.0
        button.layer.masksToBounds = true
        
        view.addSubview(button)
    }
    
    /**
     ```Swift
     @objc
     func didTapSignInButton() {
        SignInUI.didTapSignInButton(on: self)
     }
     ```
     
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     
     - Available: iOS 13.0 or later
     */
    public static func didTapSignInButton(on viewController: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = viewController
        authorizationController.presentationContextProvider = viewController
        authorizationController.performRequests()
    }
    
    /**
     Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
     
     - Important: Call this method after view appeared.
     
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     
     - Available: iOS 13.0 or later
     */
    public static func requestExistingAccount(from viewController: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = viewController
        authorizationController.presentationContextProvider = viewController
        authorizationController.performRequests()
    }
    
    
    /**
     This method is called, when Authorization completed successfully
     
     - Returns: [userIdentifer, givenName, familyName: email] or [username, password] or an empty array.
     
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     
     - Available: iOS 13.0 or later
     */
    public static func authenticatedSuccessfully(with authorization: ASAuthorization) -> [String?] {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            return fetchAppleIDCredential(appleIDCredential)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            return fetchPasswordCredential(passwordCredential)
        } else {
            return []
        }
    }
        
    /**
     - Returns:
        - userIdentifier: must have value
        - givenName: can be `nil`
        - familyName: can be `nil`
        - email: can be `nil`
     
     - Since: 1.0.0
     
     - Copyright: © 2019 Jaesung.
     
     - Available: iOS 13.0 or later
     */
    public static func fetchAppleIDCredential(_ appleIDCredential: ASAuthorizationAppleIDCredential) -> [String?] {
        
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
        
        return [userIdentifier, fullName?.givenName, fullName?.familyName, email]
    }
    
    public static func fetchPasswordCredential(_ passwordCredential: ASPasswordCredential) -> [String] {
        // Sign in using an existing iCloud Keychain credential.
        let username = passwordCredential.user
        let password = passwordCredential.password
        
        return [username, password]
    }
}

