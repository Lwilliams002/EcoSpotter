import UIKit

class CustomTabBarController: UITabBarController {

    let middleButton = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the middle button
        middleButton.backgroundColor = .blue
        middleButton.layer.cornerRadius = 35
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        
        // Add it to the tab bar
        tabBar.addSubview(middleButton)
        tabBar.bringSubviewToFront(middleButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Layout the middle button to be centered and protrude upwards
        let heightDifference: CGFloat = 20 // Adjust as needed
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.midY - heightDifference)
        
        // Adjust the shape or add an image to the middle button if necessary
        // middleButton.setImage(UIImage(named: "YourImageName"), for: .normal)
    }

    @objc func middleButtonAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerID") // Replace with your actual storyboard ID

        // Present modally with animation
        let navigationController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

}
