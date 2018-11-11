//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Runa Alam on 3/9/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    // MARK: Outlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Properties
    
    let DEFAULT_TOP_TEXT = "TOP"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"
    var activeTextField = UITextField()
    let bottomTextFieldTag = 1
    var meme: Meme!
    
    // Mark: StoryboardId
    
    let sentMemeTabStoryboardId = "SentMemeTabView"
    let sentMemeTableViewId = "sentMemeTableViewId"
    let sentMemeCollectionViewId = "sentMemeCollectionViewId"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        initialConfiguration()
        
        if (meme != nil) {
            self.imageView.image = meme.originalImage
            self.topTextField.text = meme.topText
            self.bottomTextField.text = meme.bottomText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (imageView.image != nil) {
            shareButton.isEnabled = true
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Configuration for other elements and Textfiled
    
    func initialConfiguration() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        imageView.image = nil
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.attributedTextField(placeHolder: DEFAULT_TOP_TEXT)
        bottomTextField.attributedTextField(placeHolder: DEFAULT_BOTTOM_TEXT)
        self.hideKeyboardWhenTappedAround()
        shareButton.isEnabled = false
    }
    
    // MARK: Notified when the keyboard appears
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (activeTextField.tag == bottomTextFieldTag) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    
    //MARK: IBAction Methods
    
    // Allows the user to pick an image from the Photos library
    @IBAction func pickAnImage(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pick(sourceType: .photoLibrary)
        }
    }
    
     // Allows the user to take a new picture using the device camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pick(sourceType: .camera)
    }
    
    // Opens the acivity view controller to share the image
    @IBAction func shareButtonTapped(_ sender: Any) {
        //generate Meme Iamge
        let memeImage = generateMemedImage()
        
        // set up activity view controller
        let imageToShare = [ memeImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, successful: Bool, returnedItems: [Any]?, error: Error?) in
            if successful {
                self.save()
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // Dismiss the presented instance of MemeEditorViewController
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            
            if (sourceType == .camera) {
                imagePicker.cameraCaptureMode = .photo
                imagePicker.modalPresentationStyle = .fullScreen
            }
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Mark: Save and Generate Meme
    
    /// Returns a UIImage object generated from the current view
    func generateMemedImage() -> UIImage {

        // Hide NavigationBar and Toolbar
        toggleExtraViews(hide: true)
       
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toggleExtraViews(hide: false)
        
        return memedImage
    }
    
    private func toggleExtraViews(hide: Bool) {
        navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        //Add it to the memes array on the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    
         self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Delegate Methods(Image Picker)
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
