import UIKit

final class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            if let topViewController = self.topMostViewController() {
                topViewController.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var topController = keyWindow.rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
}
