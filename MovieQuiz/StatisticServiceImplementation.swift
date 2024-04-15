import UIKit

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    var totalCorrectQuestions: Int {
        get {
            userDefaults.integer(forKey: Keys.correctTotal.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correctTotal.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalGames = gamesCount * 10
        let totalCorrectQuestions = totalCorrectQuestions
        
        return Double(totalCorrectQuestions) / Double(totalGames) * 100
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print ("Невозможно сохранить результат.")
                return
            }
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, correctTotal
    }
    
    
    func store(correct count: Int, total amount: Int) {
        userDefaults.set(count, forKey: Keys.correct.rawValue)
        userDefaults.set(amount, forKey: Keys.total.rawValue)
        
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        if newRecord.isBetterThan(bestGame) {
            bestGame = newRecord
        }
    }
}
