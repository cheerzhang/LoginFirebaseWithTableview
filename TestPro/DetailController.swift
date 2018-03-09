//
//  DetailController.swift
//  TestPro
//
//  Created by 张乐 on 8/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var titlelabel: UILabel!
    
    var stringPassed:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titlelabel.text = stringPassed
        print(">>> here now string pass",self.titlelabel.text ?? "default")
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
    
    func backpage(){
        
    }

}
