import UIKit
import MapKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventLocation: MKMapView!
    @IBOutlet weak var eventImagesScrollView: UIScrollView!
    @IBOutlet weak var eventTitle: UITextView!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var categoryLabel: UITextView!
    
    var event: Event?
    var titleText: String?
    var descriptionText: String?
    var locationCoordinate: CLLocationCoordinate2D?
    var images: [UIImage]?
    var categoryText: String?
    
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard let eventToComplete = event else {
                showAlert(with: "No event to mark as complete.")
                return
            }
        completeEvent(event: eventToComplete)

        
    }
    @IBAction func eventAddButton(_ sender: UIButton) {
        guard let title = eventTitle.text, !title.isEmpty,
              let description = eventDescription.text, !description.isEmpty,
              let category = categoryLabel.text, !category.isEmpty,
              let selectedLocation = locationCoordinate,
              let images = images else {
            print("Required data is missing.")
            return
        }

        let location = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)


        let event = Event(title: title, description: description, images: images, location: location, category: category, isComplete: false)
        if EventDataManager.shared.isEventInToDoList(event) {
            // Show an alert if the event is already in the to-do list
            showAlert(with: "This event is already added to your To-Do list.")
        } else {
            // Add the event to the to-do list and update the UI
            EventDataManager.shared.addToDoEvent(event)
            sender.setTitle("Added to To-Do", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func completeEvent(event: Event) {
        EventDataManager.shared.markEventAsCompleted(event: event)
    }

    
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Category text is: \(categoryText ?? "nil")")
        eventTitle.text = titleText
        eventDescription.text = descriptionText
        categoryLabel.text = categoryText
        print("Category text is: \(categoryText ?? "nil")")
        
        AppData.shared.totalPinsViewed += 1
        
        if let coordinate = locationCoordinate {
            // Center the map on the event's location
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            eventLocation.setRegion(region, animated: true)
            
            // Add a pin for the event's location
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            eventLocation.addAnnotation(annotation)
        }
        
        // Load and display images
        if let images = images {
            for image in images {
                addImageToScrollView(image)
            }
        }
    }
    
    func addImageToScrollView(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let contentWidth = eventImagesScrollView.contentSize.width
        let xPosition = contentWidth == 0 ? 0 : contentWidth + 10 // Add some spacing between images
        imageView.frame = CGRect(x: xPosition, y: 0, width: eventImagesScrollView.frame.width, height: eventImagesScrollView.frame.height)
        
        eventImagesScrollView.addSubview(imageView)
        
        eventImagesScrollView.contentSize = CGSize(width: xPosition + eventImagesScrollView.frame.width, height: eventImagesScrollView.frame.height)
        
    }
}
