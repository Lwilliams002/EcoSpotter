import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIButton!
    let locationManager = CLLocationManager()
    let eventDataManager = EventDataManager.shared

    var testPins: [Event] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        eventDataManager.delegate = self
        // Request location permissions
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        centerButton.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        
        addPinsFromDataManagerToMap()
        addTestPins()
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
                category: event.category,
                image: event.images
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
            eventViewController.categoryText = annotation.category
            eventViewController.images = annotation.image
            
            self.present(eventViewController, animated: true, completion: nil)
        }
    }
    
    func addTestPins() {
            guard let currentLocation = locationManager.location?.coordinate else { return }

            let offsets = [(-0.001, 0.001), (0.001, -0.001), (0.002, 0.002)]
            for (latOffset, lonOffset) in offsets {
                let testLocation = CLLocationCoordinate2D(latitude: currentLocation.latitude + latOffset, longitude: currentLocation.longitude + lonOffset)
                let testEvent = Event(title: "Test Pin", description: "This is a test pin", images: [], location: CLLocation(latitude: testLocation.latitude, longitude: testLocation.longitude), category: "🌿 Environmental Hazard", isComplete: false)
                testPins.append(testEvent)
                addPinToMap(event: testEvent)
            }
        }

    func addPinToMap(event: Event) {
            let annotation = EventAnnotation(
                coordinate: event.location.coordinate,
                title: event.title,
                subtitle: event.description, 
                category: event.category,
                image: event.images
            )
            mapView.addAnnotation(annotation)
        }
    
}

extension MapViewController: EventDataManagerDelegate {
    func didAddEvent(_ event: Event) {
        let location = event.location
        let annotation = EventAnnotation(
            coordinate: location.coordinate,
            title: event.title,
            subtitle: event.description,
            category: event.category,
            image: event.images
        )
        mapView.addAnnotation(annotation)
    }
}



