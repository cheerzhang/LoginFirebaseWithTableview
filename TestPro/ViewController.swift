//
//  ViewController.swift
//  TestPro
//
//  Created by 张乐 on 7/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var usernametx: UITextField!
    
    @IBOutlet weak var passwordtx: UITextField!
    
    var verificationID = ""
    
    @IBAction func clicklogin(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            print ("user is sign in")
        } else {
            // No user is signed in.
            //GIDSignIn.sharedInstance().uiDelegate = self
            //GIDSignIn.sharedInstance().signIn()
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: self.verificationID,
                verificationCode: self.passwordtx.text!)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    // ...
                    print("error when login with verificationID ",error)
                    return
                }
                // User is signed in
                // ...
                print("login with phone succeeded.")
            }
            print ("user is not sign in")
        }
        
    }
    
    
    @IBAction func getVID(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+65" + self.usernametx.text!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // Sign in using the verificationID and the code sent to the user
            self.verificationID = verificationID!
        }
    }
    
    @IBAction func signoff(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("sign off succeed.",Auth.auth().currentUser?.email ?? "<#default value#>")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    var ref: DatabaseReference? = nil
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            let user = Auth.auth().currentUser
            //self.changeUserFDB()
            //print(">>>> has got uid? ",user?.email ?? "default")
            self.submitFDB()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func connectFDB(){
        ref = Database.database().reference()
        ref?.child("theme").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            print(">>>>> folder name should see CNY:",theme)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func submitFDB(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let childRef = ref?.child("Users").child((user?.uid)!)
        let addingItem = [
            "email": usernametx.text!,
            "name": user?.displayName,
            "phonenumber": user?.phoneNumber,
            "providerID": user?.providerID,
            "storeID": "0",
            "spinDate": dateFormat.string(from: Date())
            ] as [String : Any]
        childRef?.setValue(addingItem, withCompletionBlock: { (errorAdding, ref) in
        })
    }
    
    func changeUserFDB(){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "Le Zhang"
        changeRequest?.commitChanges { (error) in
            // ...
        }
    }

    
}

