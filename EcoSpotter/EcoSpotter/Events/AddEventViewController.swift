//
//  ProfileViewController.swift
//  EcoSpotter
//
//  Created by Lesly Williams on 11/7/23.
//

import UIKit
import PhotosUI

class AddEventViewController: UIViewController, UITextViewDelegate, PHPickerViewControllerDelegate {
    var selectedLocation: CLLocationCoordinate2D?

    @IBOutlet weak var placeholderTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var submitButtonView: UIButton!
    @IBAction func submitButton(_ sender: UIButton) {
        guard let _ = titleTextView.text,
              let _ = placeholderTextView.text else {
            return
        }
        
        if let selectedLocation = selectedLocation {
            let location = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            
            guard let title = titleTextView.text,
                  let description = placeholderTextView.text else {
                return
            }
            
            let event = Event(title: title, description: description, images: selectedImages, location: location)
            
            EventDataManager.shared.addEvent(event)
        }

    }
    
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // 0 means no limit, allowing multiple image selection
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var pullDownButton: UIButton!
    
    
    var selectedImages: [UIImage] = []
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Assume you have a button action that presents the DroppinViewController
    @IBAction func openDroppinViewController(_ sender: UIButton) {
      
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        placeholderTextView.layer.borderColor = UIColor.black.cgColor
        placeholderTextView.layer.borderWidth = 1.0 // Adjust the border width to your preference
        placeholderTextView.layer.cornerRadius = 20
        placeholderTextView.delegate = self
        
        titleTextView.layer.borderColor = UIColor.black.cgColor
        titleTextView.layer.borderWidth = 1.0 // Adjust the border width to your preference
        titleTextView.layer.cornerRadius = 20
        titleTextView.delegate = self
        
        submitButtonView.layer.cornerRadius = 10 // Adjust the corner radius to your preference
        submitButtonView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let menuItems = [
            UIAction(title: "🌿 Environmental Hazard") { _ in
                // Handle Environmental Conservation selection
            },
            UIAction(title: "🌍 Climate Change") { _ in
                // Handle Climate Change selection
            },
            UIAction(title: "🌊 Water Pollution") { _ in
                // Handle Water Pollution selection
            },
            UIAction(title: "🌳 Deforestation") { _ in
                // Handle Deforestation selection
            },
            UIAction(title: "🌏 Biodiversity") { _ in
                // Handle Biodiversity selection
            },
            UIAction(title: "🗑️ Waste Reduction") { _ in
                // Handle Waste Reduction selection
            },
            UIAction(title: "🚯 Litter Cleanup") { _ in
                // Handle Litter Cleanup selection
            },
            UIAction(title: "🌡️ Renewable Energy") { _ in
                // Handle Renewable Energy selection
            },
            UIAction(title: "🐦 Wildlife Protection") { _ in
                // Handle Wildlife Protection selection
            },
            UIAction(title: "♻️ Recycling") { _ in
                // Handle Recycling selection
            }
        ]


            let menu = UIMenu(title: "", children: menuItems)

            // Set the menu for the pullDownButton
            pullDownButton.menu = menu
    }
    
    deinit {
        // Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func handleTap() {
        placeholderTextView.resignFirstResponder()
        titleTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            // Move the view up by the height of the keyboard
            view.frame.origin.y = -keyboardRect.height
        } else {
            // Reset the view position when the keyboard is dismissed
            view.frame.origin.y = 0
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == placeholderTextView && textView.text == "Description" { // Replace "Placeholder" with the actual placeholder text
            textView.text = ""
            textView.textColor = .black // Set this to whatever color you want the text to be when editing
        }
        else{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    // Optional: Implement this delegate method to reset the placeholder text when the UITextView is empty and the user finishes editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == placeholderTextView && textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .lightGray
        }
        else{
            textView.text = "Title"
            textView.textColor = .lightGray
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                        if let image = object as? UIImage {
                            DispatchQueue.main.async {
                                self.selectedImages.append(image)

                                // Add the selected image to the scroll view
                                self.addImageToScrollView(image)
                            }
                        }
                    }
                }
            }
        }
    
    func handleSelectedLocation(_ selectedLocation: CLLocationCoordinate2D) {
        // Handle the selected location here
        self.selectedLocation = selectedLocation
           
           // Handle the selected location here
        print("Selected Location: \(selectedLocation)")
        // You can store it in a property or update your UI as needed
    }
    
    func addImageToScrollView(_ image: UIImage) {
            // Create an image view for the new image
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit

            // Calculate the position for the new image view
            let contentWidth = scrollView.contentSize.width
            let xPosition = contentWidth == 0 ? 0 : contentWidth + 10 // Add some spacing between images
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)

            // Add the image view to the scroll view
            scrollView.addSubview(imageView)

            // Update the content size of the scroll view to include the new image
            scrollView.contentSize = CGSize(width: xPosition + scrollView.frame.width, height: scrollView.frame.height)

            // Optionally, you can adjust the zoom scale or other properties of the scroll view
        }
}
