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
            print("Required data is missing.")
            return
        }
        
        print("Selected Location (in submitButton): \(selectedLocation)")
        
        let location = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
        
        print("Location is ", location)
        
        let event = Event(title: title, description: description, images: selectedImages, location: location, category: category, isComplete: false )
        
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
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var pullDownButton: UIButton!
    var selectedCategory: String?

    
    var selectedImages: [UIImage] = []
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func openDroppinViewController(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let droppinViewController = storyboard.instantiateViewController(withIdentifier: "DropPinViewControllerID") as! DropPinViewController

        droppinViewController.onLocationSelect = { [weak self] selectedLocation in
            self?.handleSelectedLocation(selectedLocation)
        }

        navigationController?.pushViewController(droppinViewController, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        placeholderTextView.layer.borderColor = UIColor.black.cgColor
        placeholderTextView.layer.borderWidth = 1.0
        placeholderTextView.layer.cornerRadius = 20
        placeholderTextView.delegate = self
        
        titleTextView.layer.borderColor = UIColor.black.cgColor
        titleTextView.layer.borderWidth = 1.0
        titleTextView.layer.cornerRadius = 20
        titleTextView.delegate = self
        
        submitButtonView.layer.cornerRadius = 20
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
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == placeholderTextView && textView.text == "Description" {
            textView.text = ""
        }
        else{
            textView.text = ""
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

                                self.addImageToScrollView(image)
                            }
                        }
                    }
                }
            }
        }
    
    func handleSelectedLocation(_ selectedLocation: CLLocationCoordinate2D) {
        print("Selected Location: \(selectedLocation)")

        self.selectedLocation = selectedLocation
           
        print("Selected Location after setting: \(selectedLocation)")
    }
    
    func addImageToScrollView(_ image: UIImage) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit

            let contentWidth = scrollView.contentSize.width
            let xPosition = contentWidth == 0 ? 0 : contentWidth + 10 
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)

            scrollView.addSubview(imageView)

            scrollView.contentSize = CGSize(width: xPosition + scrollView.frame.width, height: scrollView.frame.height)

        }
}
