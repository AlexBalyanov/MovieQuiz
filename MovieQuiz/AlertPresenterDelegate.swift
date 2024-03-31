import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(quiz result: AlertModel)
}
