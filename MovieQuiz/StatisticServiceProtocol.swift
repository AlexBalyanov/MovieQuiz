import UIKit

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get }
    var totalCorrectQuestions: Int { get set }
    func store(correct count: Int, total amount: Int)
}
