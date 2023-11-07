import UIKit
import MapKit

class DropPinViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    // Closure to capture the selected location
    var onLocationSelect: ((CLLocationCoordinate2D) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map view's delegate to self
        mapView.delegate = self

        // You can customize the map view's properties here, like setting the region, etc.
        let initialLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example coordinates
        let region = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        
        // Add a long press gesture recognizer to allow users to drop a pin
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            // Call the closure to capture the selected location
            onLocationSelect?(coordinate)
            
            // Add a marker to the map at the selected location
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }

    // MKMapViewDelegate method to customize the marker's appearance
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "MarkerAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .red
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}
