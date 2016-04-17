//
//  ViewController.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game: MinesweeperGame?
//    var cells: [[MineCell]] = [[MineCell]]()
    var buttons = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let gameView = UIView()
//        gameView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(gameView)
//        gameView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
//        let constraintCenterX = NSLayoutConstraint(item: gameView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
//        let constraintCenterY = NSLayoutConstraint(item: gameView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
//        let constraintWidth = NSLayoutConstraint(item: gameView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
//        let constraintHeight = NSLayoutConstraint(item: gameView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
//        self.view.addConstraints([constraintCenterX, constraintCenterY, constraintWidth, constraintHeight])
//        
//        cells.append([MineCell]())
//        let cell0 = MineCell(row: 0, column: 0)
//        cells[0].append(cell0)
//        cell0.buttonView.translatesAutoresizingMaskIntoConstraints = false
//        cell0.buttonView.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
//        gameView.addSubview(cell0.buttonView)
//        let widthConstraint = NSLayoutConstraint(item: cell0.buttonView, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//        let heightConstraint = NSLayoutConstraint(item: cell0.buttonView, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//        let xConstraint = NSLayoutConstraint(item: cell0.buttonView, attribute: .Left, relatedBy: .Equal, toItem: gameView, attribute: .Left, multiplier: 1, constant: 0)
//        let yConstraint = NSLayoutConstraint(item: cell0.buttonView, attribute: .Top, relatedBy: .Equal, toItem: gameView, attribute: .Top, multiplier: 1, constant: 0)
//        gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
//        for column in 1..<MinesweeperGame.size {
//            let cell = MineCell(row: 0, column: column)
//            cells[0].append(cell)
//            cell.buttonView.translatesAutoresizingMaskIntoConstraints = false
//            cell.buttonView.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
//            gameView.addSubview(cell.buttonView)
//            let widthConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//            let heightConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//            let xConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Left, relatedBy: .Equal, toItem: cells[0][column - 1].buttonView, attribute: .Right, multiplier: 1, constant: 0)
//            let yConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Top, relatedBy: .Equal, toItem: gameView, attribute: .Top, multiplier: 1, constant: 0)
//            gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
//        }
//        
//        for row in 1..<MinesweeperGame.size {
//            cells.append([MineCell]())
//            let cell = MineCell(row: row, column: 0)
//            cells[row].append(cell)
//            cell.buttonView.translatesAutoresizingMaskIntoConstraints = false
//            cell.buttonView.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
//            gameView.addSubview(cell.buttonView)
//            let widthConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//            let heightConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//            let xConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Left, relatedBy: .Equal, toItem: gameView, attribute: .Left, multiplier: 1, constant: 0)
//            let yConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Top, relatedBy: .Equal, toItem: cells[row - 1][0].buttonView, attribute: .Bottom, multiplier: 1, constant: 0)
//            gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
//            for column in 1..<MinesweeperGame.size {
//                let cell = MineCell(row: row, column: column)
//                cells[row].append(cell)
//                cell.buttonView.translatesAutoresizingMaskIntoConstraints = false
//                cell.buttonView.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
//                gameView.addSubview(cell.buttonView)
//                let widthConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//                let heightConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
//                let xConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Left, relatedBy: .Equal, toItem: cells[row][column - 1].buttonView, attribute: .Right, multiplier: 1, constant: 0)
//                let yConstraint = NSLayoutConstraint(item: cell.buttonView, attribute: .Top, relatedBy: .Equal, toItem: cells[row - 1][column].buttonView, attribute: .Bottom, multiplier: 1, constant: 0)
//                gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
//            }
//        }
        
        let gameView = UIView()
        gameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameView)
        gameView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        let xConstraint = NSLayoutConstraint(item: gameView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: gameView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: gameView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: gameView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        self.view.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        
        // initialize buttons and store in `self.buttons`
        for i in 0..<MinesweeperGame.size * MinesweeperGame.size {
            let button = UIButton(type: .System)
            button.tag = i
            self.buttons.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(revealNeighboringCells(_:)), forControlEvents: .TouchUpInside)
            gameView.addSubview(button)
            let xConstraint, yConstraint, widthConstraint, heightConstraint: NSLayoutConstraint
            if i % MinesweeperGame.size == 0 {
                // column 0
                xConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: gameView, attribute: .Left, multiplier: 1, constant: 0)
            } else {
                xConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self.buttons[i - 1], attribute: .Right, multiplier: 1, constant: 0)
            }
            if i / MinesweeperGame.size == 0 {
                // row 0
                yConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: gameView, attribute: .Top, multiplier: 1, constant: 0)
            } else {
                yConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: buttons[i - MinesweeperGame.size], attribute: .Bottom, multiplier: 1, constant: 0)
            }
            widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            heightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        }
        
        initGame()
        
        let resetButton = UIButton(type: .System)
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resetButton)
        self.view.addConstraints([NSLayoutConstraint(item: resetButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0), NSLayoutConstraint(item: resetButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)])
        resetButton.addTarget(self, action: #selector(initGame), forControlEvents: .TouchUpInside)
    }
    
    func initGame() {
        print("Renewing game")
        game = MinesweeperGame()
//        for i in 0..<MinesweeperGame.size {
//            for j in 0..<MinesweeperGame.size {
//                cells[row][column].isRevealed = false
//                cells[row][column].hasMine = game!.hasMine(row: row, column: column)!
//                cells[row][column].numberOfMinesNearby = game!.numberOfMinesNear(row: row, column: column)!
//            }
//        }
//        for i in 0..<self.buttons.count {
//            self.buttons[i]
//        }
        for button in self.buttons {
            print("Resetting button at row \(button.tag / MinesweeperGame.size) column \(button.tag % MinesweeperGame.size)")
            button.setTitle("-", forState: .Normal)
        }
//        for i in
        
        numberOfRemainingCells = MinesweeperGame.size * MinesweeperGame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var numberOfRemainingCells = 0

    func revealNeighboringCells(sender: UIButton) {
        let i = sender.tag / MinesweeperGame.size
        let j = sender.tag % MinesweeperGame.size
        // if the cell is already revealed, don't do anything
        if !game!.finished && !game!.revealedCells[i][j] {
            revealCell(sender)
//            game!.revealedCells[i][j] = true
            numberOfRemainingCells -= 1
            // if all non-mine cells are revealed, win
            if numberOfRemainingCells == MinesweeperGame.numberOfMines {
                game!.finished = true
                let alert = UIAlertController(title: "You've won!", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
//                for row in cells {
//                    for cell in row {
//                        cell.isRevealed = true
//                    }
//                }
                // reveal all cells
//                for row in 0..<MinesweeperGame.size {
//                    for column in 0..<MinesweeperGame.size {
//                        var thisCell = cells[row][column]
//                        thisCell.isRevealed = true
//                        cells[row][column] = thisCell
//                    }
//                }
                for button in self.buttons {
                    revealCell(button)
                }
//                return newCell
            }
            // if the revealed cell has a mine, lose
            if game!.hasMine(row: i, column: j)! {
                game!.finished = true
                let alert = UIAlertController(title: "You've lost!", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
//                for row in cells {
//                    for cell in row {
//                        cell.isRevealed = true
//                    }
//                }
//                return
//                for row in 0..<MinesweeperGame.size {
//                    for column in 0..<MinesweeperGame.size {
//                        var thisCell = cells[row][column]
//                        thisCell.isRevealed = true
//                        cells[row][column] = thisCell
//                    }
//                }
//                return newCell
                for button in self.buttons {
                    revealCell(button)
                }
            } else {
                // if the current cell doesn't have a mine, recursively reveal the neighbouring cells
                if game!.numberOfMinesNear(row: i, column: j)! == 0 {
                    if i > 0 {
                        // north
                        revealNeighboringCells(self.buttons[sender.tag - MinesweeperGame.size])
                    }
                    if j > 0 {
                        // west
                        revealNeighboringCells(self.buttons[sender.tag - 1])
                    }
                    if i < MinesweeperGame.size - 1 {
                        // south
                        revealNeighboringCells(self.buttons[sender.tag + MinesweeperGame.size])
                    }
                    if j < MinesweeperGame.size - 1 {
                        // east
                        revealNeighboringCells(self.buttons[sender.tag + 1])
                    }
                    if i > 0 && j > 0 {
                        // northwest
                        revealNeighboringCells(self.buttons[sender.tag - MinesweeperGame.size - 1])
                    }
                    if i < MinesweeperGame.size - 1 && j > 0 {
                        // southwest
                        revealNeighboringCells(self.buttons[sender.tag + MinesweeperGame.size - 1])
                    }
                    if i > 0 && j < MinesweeperGame.size - 1 {
                        // northeast
                        revealNeighboringCells(self.buttons[sender.tag - MinesweeperGame.size + 1])
                    }
                    if i < MinesweeperGame.size - 1 && j < MinesweeperGame.size - 1 {
                        // southeast
                        revealNeighboringCells(self.buttons[sender.tag + MinesweeperGame.size + 1])
                    }
                }
            }
        }
//        return newCell
    }
    
    func revealCell(button: UIButton) {
        let i = button.tag / MinesweeperGame.size
        let j = button.tag % MinesweeperGame.size
        print("Revealing cell at row \(i) column \(j)")
        if !game!.revealedCells[i][j] {
            if game!.hasMine(row: i, column: j)! {
                button.setTitle("X", forState: .Normal)
            } else {
                let numberOfMinesNearby = game!.numberOfMinesNear(row: i, column: j)!
                button.setTitle(numberOfMinesNearby > 0 ? "\(numberOfMinesNearby)" : "", forState: .Normal)
            }
            game!.revealedCells[i][j] = true
        }
    }
}

