//
//  SignupVC.swift
//  Gallery
//
//  Created by M.Mubeen Asif on 06/08/2019.
//  Copyright © 2019 M.Mubeen Asif. All rights reserved.
//

import UIKit
import CoreData


class SignupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet var dobtxtfld: UITextField!
    @IBOutlet var gendertxtfld: UITextField!
    @IBOutlet var usnmtxtfld: UITextField!
    @IBOutlet var pswdtxtfld: UITextField!
    var usrname : String?
    var selectedGender : String?
    var genders = ["Male","Female"]
    var datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismisspickerview()
    }
    
    @IBAction func signupbtn(_ sender: Any) {
        checkEmptyTxtFld()
    }
    
    
    //    mark: user registering
    func userRegister()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(usnmtxtfld.text, forKey: "username")
        newUser.setValue(pswdtxtfld.text, forKey: "password")
        newUser.setValue(gendertxtfld.text, forKey: "gender")
        newUser.setValue(dobtxtfld.text, forKey: "dob")
        do {
            try context.save()
            print("record saved")
            let alert = UIAlertController(title: "Success", message: "User Registered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                self.performSegue(withIdentifier: "signinvc", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        } catch {
            print("Failed saving")
        }
    }
    
    
    
    //    mark: check duplicate users
    func checkUser()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                usrname = data.value(forKey: "username") as! String
                if (usnmtxtfld.text == usrname)
                {
                    let alert = UIAlertController(title: "Warning", message: "username already registered", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    usnmtxtfld.text?.removeAll()
                }
            }
            userRegister()
        } catch {
            print("Failed")
        }
    }
    
    
    //    mark: check empty text fields
    func checkEmptyTxtFld() {
        if usnmtxtfld.text == "" || pswdtxtfld.text == "" || gendertxtfld.text == "" || dobtxtfld.text == ""
        {
            let alert = UIAlertController(title: "Warning", message: "Enter all data", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            checkUser()
        }
    }
    
    //    mark: picker View Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genders[row]
        gendertxtfld.text = selectedGender
    }
    
    
    
    //    mark: creating Picker View
    func createPickerView()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        gendertxtfld.inputView = pickerView
//        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(SignupVC.dateChanged(datepicker:)), for: .valueChanged)
        dobtxtfld.inputView = datePicker
    }
    
    
    //    mark: dismiss Picker View
    func dismisspickerview()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolbar.setItems([donebtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        gendertxtfld.inputAccessoryView = toolbar
        dobtxtfld.inputAccessoryView = toolbar
    }
    
    @objc func dateChanged(datepicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyy"
        print(dateFormatter.string(from: datePicker.date))
        dobtxtfld.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
