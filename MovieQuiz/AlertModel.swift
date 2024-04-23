import UIKit

struct AlertModel {
    let ID: String
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
