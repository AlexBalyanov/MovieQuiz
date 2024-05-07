import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageUrl)
            } catch {
                print("Fail to load image")
                self.delegate?.didFailToLoadData(with: error)
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomQuestionRaiting = Float.random(in: 7...9)
            let randomBool = Bool.random()
            let operators = [">", "<"]
            let randomOperators = operators.randomElement()
            
            let text = randomOperators == ">" ? "Рейтинг этого фильма больше, чем \(String(format: "%.1f", randomQuestionRaiting))?" : "Рейтинг этого фильма меньше, чем \(String(format: "%.1f", randomQuestionRaiting))?"
            
            let correctAnswer = randomOperators == ">" ? (rating > randomQuestionRaiting) : (rating < randomQuestionRaiting)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}
