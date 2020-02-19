//
//  FeedViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Alamofire
import AlamofireImage
import MBProgressHUD
import Parse
import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    
    let startingQueries  = 20
    let incrementQueries = 10
    var posts = [PFObject]()
    var refreshControl : UIRefreshControl!
    var isLoadingData : Bool = false
    var reachedDataEnd : Bool = false
    
    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableview
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.allowsSelection = false
        
        /***----- Unused Header Code
        let headNib = UINib.init(nibName: TableViewIdentifiers.header.rawValue, bundle: Bundle.main)
        tableView.register(headNib, forHeaderFooterViewReuseIdentifier: TableViewIdentifiers.header.rawValue)
        ***/
        
        // Set up refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queryPosts(for: startingQueries)
    }
    
    
    // MARK: - TableView FUnctions
    /***----- Unused Header Code -----
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewIdentifiers.header.rawValue) as! PostTableViewHeader
        header.usernameLabel.text = "richard"
        return header
    }
    ***/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.feedTable.rawValue) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        // Get username
        let user = post[PostsDB.author.rawValue] as! PFUser
        cell.usernameLabel.text = user.username
        cell.cptnUsernameLabel.text = user.username
        
        // Get profile picture
        DataRequest.addAcceptableImageContentTypes(["image/jpeg", "image/jpg", "image/png", "application/octet-stream"])
        let profileImageFire = user[UsersDB.profileImage.rawValue] as? PFFileObject
        
        if profileImageFire != nil {
            let urlString = profileImageFire!.url!
            let url       = URL(string: urlString)!
            cell.profileImageView.af_setImage(withURL: url)
        }
        
        // Get image caption
        cell.captionLabel.text = post[PostsDB.caption.rawValue] as? String
        
        // Get image
        DataRequest.addAcceptableImageContentTypes(["image/jpeg", "image/jpg", "image/png", "application/octet-stream"])
        let imageFire = post[PostsDB.image.rawValue] as! PFFileObject
        let urlString = imageFire.url!
        let url       = URL(string: urlString)!
        cell.photoImageView.af_setImage(withURL: url)
        
        // Get time ago
        cell.timestampLabel.text = post.createdAt?.getElapsedInterval()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let canLoadMore = !isLoadingData && !reachedDataEnd && (indexPath.row + 1 == posts.count)
        
        if canLoadMore {
            queryPosts(for: posts.count + incrementQueries)
        }
    }
    
    @objc func onRefresh() {
        queryPosts(for: startingQueries)
        
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - Action Functions
    @IBAction func onLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        PFUser.logOut()
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Network Query Functions
    func queryPosts(for numPosts : Int) {
        isLoadingData = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let query = PFQuery(className:PostsDB.name.rawValue)
        query.addDescendingOrder(PostsDB.createdAt.rawValue)
        query.includeKey(PostsDB.author.rawValue)
        query.limit = numPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                // If we reached the end of the posts, stop infinite scrolling
                if (posts!.count == self.posts.count) {
                    self.reachedDataEnd = true
                }
                else {
                    self.isLoadingData = false
                    self.reachedDataEnd = false
                }
                
                self.posts = posts!
                self.tableView.reloadData()
            }
            else {
                print("Error while retreiving posts")
                self.displayShareError(error: error!)
            }
        }

        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func displayShareError(error: Error) {
        let message = Errors.queryMessage.rawValue + "\(error.localizedDescription)"
        let alertController = UIAlertController(title: Errors.queryMessage.rawValue, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
