//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Runa Alam on 11/10/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: StoryboardId
    let memeEditorStoryboardId = "MemeEditor"
    
    // MARK: Outlets
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        memedImageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: IBAction
    
    @IBAction func editMemeButton(_ sender: Any) {
        
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: memeEditorStoryboardId) as! MemeEditorViewController
        
        memeEditorController.meme = self.meme
        // Present the view Controller
        present(memeEditorController, animated: true, completion: nil)
    }
}
