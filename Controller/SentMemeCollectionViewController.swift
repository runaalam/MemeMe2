//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Runa Alam on 4/10/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemeCollectionViewController: UICollectionViewController {

     // MARK: Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Cell Identifier and StoryboardId
    
    let memeCollectionCellId = "MemeCollectionCell"
    let memeEditorStoryboardId = "MemeEditor"
    let memeDetailViewStoryboardId = "MemeDetailView"
    
    // MARK: Properties
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
        
        // Setup item size and spacing using collection view flow layout
        let space:CGFloat = 0.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        // Get the sent memes from AppDelegate and reload collectionView
        memes = appDelegate.memes
        collectionView?.reloadData()
    }

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCollectionCellId, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the cell image
        
        cell.memedImageView.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: memeDetailViewStoryboardId) as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func addMemeButton(_ sender: Any) {
        let controller: MemeEditorViewController
        controller = storyboard?.instantiateViewController(withIdentifier: memeEditorStoryboardId) as! MemeEditorViewController
        
        // Present the MemeEditorViewController
        present(controller, animated: true, completion: nil)
    }
}
