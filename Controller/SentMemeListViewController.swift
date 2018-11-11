//
//  SentMemeListViewController.swift
//  MemeMe
//
//  Created by Runa Alam on 8/10/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit

class SentMemeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Cell Identifier and StoryboardId
    
    let memeTableCellIdentifier = "MemeTableCell"
    let memeEditorStoryboardId = "MemeEditor"
    let memeDetailViewStoryboardId = "MemeDetailView"
    
    //MARK: Properties
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the sent memes from AppDelegate and reload tableView
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    //MARK: IBAction Method for Add new Meme
    
    @IBAction func openMemeEditor(_ sender: Any) {
   
        let controller = storyboard?.instantiateViewController(withIdentifier: memeEditorStoryboardId) as! MemeEditorViewController
        // Present the MemeEditorViewController
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: Table View Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = Bundle.main.loadNibNamed("MemeTableCell", owner: self, options: nil)?.first as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image and label for cell
        cell.memedImageView.image = meme.memedImage
        cell.sentMemeLable.text = meme.topText.prefix(11) + "..." + meme.bottomText.suffix(10)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: memeDetailViewStoryboardId) as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.appDelegate.memes.remove(at: indexPath.row)
            self.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
