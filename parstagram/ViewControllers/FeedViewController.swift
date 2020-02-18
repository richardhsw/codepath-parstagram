//
//  FeedViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Alamofire
import AlamofireImage
import Parse
import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    
    let numQueries = 20
    var posts = [PFObject]()
    
    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate   = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:PostsDB.name.rawValue)
        query.includeKey(PostsDB.author.rawValue)
        query.limit = numQueries
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
            else {
                print("error")
            }
        }
    }
    
    
    // MARK: - TableView FUnctions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifiers.post.rawValue) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        // Get username
        let user = post[PostsDB.author.rawValue] as! PFUser
        cell.usernameLabel.text = user.username
        
        // Get image caption
        cell.captionLabel.text = post[PostsDB.caption.rawValue] as? String
        
        // Get image
        DataRequest.addAcceptableImageContentTypes(["image/jpeg", "image/jpg", "image/png", "application/octet-stream"])
        let imageFire = post[PostsDB.image.rawValue] as! PFFileObject
        let urlString = imageFire.url!
        let url       = URL(string: urlString)!
        cell.photoImageView.af_setImage(withURL: url)
        
        return cell
    }
}
