//
//  ImagePreviewViewController.swift
//  MessageCenter
//
//  Created by Ikarma Khan on 14/12/2018.
//

import UIKit

protocol ImagePreviewProtocol: class {
    func imagePreviewDidDismiss(_ image: UIImage? , caption: String)
}

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var messageInputView: SBMessageInputView!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var lblCaption: UILabel!
    
    @IBOutlet weak var vwGradient: UIView!
    @IBOutlet weak var inputViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    
    private var keyboardShown: Bool = false
    
    var strCaption: String = ""
    var imageToUpload : UIImage?
    
    var delegate: ImagePreviewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSend.layer.cornerRadius = 22.0
        self.imgPicture.image = imageToUpload!
        
        self.messageInputView.textView.text = strCaption
        messageInputView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.12).cgColor
        self.messageInputView.layer.cornerRadius = 8.0
        self.messageInputView.layer.masksToBounds = true
        self.messageInputView.layer.borderWidth = 1.0
        self.messageInputView.delegate = self
        self.lblCaption.isHidden = strCaption.count > 0
        self.lblCaption.text = "caption".localized
        
        self.addObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createGradientLayer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.52)
        let endColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        gradientLayer.frame = self.vwGradient.bounds
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 0.15]
        self.imgPicture.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func tapHandler(_ sender: Any) {
        self.view.endEditing(true)
    }
    func addObservers() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
     
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        self.keyboardShown = true
        
        let keyboardInfo = notification.userInfo
        let keyboardFrameBegin = keyboardInfo?[UIKeyboardFrameEndUserInfoKey]
        let keyboardFrameBeginRect = (keyboardFrameBegin as! NSValue).cgRectValue
        
        DispatchQueue.main.async {
            
            self.bottomMargin.constant = keyboardFrameBeginRect.size.height
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (status) in
                
            })
        }
    }
    
    @objc private func keyboardDidHide(notification: Notification) {
        self.keyboardShown = false
        
        DispatchQueue.main.async {
            self.bottomMargin.constant = 0
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (status) in
                
            })
            
            
//            self.chattingView.scrollToBottom(force: false)
        }
    }
    
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        self.view.endEditing(true)
        strCaption = messageInputView?.textView.text ?? ""
        if strCaption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            strCaption = ""
        }
        if self.delegate != nil {
            self.delegate?.imagePreviewDidDismiss(self.imageToUpload, caption: strCaption)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}


extension ImagePreviewViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        strCaption = textView.text!
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }        
        return true
    }
    
}

extension ImagePreviewViewController: SBMessageInputViewDelegate {
    func inputViewDidTapButton(button: UIButton) {
        
    }
    func inputViewDidBeginEditing(textView: UITextView) {
        
    }
    func inputViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    func inputView(textView: UITextView, shouldChangeTextInRange: NSRange, replacementText: String) -> Bool {
        return true
    }
    
    func inputViewDidChange(textView: UITextView) {
        
        if textView.text.count > 0  {
            self.lblCaption.isHidden = true
        }
        else {
            self.lblCaption.isHidden = false
        }
    }
}
