import UIKit
import MapKit

class DropPinViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerButton: UIButton!
    
    // Closure to capture the selected location
    var onLocationSelect: ((CLLocationCoordinate2D) -> Void)?
    let locationManager = CLLocationManager()
    var selectedAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map view's delegate to self
        mapView.delegate = self
            
            // Request location permissions
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // You can customize the map view's properties here
        mapView.showsUserLocation = true // Show the user's location on the map
        mapView.userTrackingMode = .follow
        
        // Add a long press gesture recognizer to allow users to drop a pin
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
        
        centerButton.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.requestWhenInUseAuthorization()
        
        if let location = locations.first {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
            
            // You can stop location updates if you only want the initial location
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(Error.self)" )
    }
    


    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            print("Selected Location: latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")

            if let existingAnnotation = selectedAnnotation {
                            mapView.removeAnnotation(existingAnnotation)
                        }

                        // Create a new annotation at the selected location
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        mapView.addAnnotation(annotation)

                        // Store the selected annotation
                        selectedAnnotation = annotation

                        // Call the closure to capture the selected location
                        onLocationSelect?(coordinate)
        }
    }

    // MKMapViewDelegate method to customize the marker's appearance
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            if let eventAnnotation = annotation as? EventAnnotation {
                let identifier = "EventAnnotationView"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView

                if annotationView == nil {
                    annotationView = CustomAnnotationView(annotation: eventAnnotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                } else {
                    annotationView?.annotation = eventAnnotation
                }

                return annotationView
            }

            return nil
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let eventAnnotation = view.annotation as? EventAnnotation {
                // Create an instance of EventViewController
                let eventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventViewControllerID") as! EventViewController

                // Set the properties with the selected event data
                eventViewController.titleText = eventAnnotation.title
                eventViewController.descriptionText = eventAnnotation.subtitle
                eventViewController.locationCoordinate = eventAnnotation.coordinate

                // Present the EventViewController
                self.present(eventViewController, animated: true, completion: nil)
            }
        }
    
    @objc func centerMapOnUserLocation() {
            mapView.setUserTrackingMode(.follow, animated: true)
        }

}
