import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIButton!
    let locationManager = CLLocationManager()
    let eventDataManager = EventDataManager.shared
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        eventDataManager.delegate = self
        // Request location permissions
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // You can customize the map view's properties here
        
        mapView.showsUserLocation = true // Show the user's location on the map
        mapView.userTrackingMode = .follow
        
        centerButton.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        
        addPinsFromDataManagerToMap()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.requestWhenInUseAuthorization()
        
        if let location = locations.first {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(Error.self)" )
    }
    
    @objc func centerMapOnUserLocation() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func addPinsFromDataManagerToMap() {
        // Access events through the getEvents method
        let events = EventDataManager.shared.getAllEvents()

        for event in events {
            let location = event.location
            let annotation = EventAnnotation(
                coordinate: location.coordinate,
                title: event.title,
                subtitle: event.description,
                image: event.images // Pass the images parameter
            )
            mapView.addAnnotation(annotation)
        }
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? EventAnnotation {
            // Create an instance of EventViewController
            let eventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventViewControllerID") as! EventViewController
            
            // Set the properties with the selected pin's data
            eventViewController.titleText = annotation.title
            eventViewController.descriptionText = annotation.subtitle
            eventViewController.locationCoordinate = annotation.coordinate
            eventViewController.images = annotation.image
            
            // Present the EventViewController
            self.present(eventViewController, animated: true, completion: nil)
        }
    }
}

extension MapViewController: EventDataManagerDelegate {
    func didAddEvent(_ event: Event) {
        // Update the map with the new event
        let location = event.location
        let annotation = EventAnnotation(
            coordinate: location.coordinate,
            title: event.title,
            subtitle: event.description,
            image: event.images
        )
        mapView.addAnnotation(annotation)
    }
}

