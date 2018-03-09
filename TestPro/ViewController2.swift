//
//  ViewController2.swift
//  TestPro
//
//  Created by 张乐 on 7/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction func backpage(_ sender: Any) {
    }
    var ref: DatabaseReference? = nil
    var handle: AuthStateDidChangeListenerHandle?
    
    var sections = ["Campaign"]
    var flist:Array<String> = []
    var campNo = ""

    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            let user = Auth.auth().currentUser
            print(">>>> has got uid? page 2",user?.email ?? "default")
            if Auth.auth().currentUser != nil {
                // User is signed in.
                self.getStoreID()
                print ("go get store id")
            }
            //self.submitFDB()
        }
        //self.getStoreID()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func getStoreID(){
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref?.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storeID = value?["storeID"] as? String ?? ""
            self.getStoreName(storeid: storeID)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getStoreName(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let campaignID = value?["campaign"] as? String ?? ""
            let storen = value?["name"] as? String ?? ""
            self.storeName.text = storen
            print(">>>>> storeID ",campaignID)
            let CampineArr = campaignID.split(separator: "|").map(String.init)
            for c in CampineArr{
                self.getCampaignName(storeid: c)
            }
            //var fcol:String = CampineArr[0]
            //self.getCampaignName(storeid: fcol)
            //fcol = CampineArr[1]
            //self.tableView.reloadData()
            //self.getCampaignName(storeid: fcol)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCampaignName(storeid:String){
        ref = Database.database().reference()
        ref?.child("theme").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let campaignname = value?["folderName"] as? String ?? ""
            self.flist.append(campaignname)
            print("refreshed,",campaignname)
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style :UITableViewCellStyle.default, reuseIdentifier: "CampaignViewCell")
        //cell.textLabel?.text = flist[indexPath.row]
        //cell.tag = indexPath.row
        //cell.target(forAction: Selector(("getAction:")), withSender: self)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = flist[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flist.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //let i = indexPath.row
        print(indexPath.row)
        let row = indexPath.row
        print("current cell clicked ", row)
        self.campNo = String(row)
        //let destination = storyboard?.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        //destination.stringPassed = String(row)
        //navigationController?.pushViewController(destination, animated: true)
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            // Setup new view controller
            if let destinationViewController = segue.destination as? DetailController {
                destinationViewController.stringPassed = self.campNo
            }
        }
    }
    
}
