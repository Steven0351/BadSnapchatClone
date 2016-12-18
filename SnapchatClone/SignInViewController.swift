//
//  SignInViewController.swift
//  SnapchatClone
//
//  Created by Steven Sherry on 12/17/16.
//  Copyright © 2016 Affinity for Apps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    
    @IBAction func turnUpTapped(_ sender: Any) {
        
        //Attempt to sign in
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("We tried to sign in")
            
            //If user does not have an account create one
            
            if error != nil {
                print("Hey we have an error:\(error)")
                
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("We tried to create a user")
                    
                    //After account is created, sign the user in
                    
                    if error != nil {
                        print("Hey we have an error:\(error)")
                    } else {
                        print("User created successfully")
                        
                    FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                        
                        
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    }
                })
                
                //If user does have an account, sign them in
                
            } else {
                print("We Signed In")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
            
        })
        
    }
    
}
