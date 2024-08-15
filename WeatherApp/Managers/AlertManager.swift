import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func presentAlertOnViewModel(viewController: UIViewController, title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            viewController.present(alertVC, animated: true)
        }
    }
}
