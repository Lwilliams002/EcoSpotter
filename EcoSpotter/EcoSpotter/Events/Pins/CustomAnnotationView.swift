import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    var imageViews: [UIImageView] = []

    override var annotation: MKAnnotation? {
        didSet {
            if let eventAnnotation = annotation as? EventAnnotation, let images = eventAnnotation.image {
                for (index, image) in images.enumerated() {
                    if index < imageViews.count {
                        // If the image view already exists, update it
                        imageViews[index].image = image
                    } else {
                        // Create a new image view for the image
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = .scaleAspectFit
                        imageViews.append(imageView)
                    }
                }
                
                // Remove any extra image views
                for index in images.count..<imageViews.count {
                    imageViews[index].removeFromSuperview()
                }
                
                // Create a stack view to hold the image views horizontally
                let stackView = UIStackView(arrangedSubviews: imageViews)
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                
                // Set the callout accessory view to the stack view
                detailCalloutAccessoryView = stackView
            }
        }
    }
}
