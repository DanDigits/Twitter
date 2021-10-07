//  LoginViewController.swift
//  Twitter
//
//  Created by Daniel Cruz Castro on 10/2/21.
//  Copyright © 2021 Dan. All rights reserved.
import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// Functions
    override func viewDidAppear(_ animated: Bool) {
        // Body: Skip login page once logged in, through checking toggle
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        // Declarations
        let tokenURL:String = "https://api.twitter.com/oauth/request_token"
        
        // Body: login button with toggle implementation to save status
        TwitterAPICaller.client?.login(url: tokenURL, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { Error in
            print("Could not log in")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
