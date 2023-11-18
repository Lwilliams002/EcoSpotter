import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: [UIImage]?
    var event: Event?
    var category: String?

    init(
        coordinate: CLLocationCoordinate2D,
        title: String?,
        subtitle: String?,
        category: String?,
        image: [UIImage]?
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.category = category
        super.init()
    }
}
