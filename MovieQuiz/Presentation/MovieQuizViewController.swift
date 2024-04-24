import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButtonState: UIButton!
    @IBOutlet private var noButtonState: UIButton!

    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        presenter = MovieQuizPresenter(viewController: self)

        imageView.layer.cornerRadius = 20
    }

    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        yesButtonState.isEnabled = true
        noButtonState.isEnabled = true
        hideLoadingIndicator()
    }

    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let viewModel = AlertModel(ID: "FinishingAlert",
                                   title: result.title,
                                   message: message,
                                   buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(quiz: viewModel)
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let viewModel = AlertModel(ID: "ErrorAlert",
                                   title: "Ошибка", 
                                   message: message,
                                   buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(quiz: viewModel)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        
        yesButtonState.isEnabled = false
        noButtonState.isEnabled = false
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        
        yesButtonState.isEnabled = false
        noButtonState.isEnabled = false
    }
}
