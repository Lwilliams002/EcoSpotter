import UIKit
import MapKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventLocation: MKMapView!
    @IBOutlet weak var eventImagesScrollView: UIScrollView!
    @IBOutlet weak var eventTitle: UITextView!
    @IBOutlet weak var eventDescription: UITextView!
    
    // Properties to store event details
    var titleText: String?
    var descriptionText: String?
    var locationCoordinate: CLLocationCoordinate2D?
    var images: [UIImage]? // Use UIImage objects directly
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update the UI with event details
        eventTitle.text = titleText
        eventDescription.text = descriptionText
        
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
        // Create an image view for the new image
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        // Calculate the position for the new image view
        let contentWidth = eventImagesScrollView.contentSize.width
        let xPosition = contentWidth == 0 ? 0 : contentWidth + 10 // Add some spacing between images
        imageView.frame = CGRect(x: xPosition, y: 0, width: eventImagesScrollView.frame.width, height: eventImagesScrollView.frame.height)
        
        // Add the image view to the scroll view
        eventImagesScrollView.addSubview(imageView)
        
        // Update the content size of the scroll view to include the new image
        eventImagesScrollView.contentSize = CGSize(width: xPosition + eventImagesScrollView.frame.width, height: eventImagesScrollView.frame.height)
        
        // Optionally, you can adjust the zoom scale or other properties of the scroll view
    }
}
