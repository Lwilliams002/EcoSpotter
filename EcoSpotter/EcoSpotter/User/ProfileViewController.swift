//
//  ProfileViewController.swift
//  EcoSpotter
//
//  Created by Lesly Williams on 11/16/23.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        todoTableView.dataSource = self
        todoTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.frame = CGRect(x: profileImageView.frame.origin.x, y: profileImageView.frame.origin.y, width: profileImageView.frame.size.width, height: profileImageView.frame.size.width)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Number of to-do events: \(EventDataManager.shared.getAllToDoEvents().count)")
        todoTableView.reloadData()
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventDataManager.shared.getAllToDoEvents().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoEventCell", for: indexPath)
        let events = EventDataManager.shared.getAllToDoEvents()
        let event = events[indexPath.row]
        cell.textLabel?.text = event.category

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = EventDataManager.shared.getAllToDoEvents()[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let eventViewController = storyboard.instantiateViewController(withIdentifier: "EventViewControllerID") as? EventViewController {
            eventViewController.titleText = selectedEvent.title
            eventViewController.descriptionText = selectedEvent.description
            eventViewController.locationCoordinate = selectedEvent.location.coordinate
            eventViewController.categoryText = selectedEvent.category
            eventViewController.images = selectedEvent.images

            // Present the EventViewController
            self.present(eventViewController, animated: true, completion: nil)
        }

        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
    }


    

    @objc func imageTapped() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func fetchMessageOfTheDay() {
        let urlString = "https://zenquotes.io/api/today" // Replace with the correct endpoint if needed
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching the quote: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Parse the JSON data
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                   let firstQuoteDict = jsonArray.first,
                   let quote = firstQuoteDict["q"] as? String,
                   let author = firstQuoteDict["a"] as? String {
                    let message = "\"\(quote)\"\n\n- \(author)"
                    DispatchQueue.main.async {
                        // Update the UI with the fetched quote
                        self?.messageTextView.text = message
                    }
                } else {
                    print("Invalid JSON structure")
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        
        task.resume()
    }

}
