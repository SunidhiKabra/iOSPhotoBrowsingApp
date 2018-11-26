//
//  PhotoViewController.swift
//  FirebaseInClass01
//
//  Created by Kabra, Sunidhi on 11/21/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//

import UIKit
import Firebase

class PhotoViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    var post: eventStruct?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("post = \(String(describing: post))")
        
        self.imageView.sd_setImage(with: post!.url)
    }

    @IBAction func onClickBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickDeleteButton(_ sender: Any) {
        let alert = UIAlertController(title: "Photo Delete", message: "Do you want to delete this photo?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.ref = Database.database().reference()
            self.ref.child(Auth.auth().currentUser!.uid).child(self.post!.timeStamp).removeValue()
            
            let storage = Storage.storage()
            let url = self.post!.url
            let storageRef = storage.reference(forURL: String(describing: url))
            
            //Removes image from storage
            storageRef.delete { error in
                if let error = error {
                    print(error)
                } else {
                    // File deleted successfully
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
