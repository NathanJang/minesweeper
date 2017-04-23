//
//  ViewController.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class ViewController: UIViewController {
    
    /// An array of the cells in the game, in row-major format.
    var cells = [UIButton]()
    
    /// A button that loads a new game.
    let resetButton = UIButton(type: .system)
    
    /// A button to show help info.
    let helpButton = UIButton(type: .system)
    
    /// The superview for all game cells, a square with the same width as `self.view` and centered.
    let gameView = UIView()

    let helpLabel = { () -> UILabel in 
        let helpLabel = UILabel()
        helpLabel.text = "Tap to clear, Tap and Hold to mark"
        helpLabel.font = UIFont.systemFont(ofSize: 12)
        return helpLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.gameView.translatesAutoresizingMaskIntoConstraints = false
        self.gameView.backgroundColor = UIColor.white
        self.view.addSubview(self.gameView)
        self.gameView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        let xConstraint = NSLayoutConstraint(item: self.gameView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: self.gameView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.gameView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.gameView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
        self.view.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        self.gameView.layer.cornerRadius = self.gameView.frame.width / CGFloat(MinesweeperGame.size) / 2
        self.gameView.layer.masksToBounds = true
        
        // Initialize buttons and store in `self.buttons`.
        for i in 0..<MinesweeperGame.size * MinesweeperGame.size {
            let button = UIButton(type: .system)
            button.titleLabel!.font = UIFont.systemFont(ofSize: 18)
            button.tag = i
            self.cells.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didTapButton(_:event:)), for: .touchUpInside)
            self.gameView.addSubview(button)
            let xConstraint, yConstraint, widthConstraint, heightConstraint: NSLayoutConstraint
            if i % MinesweeperGame.size == 0 {
                // If it's column 0, align it to the left of `gameView`.
                xConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self.gameView, attribute: .left, multiplier: 1, constant: 0)
            } else {
                // Otherwise, put it next to the previous cell.
                xConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self.cells[i - 1], attribute: .right, multiplier: 1, constant: 0)
            }
            if i / MinesweeperGame.size == 0 {
                // If it's row 0, align it to the top of `gameView`.
                yConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.gameView, attribute: .top, multiplier: 1, constant: 0)
            } else {
                // Otherwise, put it next to the cell in the same column in the previous row.
                yConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.cells[i - MinesweeperGame.size], attribute: .bottom, multiplier: 1, constant: 0)
            }
            widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.gameView, attribute: .width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: self.gameView, attribute: .height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            self.gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
            gestureRecognizer.minimumPressDuration = 0.2
            button.addGestureRecognizer(gestureRecognizer)
        }
        
        if MinesweeperGame.currentGame == nil {
            initializeGame()
        } else {
            // Start the time immediately if the game was already started before.
            if MinesweeperGame.currentGame!.isStarted && !MinesweeperGame.currentGame!.isFinished {
                MinesweeperGame.currentGame!.startDate = Date()
            }
            configureCells()
        }
        
        self.resetButton.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController!.toolbar.addSubview(self.resetButton)
        self.navigationController!.toolbar.addConstraints([NSLayoutConstraint(item: self.resetButton, attribute: .centerY, relatedBy: .equal, toItem: self.navigationController!.toolbar, attribute: .centerY, multiplier: 1, constant: 0), NSLayoutConstraint(item: self.resetButton, attribute: .centerX, relatedBy: .equal, toItem: self.navigationController!.toolbar, attribute: .centerX, multiplier: 1, constant: 0)])
        self.resetButton.addTarget(self, action: #selector(initializeGame), for: .touchUpInside)
        self.resetButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        
        self.helpButton.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController!.toolbar.addSubview(self.helpButton)
        self.navigationController!.toolbar.addConstraints([NSLayoutConstraint(item: self.helpButton, attribute: .centerY, relatedBy: .equal, toItem: self.navigationController!.toolbar, attribute: .centerY, multiplier: 1, constant: 0), NSLayoutConstraint(item: self.helpButton, attribute: .right, relatedBy: .equal, toItem: self.navigationController!.toolbar, attribute: .right, multiplier: 1, constant: 0)])
        self.helpButton.addTarget(self, action: #selector(didTapHelpButton), for: .touchUpInside)
        self.helpButton.setTitle("?", for: UIControlState())
        self.helpButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)

        self.helpLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(helpLabel)
        self.view.addConstraints([NSLayoutConstraint(item: helpLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -navigationController!.toolbar.frame.height - 10), NSLayoutConstraint(item: helpLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
    }
    
    /// Loads a new game.
    func initializeGame() {
        print("Renewing game")
        MinesweeperGame.currentGame = MinesweeperGame()
        self.configureCells()
    }
    
    /// Reset cell titles based on the current game.
    func configureCells() {
        for i in 0..<MinesweeperGame.size {
            for j in 0..<MinesweeperGame.size {
                if MinesweeperGame.currentGame!.revealedCells[i][j] {
                    // Mark it not revealed so `revealCell(_:)` can reveal it correctly.
                    MinesweeperGame.currentGame!.revealedCells[i][j] = false
                    revealCell(self.cells[MinesweeperGame.size * i + j])
                } else if MinesweeperGame.currentGame!.isFinished && MinesweeperGame.currentGame!.hasMine(row: i, column: j)! || MinesweeperGame.currentGame!.markedCells[i][j] {
                    // Mark it not marked so `markCell(_:)` can reveal it correctly.
                    MinesweeperGame.currentGame!.markedCells[i][j] = false
                    markCell(self.cells[MinesweeperGame.size * i + j])
                } else {
                    // Non-revealed buttons show "-".
                    DispatchQueue.main.async {
                        let cell = self.cells[MinesweeperGame.size * i + j]
                        cell.setTitle("-", for: UIControlState())
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.resetButton.setTitle(MinesweeperGame.currentGame!.isFinished ? "New Game" : "Reset", for: UIControlState())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapButton(_ sender: UIButton, event: UIControlEvents) {
        // If the game is already finished, show the alert and don't do anything.
        if MinesweeperGame.currentGame!.isFinished {
            self.showAlert(won: MinesweeperGame.currentGame!.won, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
            return
        }
        // Start the time if it isn't started on a button tap.
        if !MinesweeperGame.currentGame!.isStarted {
            MinesweeperGame.currentGame!.isStarted = true
            MinesweeperGame.currentGame!.startDate = Date()
        }
        self.revealNeighboringCells(sender)
    }

    /// Recursively reveal neighboring cells.
    /// If a cell has 0 mines nearby, recursively reveal the surrounding cells.
    func revealNeighboringCells(_ button: UIButton) {
        let i = button.tag / MinesweeperGame.size
        let j = button.tag % MinesweeperGame.size
        // If the cell is already revealed or marked, don't do anything.
        if !MinesweeperGame.currentGame!.isFinished && !MinesweeperGame.currentGame!.revealedCells[i][j] && !MinesweeperGame.currentGame!.markedCells[i][j] {
            self.revealCell(button)
            // If the revealed cell has a mine, lose.
            if MinesweeperGame.currentGame!.hasMine(row: i, column: j)! {
                MinesweeperGame.currentGame!.endDate = Date()
                DispatchQueue.main.async {
                    self.showAlert(won: false, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
                }
                // Reveal all other non-mine cells.
                // Only this mined cell is revealed so it is highlighted which mined cell the user tapped that caused the loss.
                for i in 0..<MinesweeperGame.size {
                    for j in 0..<MinesweeperGame.size {
                        if !MinesweeperGame.currentGame!.hasMine(row: i, column: j)! {
                            self.revealCell(self.cells[i * MinesweeperGame.size + j])
                        } else {
                            if !MinesweeperGame.currentGame!.markedCells[i][j] {
                                self.markCell(self.cells[i * MinesweeperGame.size + j])
                            }
                        }
                    }
                }
                MinesweeperGame.currentGame!.isFinished = true
                DispatchQueue.main.async {
                    self.resetButton.setTitle("New Game", for: UIControlState())
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            } else {
                // If a cell has 0 mines nearby, recursively reveal the surrounding cells.
                if MinesweeperGame.currentGame!.numberOfMinesNear(row: i, column: j)! == 0 {
                    if i > 0 {
                        // north
                        self.revealNeighboringCells(self.cells[button.tag - MinesweeperGame.size])
                    }
                    if j > 0 {
                        // west
                        self.revealNeighboringCells(self.cells[button.tag - 1])
                    }
                    if i < MinesweeperGame.size - 1 {
                        // south
                        self.revealNeighboringCells(self.cells[button.tag + MinesweeperGame.size])
                    }
                    if j < MinesweeperGame.size - 1 {
                        // east
                        self.revealNeighboringCells(self.cells[button.tag + 1])
                    }
                    if i > 0 && j > 0 {
                        // northwest
                        self.revealNeighboringCells(self.cells[button.tag - MinesweeperGame.size - 1])
                    }
                    if i < MinesweeperGame.size - 1 && j > 0 {
                        // southwest
                        self.revealNeighboringCells(self.cells[button.tag + MinesweeperGame.size - 1])
                    }
                    if i > 0 && j < MinesweeperGame.size - 1 {
                        // northeast
                        self.revealNeighboringCells(self.cells[button.tag - MinesweeperGame.size + 1])
                    }
                    if i < MinesweeperGame.size - 1 && j < MinesweeperGame.size - 1 {
                        // southeast
                        self.revealNeighboringCells(self.cells[button.tag + MinesweeperGame.size + 1])
                    }
                }
            }
            // If all non-mine cells are revealed, win.
            if MinesweeperGame.currentGame!.numberOfRemainingCells == MinesweeperGame.numberOfMines {
                MinesweeperGame.currentGame!.won = true
                MinesweeperGame.currentGame!.endDate = Date()
                self.showAlert(won: true, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
                DispatchQueue.main.async {
                    self.resetButton.setTitle("New Game", for: UIControlState())
                }
                for i in 0..<MinesweeperGame.size {
                    for j in 0..<MinesweeperGame.size {
                        if MinesweeperGame.currentGame!.hasMine(row: i, column: j)! && !MinesweeperGame.currentGame!.markedCells[i][j] {
                            self.markCell(self.cells[i * MinesweeperGame.size + j])
                        }
                    }
                }
                MinesweeperGame.currentGame!.isFinished = true
            }
        }
    }
    
    func didTapHelpButton() {
        DispatchQueue.main.async {
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            let title = "Minsweeper \(version)\nby Jonathan Chan"
            let message = "The goal is to clear the minefield. Tap on all the cells that don't contain a mine. Tap and hold to mark mines. The numbers represent how many of the cells around a cell contain a mine. If you tap on a mine, you lose!"
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
                alertView.alertViewStyle = .default
                alertView.show()
            }
        }
    }
    
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let button = sender.view as! UIButton
            let i = button.tag / MinesweeperGame.size
            let j = button.tag % MinesweeperGame.size
            if !MinesweeperGame.currentGame!.isFinished && !MinesweeperGame.currentGame!.revealedCells[i][j] {
                self.markCell(button, withHapticFeedback: true)
            }
        } else if sender.state == .possible, #available(iOS 10.0, *) {
            UIFeedbackGenerator().prepare()
        }
    }
    
    func markCell(_ button: UIButton, withHapticFeedback shouldProvideHapticFeedback: Bool = false) {
        DispatchQueue.main.async {
            let i = button.tag / MinesweeperGame.size
            let j = button.tag % MinesweeperGame.size
            let isMarked = MinesweeperGame.currentGame!.markedCells[i][j]
            let isRevealed = MinesweeperGame.currentGame!.revealedCells[i][j]
            if !MinesweeperGame.currentGame!.revealedCells[i][j] {
                button.setTitle(isMarked ? "-" : "X", for: UIControlState())
                MinesweeperGame.currentGame!.markedCells[i][j] = !MinesweeperGame.currentGame!.markedCells[i][j]
            }

            if shouldProvideHapticFeedback && !isRevealed {
                if #available(iOS 10.0, *) {
                    UIImpactFeedbackGenerator().impactOccurred()
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    /// Reveal a single cell.
    func revealCell(_ button: UIButton) {
        let i = button.tag / MinesweeperGame.size
        let j = button.tag % MinesweeperGame.size
        if !MinesweeperGame.currentGame!.revealedCells[i][j] {
            if MinesweeperGame.currentGame!.hasMine(row: i, column: j)! {
                DispatchQueue.main.async {
                    button.setTitle("!!", for: UIControlState())
                }
            } else {
                DispatchQueue.main.async {
                    let numberOfMinesNearby = MinesweeperGame.currentGame!.numberOfMinesNear(row: i, column: j)!
                    button.setTitle(numberOfMinesNearby > 0 ? "\(numberOfMinesNearby)" : "", for: UIControlState())
                }
            }
            MinesweeperGame.currentGame!.revealedCells[i][j] = true
            MinesweeperGame.currentGame!.numberOfRemainingCells -= 1
        }
    }
    
    func showAlert(won: Bool, formattedDuration: String) {
        DispatchQueue.main.async {
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: won ? "You've won!" : "You've lost!", message: formattedDuration, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "New Game", style: .default) { _ in
                    self.initializeGame()
                })
                alert.addAction(UIAlertAction(title: "Share", style: .default) { _ in
                    self.showActivityController(won: won, formattedDuration: formattedDuration)
                })
                alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alertView = UIAlertView(title: won ? "You've won!" : "You've lost!", message: formattedDuration, delegate: self, cancelButtonTitle: "Done", otherButtonTitles: "New Game", "Share")
                alertView.alertViewStyle = .default
                alertView.show()
            }
        }
    }
    
    func showActivityController(won: Bool, formattedDuration: String) {
        DispatchQueue.main.async {
            let message = "I just \(won ? "won" : "lost") a game of Minsweeper in \(formattedDuration)!"
            let url = URL(string: "https://appsto.re/us/7dqrjb.i")!
            let image = self.imageOfGameView()
            let activityViewController = UIActivityViewController(activityItems: [message, url, image], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.addToReadingList]
            // Show the alert again once user is done sharing.
            if #available(iOS 8.0, *) {
                activityViewController.completionWithItemsHandler = {(_, _, _, _) -> Void in
                    self.showAlert(won: won, formattedDuration: formattedDuration)
                }
            } else {
                activityViewController.completionHandler = {(_, _) -> Void in
                    self.showAlert(won: won, formattedDuration: formattedDuration)
                }
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func imageOfGameView() -> UIImage {
        let imageSize = CGSize(width: self.gameView.frame.width, height: self.gameView.frame.height + 45)
        let imageRect = CGRect(origin: .zero, size: imageSize)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.white.setFill()
        UIRectFill(imageRect)
        self.gameView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let textAttributes: [String: Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15),
            NSParagraphStyleAttributeName: { let style = NSMutableParagraphStyle(); style.alignment = .center; return style }(),
        ]
        let text = NSString(string: "Minsweeper game\n\(MinesweeperGame.currentGame!.won ? "won" : "lost") in \(MinesweeperGame.currentGame!.formattedDuration())")
        text.draw(in: CGRect(origin: CGPoint(x: 0, y: self.gameView.frame.height), size: imageSize), withAttributes: textAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}

// For backwards compatibility with iOS 7
extension ViewController: UIAlertViewDelegate {

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        // If "New Game" is clicked
        if buttonIndex == 1 {
            self.initializeGame()
        } else if buttonIndex == 2 {
            self.showActivityController(won: MinesweeperGame.currentGame!.won, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
        }
    }
    
}
