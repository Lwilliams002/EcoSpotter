import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    var imageViews: [UIImageView] = []

    override var annotation: MKAnnotation? {
        didSet {
            if let eventAnnotation = annotation as? EventAnnotation, let images = eventAnnotation.image {
                for (index, image) in images.enumerated() {
                    if index < imageViews.count {
                        imageViews[index].image = image
                    } else {
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = .scaleAspectFit
                        imageViews.append(imageView)
                    }
                }
                    for index in images.count..<imageViews.count {
                    imageViews[index].removeFromSuperview()
                }
                
                let stackView = UIStackView(arrangedSubviews: imageViews)
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                
                detailCalloutAccessoryView = stackView
            }
        }
    }
}
