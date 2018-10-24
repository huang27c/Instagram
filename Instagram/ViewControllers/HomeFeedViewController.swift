//
//  HomeFeedViewController.swift
//  Instagram
//
//  Created by Ching Ching Huang on 10/23/18.
//  Copyright © 2018 Ching Ching Huang. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var posts : [Post]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = tableView.frame.height/2.5
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchPosts()
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchPosts()
    }
    
    func fetchPosts(){
        // construct PFQuery
        let query = Post.query()!
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("image")
        query.includeKey("caption")
        query.limit = 20
 
        // fetch data asynchronously
        query.findObjectsInBackground { (posts , error) in
            if let posts = posts {
                // do something with the data fetched
                
                self.posts = posts as! [Post]
                print(posts.count)
                print("fetched posts \(posts[0]["media"])")
                self.tableView.reloadData()
            } else {
                print("Something is wrong")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            //logout
            print("Logged out!")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onCamera(_ sender: Any) {
        self.performSegue(withIdentifier: "composeSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.instagramPost = posts?[indexPath.row]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
