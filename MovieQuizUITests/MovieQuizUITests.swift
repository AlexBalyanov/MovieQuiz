
import XCTest


final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testYesButton() {
        sleep(2)
        
        let firstPoster = app.images["Poster"]
        let firstPoseterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        sleep(2)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPoseterData, secondPosterData)
        XCTAssertNotEqual(firstPoseterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(2)
        
        let firstPoster = app.images["Poster"]
        let firstPoseterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        
        sleep(2)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPoseterData, secondPosterData)
        XCTAssertNotEqual(firstPoseterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testFinishingAlert() {
        sleep(3)
        
        let alert = app.alerts["FinishingAlert"]
        
        for _ in 1...10 {
            sleep(3)
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
        
    }
    
    func testAlertButton() {
        sleep(3)
        
        let alert = app.alerts["FinishingAlert"]
        let indexLabel = app.staticTexts["Index"]
        
        for _ in 1...10 {
            sleep(3)
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
