//
//  File.swift
//  
//
//  Created by 이재성 on 2019/11/25.
//

import UIKit

public protocol KeyboardImplementable {
    var isKeyboardShown: Bool { get set }
}
/**
 Before use `KeyboardUI`, please declare `isKeyboardShown = false` as a boolean value.
 
 - Important:
    - `isKeyboardShown`
    - `constraintFromCenter`
    - `textViewFromBottom`
 */
@available(iOS 10.0, *)
public class KeyboardUI {
    public static func keyboardWillShow(action: Selector) {
        NotificationCenter.default.addObserver(self, selector: action, name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    public static func keyboardWillHide(action: Selector) {
        NotificationCenter.default.addObserver(self, selector: action, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    public static func distanceToMove(_ notification: Notification, textView: UITextView, view: UIView) -> CGFloat {
        guard let keyboardFrameBegin = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else  { return 0.0 }
        let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
        let keyboardHeight = keyboardFrameBeginRect.size.height
        return keyboardHeight + textView.frame.maxY - view.frame.maxY + CGFloat(8.0)
    }
    
    public static func distanceToMove(_ notification: Notification, textField: UITextField, view: UIView) -> CGFloat {
        guard let keyboardFrameBegin = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else  { return 0.0 }
        let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
        let keyboardHeight = keyboardFrameBeginRect.size.height
        return keyboardHeight + textField.frame.maxY - view.frame.maxY + CGFloat(8.0)
    }
    
    /**
     ```Swift
     @objc func keyboardWillShow(_ notification: Notification, imageViewFromCenter: NSLayoutConstraint, textViewFromBottom: NSLayoutConstraint) {
        let distanceToMove = KeyboardUI.distanceToMove(_:textView:view:)
     
        if self.!isKeyboardShown {
            KeyboardUI.keyboardWillShow(textView:logoImageView:titleLabel:messageLabel:constraintFromCenter:textViewFromBottom:contentView:distanceToMove)
        }
     
        self.isKeyboardShown = true
     }
     ```
     */
    public static func keyboardWillShow(textView: UITextField, logoImageView: UIImageView, titleLabel: UILabel, messageLabel: UILabel, constraintFromCenter: NSLayoutConstraint, textViewFromBottom: NSLayoutConstraint, contentView: UIView, distanceToMove: CGFloat) {
        logoImageView.alpha = 1.0
        titleLabel.alpha = 0
        messageLabel.alpha = 0
        contentView.layoutIfNeeded()
        
        textViewFromBottom.constant += distanceToMove
        constraintFromCenter.constant = logoImageView.frame.maxY + 20 > textView.frame.minY ? constraintFromCenter.constant + distanceToMove : constraintFromCenter.constant
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            contentView.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    public static func keyboardWillShow(textField: UITextField, logoImageView: UIImageView, titleLabel: UILabel, messageLabel: UILabel, constraintFromCenter: NSLayoutConstraint, textFieldFromBottom: NSLayoutConstraint, contentView: UIView, distanceToMove: CGFloat) {
        logoImageView.alpha = 1.0
        titleLabel.alpha = 0
        messageLabel.alpha = 0
        contentView.layoutIfNeeded()
        
        textFieldFromBottom.constant += distanceToMove
        constraintFromCenter.constant = logoImageView.frame.maxY + 20 > textField.frame.minY ? constraintFromCenter.constant + distanceToMove : constraintFromCenter.constant
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            contentView.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    /**
    ```Swift
    @objc func keyboardWillHide(_ notification: Notification) {
       KeyboardUI.keyboardWillHide(logoImageView:titleLabel:constraintFromCenter:textFieldFromBottom:contentView:)
    
       self.isKeyboardShown = false
    }
    ```
    */
    public func keyboardWillHide(logoImageView: UIImageView, titleLabel: UILabel, constraintFromCenter: NSLayoutConstraint, textFieldFromBottom: NSLayoutConstraint, contentView: UIView) {
        constraintFromCenter.constant = -30
        textFieldFromBottom.constant = 140
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            logoImageView.alpha = 1.0
            titleLabel.alpha = 1.0
            contentView.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}
