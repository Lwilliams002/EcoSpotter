import UIKit
import CoreLocation

struct Event {
    let title: String
    let description: String
    let images: [UIImage]
    let location: CLLocation
    let category: String
    var isComplete: Bool
}
