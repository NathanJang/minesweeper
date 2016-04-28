//
//  ViewController.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// An array of the cells in the game, in row-major format.
    var cells = [UIButton]()
    
    /// A button that loads a new game.
    let resetButton = UIButton(type: .System)
    
    /// The superview for all game cells, a square with the same width as `self.view` and centered.
    let gameView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.gameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.gameView)
        self.gameView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        let xConstraint = NSLayoutConstraint(item: self.gameView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: self.gameView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.gameView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.gameView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        self.view.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        
        // Initialize buttons and store in `self.buttons`.
        for i in 0..<MinesweeperGame.size * MinesweeperGame.size {
            let button = UIButton(type: .System)
            button.tag = i
            self.cells.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didTapButton(_:event:)), forControlEvents: .TouchUpInside)
            self.gameView.addSubview(button)
            let xConstraint, yConstraint, widthConstraint, heightConstraint: NSLayoutConstraint
            if i % MinesweeperGame.size == 0 {
                // If it's column 0, align it to the left of `gameView`.
                xConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self.gameView, attribute: .Left, multiplier: 1, constant: 0)
            } else {
                // Otherwise, put it next to the previous cell.
                xConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self.cells[i - 1], attribute: .Right, multiplier: 1, constant: 0)
            }
            if i / MinesweeperGame.size == 0 {
                // If it's row 0, align it to the top of `gameView`.
                yConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self.gameView, attribute: .Top, multiplier: 1, constant: 0)
            } else {
                // Otherwise, put it next to the cell in the same column in the previous row.
                yConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self.cells[i - MinesweeperGame.size], attribute: .Bottom, multiplier: 1, constant: 0)
            }
            widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: self.gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            heightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: self.gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            self.gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        }
        
        if MinesweeperGame.currentGame == nil {
            initializeGame()
        } else {
            // Start the time immediately if the game was already started before.
            if MinesweeperGame.currentGame!.isStarted {
                MinesweeperGame.currentGame!.startDate = NSDate()
            }
            configureCells()
        }
        
        self.resetButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.resetButton)
        self.view.addConstraints([NSLayoutConstraint(item: self.resetButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0), NSLayoutConstraint(item: self.resetButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)])
        self.resetButton.addTarget(self, action: #selector(initializeGame), forControlEvents: .TouchUpInside)
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
                } else {
                    // Non-revealed buttons show "-".
                    self.cells[MinesweeperGame.size * i + j].setTitle("-", forState: .Normal)
                }
            }
        }
        self.resetButton.setTitle(MinesweeperGame.currentGame!.isFinished ? "New Game" : "Reset", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapButton(sender: UIButton, event: UIControlEvents) {
        // Start the time if it isn't started on a button tap.
        if !MinesweeperGame.currentGame!.isStarted {
            MinesweeperGame.currentGame!.isStarted = true
            MinesweeperGame.currentGame!.startDate = NSDate()
        }
        self.revealNeighboringCells(sender)
    }

    /// Recursively reveal neighboring cells.
    /// If a cell has 0 mines nearby, recursively reveal the surrounding cells.
    func revealNeighboringCells(button: UIButton) {
        let i = button.tag / MinesweeperGame.size
        let j = button.tag % MinesweeperGame.size
        // If the cell is already revealed, don't do anything.
        if !MinesweeperGame.currentGame!.isFinished && !MinesweeperGame.currentGame!.revealedCells[i][j] {
            self.revealCell(button)
            // If the revealed cell has a mine, lose.
            if MinesweeperGame.currentGame!.hasMine(row: i, column: j)! {
                MinesweeperGame.currentGame!.isFinished = true
                MinesweeperGame.currentGame!.endDate = NSDate()
                self.showAlert(won: false, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
                // Reveal all other non-mine cells.
                // Only this mined cell is revealed so it is highlighted which mined cell the user tapped that caused the loss.
                for i in 0..<MinesweeperGame.size {
                    for j in 0..<MinesweeperGame.size {
                        if !MinesweeperGame.currentGame!.hasMine(row: i, column: j)! {
                            self.revealCell(self.cells[i * MinesweeperGame.size + j])
                        }
                    }
                }
                self.resetButton.setTitle("New Game", forState: .Normal)
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
                MinesweeperGame.currentGame!.isFinished = true
                MinesweeperGame.currentGame!.won = true
                MinesweeperGame.currentGame!.endDate = NSDate()
                self.showAlert(won: true, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
                self.resetButton.setTitle("New Game", forState: .Normal)
            }
        }
    }
    
    /// Reveal a single cell.
    func revealCell(button: UIButton) {
        let i = button.tag / MinesweeperGame.size
        let j = button.tag % MinesweeperGame.size
        if !MinesweeperGame.currentGame!.revealedCells[i][j] {
            if MinesweeperGame.currentGame!.hasMine(row: i, column: j)! {
                button.setTitle("X", forState: .Normal)
            } else {
                let numberOfMinesNearby = MinesweeperGame.currentGame!.numberOfMinesNear(row: i, column: j)!
                button.setTitle(numberOfMinesNearby > 0 ? "\(numberOfMinesNearby)" : "", forState: .Normal)
            }
            MinesweeperGame.currentGame!.revealedCells[i][j] = true
            MinesweeperGame.currentGame!.numberOfRemainingCells -= 1
        }
    }
    
    func showAlert(won won: Bool, formattedDuration: String) {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: won ? "You've won!" : "You've lost!", message: formattedDuration, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "New Game", style: .Default) { _ in
                self.initializeGame()
            })
            alert.addAction(UIAlertAction(title: "Share", style: .Default) { _ in
                self.showActivityController(won: won, formattedDuration: formattedDuration)
            })
            alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alertView = UIAlertView(title: won ? "You've won!" : "You've lost!", message: formattedDuration, delegate: self, cancelButtonTitle: "Done", otherButtonTitles: "New Game", "Share")
            alertView.alertViewStyle = .Default
            alertView.show()
        }
    }
    
    func showActivityController(won won: Bool, formattedDuration: String) {
        let message = "I just \(won ? "won" : "lost") a game of Minsweeper in \(formattedDuration)!"
        let URL = NSURL(string: "https://appsto.re/us/qy64bb.i")!
        let image = self.imageOfGameView()
        let activityViewController = UIActivityViewController(activityItems: [message, URL, image], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAddToReadingList]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func imageOfGameView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.gameView.frame.size, self.gameView.opaque, 0)
        self.gameView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// For backwards compatibility with iOS 7
extension ViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        // If "New Game" is clicked
        if buttonIndex == 1 {
            self.initializeGame()
        } else if buttonIndex == 2 {
            self.showActivityController(won: MinesweeperGame.currentGame!.won, formattedDuration: MinesweeperGame.currentGame!.formattedDuration())
        }
    }
}
