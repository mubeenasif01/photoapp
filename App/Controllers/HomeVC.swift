//
//  HomeVC.swift
//  App
//
//  Created by M.Mubeen Asif on 06/08/2019.
//  Copyright © 2019 M.Mubeen Asif. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var imageCollectionView: UICollectionView!
    var images = ["1","2","3"]
    var selectedImageTag = 0
    var usrnm = UserDefaults.standard.string(forKey: "username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkdata()
        imageCollectionView.reloadData()
    // Do any additional setup after loading the view.
    }
    
    
    
    //    mark: add image
    @IBAction func addImageBtn(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionsheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                //               mark: camera
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print ("Not Available")
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            //           Mark: photolibrary
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionsheet, animated: true, completion: nil)
        
        
    }
    
    
    
    //    mark: logoutbtn
    
    @IBAction func logoutbtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "username")
        performSegue(withIdentifier: "signout", sender: self)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imgcell", for: indexPath) as! galleryCell
            if let contentsOfFilePath = UIImage(contentsOfFile: images[indexPath.row]) {
            cell.imagevu.image = contentsOfFilePath
            }
        
        cell.delegate = self
        cell.indexPath = indexPath
        //imageCollectionView.reloadData()
        return cell
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        picker.dismiss(animated: true, completion: nil)
        // Get access to shared instance of the file manager
        let fileManager = FileManager.default
        
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            images.removeAll()
            for data in result as! [NSManagedObject] {
                selectedImageTag = data.value(forKey: "tag") as! Int
            }
        } catch {
            print("Tag getting Failed")
        }
        
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Get the document URL as a string
        let documentPath = documentsURL.path
        
        // Create filePath URL by appending final path component (name of image)
        let filePath = documentsURL.appendingPathComponent("\(String(selectedImageTag)).png")
        
        
                // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            for file in files {
                // If we find existing image filePath delete it to make way for new imageData
                if "\(documentPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        
        do {
            if let pngImageData = selectedImage.pngData() {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("couldn't write image")
        }
        selectedImageTag = selectedImageTag + 1
        print(filePath.path)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(usrnm, forKey: "usrnm")
        newUser.setValue(selectedImageTag, forKey: "tag")
        newUser.setValue(filePath.path, forKey: "img")
        do {
            try context.save()
            print("Image saved")
            let alert = UIAlertController(title: "Success", message: "Image Saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            }))
            checkdata()
            self.present(alert, animated: true, completion: nil)
        } catch {
            print("Failed saving")
        }
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    //    mark: get images
    
    func checkdata()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            images.removeAll()
            for data in result as! [NSManagedObject] {
                if UserDefaults.standard.string(forKey: "username") == data.value(forKey: "usrnm") as! String
                {
                    images.append(data.value(forKey: "img") as! String)
                }
                
                print(images)
            }
            imageCollectionView.reloadData()
        } catch {
            print("Failed")
        }
        
        
    }
    
    
    

}
extension HomeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return  CGSize(width: width, height: height)
    }
}
extension HomeVC: imbgecellDelegate
{
    func deleteimage(indexPath: Int) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete the image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            var imgname = self.images[indexPath]
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let managedContext = appDelegate?.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Images")
                fetchRequest.predicate = NSPredicate(format: "img = %@", "\(imgname)")
                do
                {
                    let fetchedResults =  try managedContext!.fetch(fetchRequest) as? [NSManagedObject]
        
                    for entity in fetchedResults! {
        
                        managedContext?.delete(entity)
                        self.checkdata()
                        self.imageCollectionView.reloadData()
                    }
                }
                catch _ {
                    print("Could not delete")
        
                }
        }))
        let No = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(No)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}
