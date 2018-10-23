//
//  LoginViewController.swift
//  Instagram
//
//  Created by Ching Ching Huang on 10/23/18.
//  Copyright © 2018 Ching Ching Huang. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        if (username?.isEmpty)!{
            let title =  "Email Required"
            let message = "Please enter your email address"
            provideAlert(title: title, message: message)
        }
        if (password?.isEmpty)!{
            let title = "Password Required"
            let message =  "Please enter your password"
            provideAlert(title: title, message: message)
        }
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) -> Void in
            //Check if something went wrong w/log in
            if let error = error {
                self.provideAlert(title: "Error", message: "Please enter valid username and password")
                print(error.localizedDescription)
            }
            else if user != nil {
                print("You are logged in")
                
                //Segue to next controller
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        let username = usernameField.text
        let password = passwordField.text
        if (username?.isEmpty)!{
            let title =  "Email Required"
            let message = "Please enter your email address"
            provideAlert(title: title, message: message)
        }else{
            newUser.username = username
        }
        if (password?.isEmpty)!{
            let title = "Password Required"
            let message =  "Please enter your password"
            provideAlert(title: title, message: message)
        }else{
            newUser.password = password
        }

        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if let error = error{
                print(error.localizedDescription)
                if error._code == 202{
                    print("Username is alredy taken")                }
            } else{
                print("User Signed Up successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
    }
    
    
    func provideAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true)
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
