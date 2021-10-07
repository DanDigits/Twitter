//  HomeTableViewController.swift
//  Twitter
//
//  Created by Daniel Cruz Castro on 10/2/21.
//  Copyright © 2021 Dan. All rights reserved.
import UIKit

class HomeTableViewController: UITableViewController {
    // Declarations
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    // Body
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        //self.tableView.rowHeight = UITableView.automaticDimension
        //self.tableView.estimatedRowHeight = 150
    }
    
    // DOES NOT WORK FOR SOME REASON
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
   
    
// Functions
    @IBAction func logoutButton(_ sender: Any) {
        // Body: set logged in toggle to false to log user out.
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Declarations
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        // Body: Set cell properties
        cell.profileNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
    
    @objc func loadTweets() {
        // Declarations
        numberOfTweets = 20
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        // Body: Call API and set recieved information into tweetArray
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { Error in
            print("Error, could not retrieve tweets!")
            print(Error.localizedDescription)
        })
    }
    
    func loadMoreTweets() {
        // Declarations
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        // Body: Call API and assign receptions to tweetArray
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { Error in
            print("Error, could not retrieve additional tweets!")
            print(Error.localizedDescription)
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay Cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Body: load more tweets if null index is equal to the current tweet count
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
