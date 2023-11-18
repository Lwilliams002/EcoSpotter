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
        guard let title = titleTextView.text, !title.isEmpty,
              let description = placeholderTextView.text, !description.isEmpty,
              let selectedLocation = selectedLocation,
              let category = selectedCategory else {
            // Handle the case where required data is missing
            print("Required data is missing.")
            return
        }
        
        print("Selected Location (in submitButton): \(selectedLocation)")
        
        let location = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
        
        print("Location is ", location)
        
        let event = Event(title: title, description: description, images: selectedImages, location: location, category: category )
        
        EventDataManager.shared.addEvent(event)
        print("Event added:", event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true, completion: nil)
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
    var selectedCategory: String?

    
    var selectedImages: [UIImage] = []
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Assume you have a button action that presents the DroppinViewController
    @IBAction func openDroppinViewController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let droppinViewController = storyboard.instantiateViewController(withIdentifier: "DropPinViewControllerID") as! DropPinViewController

        // Set the closure to capture the selected location
        droppinViewController.onLocationSelect = { [weak self] selectedLocation in
            // Handle the selected location here
            self?.handleSelectedLocation(selectedLocation)
        }

        // Present the DropPinViewController
        navigationController?.pushViewController(droppinViewController, animated: true)
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
        
        submitButtonView.layer.cornerRadius = 20 // Adjust the corner radius to your preference
        submitButtonView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let menuItems = [
            UIAction(title: "🌿 Environmental Hazard") { [weak self] _ in
                self?.selectedCategory = "🌿 Environmental Hazard"
            },
            UIAction(title: "🌍 Climate Change") { [weak self] _ in
                self?.selectedCategory = "🌍 Climate Change"
            },
            UIAction(title: "🌊 Water Pollution") { [weak self] _ in
                self?.selectedCategory = "🌊 Water Pollution"
            },
            UIAction(title: "🌳 Deforestation") { [weak self] _ in
                self?.selectedCategory = "🌳 Deforestation"
            },
            UIAction(title: "🌏 Biodiversity") { [weak self] _ in
                self?.selectedCategory = "🌏 Biodiversity"
            },
            UIAction(title: "🗑️ Waste Reduction") { [weak self] _ in
                self?.selectedCategory = "🗑️ Waste Reduction"
            },
            UIAction(title: "🚯 Litter Cleanup") { [weak self] _ in
                self?.selectedCategory = "🚯 Litter Cleanup"
            },
            UIAction(title: "🌡️ Renewable Energy") { [weak self] _ in
                self?.selectedCategory = "🌡️ Renewable Energy"
            },
            UIAction(title: "🐦 Wildlife Protection") { [weak self] _ in
                self?.selectedCategory = "🐦 Wildlife Protection"
            },
            UIAction(title: "♻️ Recycling") { [weak self] _ in
                self?.selectedCategory = "♻️ Recycling"
            }
        ]


            let menu = UIMenu(title: "", children: menuItems)
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
            textView.textColor = .white // Set this to whatever color you want the text to be when editing
        }
        else{
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == placeholderTextView {
            if textView.text.isEmpty {
                textView.text = "Description"
                textView.textColor = .lightGray
            } else if textView.text == "Title" {
                textView.text = "Description"
                textView.textColor = .white
            }
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
        print("Selected Location: \(selectedLocation)")

        self.selectedLocation = selectedLocation
           
           // Handle the selected location here
        print("Selected Location after setting: \(selectedLocation)")
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
