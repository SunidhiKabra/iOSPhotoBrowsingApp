//
//  HomeController.swift
//  FirebaseInClass01
//
//  Created by Kabra, Sunidhi on 11/12/18.
//  Copyright © 2018 UNC Charlotte. All rights reserved.
//
import UIKit
import Firebase
import SDWebImage




class HomeController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var image: UIImage!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
 
    let storageReference = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser
    let uploadMetaData = StorageMetadata()

    var database: Database! = Database.database()
    var storage: Storage! = Storage.storage()

    var picArray = [UIImage]()
    var urlArray = [URL]()
    var timeStamp = [String]()
    
    var posts = [eventStruct]()
    
//        struct eventStruct {
//            let timeStamp: String!
//            let url: URL!
//        }
    
    var selectedIndex: Int = 0
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    
    func loadData(){
        let dbRef = database.reference().child(self.currentUser!.uid)
        dbRef.observe(.childAdded, with: { (snapshot) in
            let timeStamp = snapshot.key
            self.timeStamp.append(timeStamp)
            let url1 = URL.init(string: snapshot.value! as! String)
            self.urlArray.append(url1!)
            
            self.posts.insert(eventStruct(timeStamp: timeStamp, url: url1!), at: 0)
            
            self.collectionView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //
        //        let notebookName = cell.viewWithTag(1) as! UILabel
        //        notebookName.text = posts[indexPath.row].notebookName
        //
        //        let createdAt = cell.viewWithTag(2) as! UILabel
        //        createdAt.text = String(convertDateFormatter(date: (posts[indexPath.row].createdAt)!))
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
            cell.imageView.image = self.image
        print("cell = \(String(describing: cell.imageView.image?.size))")
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                for i in 0..<self.posts.count{
                    cell.imageView.sd_setImage(with: self.posts[indexPath.row].url)
                }
            }
        }
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
        self.selectedIndex = indexPath.row
        print("clicked on post at index = \(self.selectedIndex)")
        
        self.performSegue(withIdentifier: "goToPhotoView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhotoView"{
            let vc1 = segue.destination as! PhotoViewController
            let post = eventStruct(timeStamp: self.posts[selectedIndex].timeStamp, url: self.posts[selectedIndex].url)
            
            vc1.post = post
        }
    }
    
    @IBAction func onClickLogoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    
    
    @IBAction func onClickAddButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.image = selectedImage
        self.collectionView.reloadData()
        let imageData1 = selectedImage.pngData()
        uploadProfileImage(imageData: imageData1!)

        dismiss(animated: true, completion: nil)
        }
   
    func uploadProfileImage(imageData: Data)
    {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        var timeStamp = generateCurrentTimeStamp()
        
        let profileImageRef = storageReference.child(currentUser!.uid).child(timeStamp)
        self.uploadMetaData.contentType = "image/jpeg"
  
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                profileImageRef.downloadURL(completion: { (url, error) in
                    print("url = \(String(describing: url!))")
                    let strURL: String = String(describing: url!)
                    self.database.reference().child(self.currentUser!.uid).child(timeStamp).setValue(String(describing: url!))
                    self.collectionView.reloadData()
                }
            )
            }
        }
    }
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    
    
//    var ref: DatabaseReference!,
//    posts = [eventStruct]()
//    var a = Auth.auth().currentUser!.uid
    
//    struct eventStruct {
//        let notebookName: String!
//        let createdAt: String!
//    }
    
//    @IBOutlet weak var tableForData: UITableView!
//    var selectedRowCreatedAt: String = ""
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//        let notebookName = cell.viewWithTag(1) as! UILabel
//        notebookName.text = posts[indexPath.row].notebookName
//
//        let createdAt = cell.viewWithTag(2) as! UILabel
//        createdAt.text = String(convertDateFormatter(date: (posts[indexPath.row].createdAt)!))
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedRowCreatedAt = posts[indexPath.row].createdAt!
//        print("selected row = \(selectedRowCreatedAt)")
//
//    }

    

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        ref = Database.database().reference()
////        loadData()
//
//    }
    
//    func loadData() {
//        ref = Database.database().reference()
//        ref.child(Auth.auth().currentUser!.uid).queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
//            var value = snapshot.value as? NSDictionary
//
//
//                let notebookName = value!["notebookName"]
//                print("notebookName = \(notebookName!)")
//
//                let createdAt = value!["createdAt"]
//                print("createdAt = \(createdAt!)")
//
//                self.posts.insert(eventStruct(notebookName: notebookName as! String, createdAt: createdAt as! String), at: 0)
//
//                self.tableForData.reloadData()
//
//        })
//
//    }
//
//    func convertDateFormatter(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"//this your string date format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//        dateFormatter.locale = Locale(identifier: "your_loc_id")
//        let convertedDate = dateFormatter.date(from: date)
//
//        guard dateFormatter.date(from: date) != nil else {
//            assert(false, "no date from string")
//            return ""
//        }
//
//        dateFormatter.dateFormat = "yyyy MMM HH:mm EEEE"///this is what you want to convert format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//        let timeStamp = dateFormatter.string(from: convertedDate!)
//
//        return timeStamp
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
    
   
    
//    @IBAction func onClickAddButton(_ sender: Any) {
//        let alert = UIAlertController(title: "New Notebook", message: "Enter Notebook Name", preferredStyle: .alert)
//
//        alert.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Notebook name"
//        })
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//
//            if let name = alert.textFields?.first?.text {
//                self.ref = Database.database().reference()
//
//                let z1 = self.generateCurrentTimeStamp()
//            self.ref.child(Auth.auth().currentUser!.uid).child(z1).setValue(["notebookName": name, "createdAt": z1])
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
//    }
//
//    func generateCurrentTimeStamp () -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
//        return (formatter.string(from: Date()) as NSString) as String
//    }
    
}
