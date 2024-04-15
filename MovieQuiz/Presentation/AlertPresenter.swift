import UIKit


final class AlertPresenter: AlertPresenterDelegate {
    
    weak var delegate: UIViewController?
    
    func showAlert(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
}
