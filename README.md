# iOSPhotoBrowsingApp
In this assignment you will implement an app to manage, import and view photos. You
will use Firebase to manage the photo storage. 

Part 1: User Signup and Login
Your app should implement both login and signup functionalities. You should use
Firebase to Store the user’s display name, email and password. The
requirements are similar to the authentication requirements used in the previous
in-class assignment.

Part A: User Photos View Controller (75 Points)
The User Photos view controller should retrieve the list of photos for the currently
logged in user from Firebase and display them using a UICollectionView. 
The requirements are as follows:
1. Each user should only view their photos and should not be able to view other
users’ photos.
2. Clicking the “+” navigation bar button, should enable the user to pick a photo
from the Photo Library on the device. You should implement the required
delegates to enable the use of a UIImagePickerController. You should restrict
the UIImagePickerController to only photos. Upon selecting a photo from the
Photo Library, this photo should be sent to Firebase and the UICollectionView
should be refreshed to display the new photo.
(a) App Photos View Controller (b) Photo View Controller (c) Deleting a Photo
3. Clicking a event in the UICollectionView item should navigate to the Photo
view controller. As shown in Figure 1(b).
4. All photo access should be performed in a child thread (not the main queue).

Part B: Photo View Controller (25 Points)
The Photo view controller enables the user to view the photo selected from the
User Photos view controller. In addition, it allows the user to delete the this photo
from Firebase. The requirements are as follows:
1. The photo meta data should be sent by the User Photos view controller to the
Photo view controller and the photo should be displayed, Figure 1(b).
2. Clicking the trash can navigation icon should delete the currently displayed
photo from Firebase, see Figure 1(c)
a) Display an alert dialog to ask if the user is sure about deleting the current
photo, if the user clicks OK then the photo file should be deleted from
Firebase.
b) If the photo is successfully deleted then automatically navigate back to the
User Photos view controller and refresh the collection view of photos to
reflect this change.
