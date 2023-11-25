import UIKit

class CustomTabBarController: UITabBarController {

    let middleButton = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        middleButton.backgroundColor = UIColor(hex: "FFC107")
        middleButton.layer.cornerRadius = 35
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        
        let plusImage = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        middleButton.setImage(plusImage, for: .normal)
        middleButton.tintColor = .white
        
        
        tabBar.addSubview(middleButton)
        tabBar.bringSubviewToFront(middleButton)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightDifference: CGFloat = 20
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.midY - heightDifference)
        
        middleButton.imageView?.contentMode = .scaleAspectFit

    }

    @objc func middleButtonAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerID")

        let navigationController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

}

extension UIColor {
   convenience init(hex: String) {
       var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
       hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

       var rgb: UInt64 = 0

       Scanner(string: hexSanitized).scanHexInt64(&rgb)

       let r = (rgb & 0xff0000) >> 16
       let g = (rgb & 0xff00) >> 8
       let b = rgb & 0xff

       self.init(
           red: CGFloat(r) / 0xff,
           green: CGFloat(g) / 0xff,
           blue: CGFloat(b) / 0xff, alpha: 1
       )
   }
}

