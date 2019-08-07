//
//  SigninVC.swift
//  Gallery
//
//  Created by M.Mubeen Asif on 06/08/2019.
//  Copyright © 2019 M.Mubeen Asif. All rights reserved.
//

import UIKit
import CoreData

class SigninVC: UIViewController {
    
    
    @IBOutlet weak var usnmtxtfld: UITextField!
    @IBOutlet weak var pswdtxtfld: UITextField!
    var usrname : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func signinbtn(_ sender: Any) {
        
        if usnmtxtfld.text == "" || pswdtxtfld.text == ""
        {
            let alert = UIAlertController(title: "warning", message: "username or password is empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.returnsObjectsAsFaults = false
            do {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    usrname = data.value(forKey: "username") as! String
                    password = data.value(forKey: "password") as! String
                    if (usnmtxtfld.text == usrname && pswdtxtfld.text == password)
                    {
                        print("record found successfull")
                        UserDefaults.standard.set(usnmtxtfld.text, forKey: "username")
                        performSegue(withIdentifier: "gallery", sender: self)
                    }
                }
                let alert = UIAlertController(title: "Invalid Login", message: "username or password is incorrect", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } catch {
                
                print("Failed")
            }
        }
    }
    
}
