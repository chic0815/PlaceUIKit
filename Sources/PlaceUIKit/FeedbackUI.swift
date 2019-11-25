//
//  FeedbackUI.swift
//  
//
//  Created by 이재성 on 2019/11/25.
//

import UIKit

@available(iOS 10.0, *)
public class FeedbackUI {
    
    public static func setupViewTitleLabel(_ label: UILabel, text: String) {
        
    }
    
    public static func setupSendButton(_ button: UIButton) {
        button.setTitle("Send", for: .normal)
        button.setTitleColor(PlaceUI.color(.whiteSnow), for: .normal)
        button.backgroundColor = PlaceUI.color(.purple)
        
        button.layer.cornerRadius = button.frame.height / 4
        button.layer.masksToBounds = true
    }
    
    public static func setupSendButton(_ button: UIButton, initialTitle: String) {
        button.setTitle(initialTitle, for: .normal)
        button.setTitleColor(PlaceUI.color(.whiteSnow), for: .normal)
        button.backgroundColor = PlaceUI.color(.purple)
        
        button.layer.cornerRadius = button.frame.height / 4
        button.layer.masksToBounds = true
    }
    
    public static func setupTextView(_ textView: UITextView, initialText: String) {
        textView.text = initialText
        textView.textColor = PlaceUI.color(.lightPurple)
        textView.backgroundColor = PlaceUI.color(.whiteSnow)
        
        textView.layer.cornerRadius = 15.0
        textView.layer.masksToBounds = true
        
        textView.layer.borderColor = PlaceUI.color(.lightPurple).cgColor
        textView.layer.borderWidth = 1.0
    }
    
    public static func setupMessageLabel(_ label: UILabel) {
        label.alpha = 0
    }
    
    
    public static func isTextViewEmpty(_ textView: UITextView) {
        textView.text = "Please let me know your issue"
        textView.textColor = PlaceUI.color(.lightPurple)
    }
    
    public static func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = PlaceUI.color(.purple)
    }
    
    /**
     - Important:
    ```Swift
     @objc func didTapSend() {
        didSendFeedback(on: textView, messageText: notifySendingResult())
        animateMessageLabel(self.messageLabel)
     }
    ```
     */
    public static func didSendFeedback(on textView: UITextView, messageText: String) {
        if messageText == "Thank you for your feedback" {
            textView.backgroundColor = PlaceUI.color(.purple)
            textView.textColor = PlaceUI.color(.whiteSnow)
        } else if messageText == "Please enter your issue" {
            textView.backgroundColor = PlaceUI.color(.lightPink)
            textView.textColor = PlaceUI.color(.pink)
        } else {
            textView.backgroundColor = PlaceUI.color(.whiteSnow)
            textView.textColor = PlaceUI.color(.purple)
        }
    }
    
    
    /**
     `feedback = self.feedbackTextView.text`
     
     - Important: You must use this method inside of `didSendFeedback`
     */
    public static func notifySendingResult(feedback: String, button: UIButton) -> String {
        guard !feedback.isEmpty && feedback != "Please let me know your issue" else {
            button.backgroundColor = PlaceUI.color(.pink)
            
            return "Please enter your issue"
        }
        
        button.isEnabled = false
        
        return "Thank you for your feedback"
    }
    
    public static func animateMessageLabel(_ label: UILabel) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            label.alpha = 1.0
        }
        animator.startAnimation()
    }
}
