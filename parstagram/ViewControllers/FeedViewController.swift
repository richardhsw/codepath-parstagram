//
//  FeedViewController.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import AlamofireImage
import MBProgressHUD
import MessageInputBar
import Parse
import UIKit

class FeedViewController: UIViewController, MessageInputBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    
    let startingQueries  = 20
    let incrementQueries = 10
    let commentBar = MessageInputBar()
    
    var posts = [PFObject]()
    var refreshControl : UIRefreshControl!
    var isLoadingData  : Bool = false
    var reachedDataEnd : Bool = false
    var showsCommentBar = false
    var selectedPost   : PFObject!
    
    
    // MARK: - Init Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize commentBar default messages
        commentBar.inputTextView.placeholder = MessageInputBarStrings.addCommentMessage.rawValue
        commentBar.sendButton.title = MessageInputBarStrings.addCommentButton.rawValue
        commentBar.delegate = self
        
        // Set up tableview
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.keyboardDismissMode = .interactive
        
        /***----- Unused Header Code
        let headNib = UINib.init(nibName: TableViewIdentifiers.header.rawValue, bundle: Bundle.main)
        tableView.register(headNib, forHeaderFooterViewReuseIdentifier: TableViewIdentifiers.header.rawValue)
        ***/
        
        // Set up refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up notification observer
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queryPosts(for: startingQueries)
    }
    
    
    // MARK: - TableView FUnctions
    /** ----- Unused Header Code -----
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewIdentifiers.header.rawValue) as! PostTableViewHeader
        header.usernameLabel.text = "richard"
        return header
    }
    **/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post[PostsDB.comments.rawValue] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post[PostsDB.comments.rawValue] as? [PFObject]) ?? []
        
        // Cell is a post cell if it's the first cell in the section
        if (indexPath.row == 0) {
            return populatePostCell(with: post)
        }
        // Cells that are comment cells
        else if (indexPath.row <= comments.count) {
            let comment = comments[indexPath.row - 1]
            
            return populateCommentsCell(with: comment)
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.addCommentTableCell.rawValue)!
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let canLoadMore = !isLoadingData && !reachedDataEnd && (indexPath.row + 1 == posts.count)
        
        if canLoadMore {
            queryPosts(for: posts.count + incrementQueries)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post[PostsDB.comments.rawValue] as? [PFObject]) ?? []
        
        if (indexPath.row == comments.count + 1) {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
    }
    
    
    // MARK: - TableView Helper Functions
    func populatePostCell(with post: PFObject) -> PostTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.postTableCell.rawValue) as! PostTableViewCell
        
        // Get username
        let user = post[PostsDB.author.rawValue] as! PFUser
        cell.usernameLabel.text = user.username
        cell.cptnUsernameLabel.text = user.username
        
        // Get profile picture
        let profileImageFire = user[UsersDB.profileImage.rawValue] as? PFFileObject
        
        if profileImageFire != nil {
            let urlString = profileImageFire!.url!
            let url       = URL(string: urlString)!
            cell.profileImageView.af.setImage(withURL: url)
        }
        else {
            cell.profileImageView.image = UIImage(named: Assets.defaultProfile.rawValue)
        }
        
        // Get image caption
        cell.captionLabel.text = post[PostsDB.caption.rawValue] as? String
        
        // Get image
        let imageFire = post[PostsDB.image.rawValue] as! PFFileObject
        let urlString = imageFire.url!
        let url       = URL(string: urlString)!
        cell.photoImageView.af.setImage(withURL: url)
        
        // Get time ago
        cell.timestampLabel.text = post.createdAt?.getElapsedInterval()
        
        return cell
    }
    
    func populateCommentsCell(with comment: PFObject) -> CommentTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.commentTableCell.rawValue) as! CommentTableViewCell
        
        let user = comment[CommentsDB.author.rawValue] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.commentLabel.text = comment[CommentsDB.text.rawValue] as? String
        
        return cell
    }
    
    @objc func onRefresh() {
        queryPosts(for: startingQueries)
        
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - MessageInputBar Functions
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create the comment
        let comment = PFObject(className: CommentsDB.name.rawValue)
        comment[CommentsDB.text.rawValue]   = text
        comment[CommentsDB.post.rawValue]   = selectedPost
        comment[CommentsDB.author.rawValue] = PFUser.current()!

        selectedPost.add(comment, forKey: PostsDB.comments.rawValue)

        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Comment saved successfully")
            }
            else {
                print("Error saving comment")
            }
        }
        
        tableView.reloadData()
        
        // Clear and dismiss the input bar
        hideInputBar()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        hideInputBar()
    }
    
    func hideInputBar() {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    
    // MARK: - Action Functions
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: StoryboardIDs.mainStoryboard.rawValue, bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: StoryboardIDs.loginView.rawValue)
        
        view.window?.rootViewController = loginViewController
    }
    
    
    // MARK: - Network Query Functions
    func queryPosts(for numPosts : Int) {
        isLoadingData = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let query = PFQuery(className:PostsDB.name.rawValue)
        query.addDescendingOrder(PostsDB.createdAt.rawValue)
        
        // Keys to include
        let commentsString = PostsDB.comments.rawValue
        let commentsAuthor = commentsString + "." + CommentsDB.author.rawValue
        query.includeKeys([PostsDB.author.rawValue, commentsString, commentsAuthor])
        
        query.limit = numPosts
        
        // Post the query to Parse
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
