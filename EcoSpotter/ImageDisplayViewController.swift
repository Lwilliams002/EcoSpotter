import UIKit

class ImageDisplayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = image {
            imageView.image = image
        }
    }
}
