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
    var cells: [[MineCell]] = [[MineCell]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gameView = UIView()
        gameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameView)
        gameView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        let constraintCenterX = NSLayoutConstraint(item: gameView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let constraintCenterY = NSLayoutConstraint(item: gameView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        let constraintWidth = NSLayoutConstraint(item: gameView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        let constraintHeight = NSLayoutConstraint(item: gameView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        self.view.addConstraints([constraintCenterX, constraintCenterY, constraintWidth, constraintHeight])
        
        cells.append([MineCell]())
        let cell0 = MineCell.cell(row: 0, column: 0)
        cells[0].append(cell0)
        cell0.translatesAutoresizingMaskIntoConstraints = false
        cell0.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
        gameView.addSubview(cell0)
        let widthConstraint = NSLayoutConstraint(item: cell0, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
        let heightConstraint = NSLayoutConstraint(item: cell0, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
        let xConstraint = NSLayoutConstraint(item: cell0, attribute: .Left, relatedBy: .Equal, toItem: gameView, attribute: .Left, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: cell0, attribute: .Top, relatedBy: .Equal, toItem: gameView, attribute: .Top, multiplier: 1, constant: 0)
        gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        for column in 1..<MinesweeperGame.size {
            let cell = MineCell.cell(row: 0, column: column)
            cells[0].append(cell)
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
            gameView.addSubview(cell)
            let widthConstraint = NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            let heightConstraint = NSLayoutConstraint(item: cell, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            let xConstraint = NSLayoutConstraint(item: cell, attribute: .Left, relatedBy: .Equal, toItem: cells[0][column - 1], attribute: .Right, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: cell, attribute: .Top, relatedBy: .Equal, toItem: gameView, attribute: .Top, multiplier: 1, constant: 0)
            gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
        }
        
        for row in 1..<MinesweeperGame.size {
            cells.append([MineCell]())
            let cell = MineCell.cell(row: row, column: 0)
            cells[row].append(cell)
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
            gameView.addSubview(cell)
            let widthConstraint = NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            let heightConstraint = NSLayoutConstraint(item: cell, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
            let xConstraint = NSLayoutConstraint(item: cell, attribute: .Left, relatedBy: .Equal, toItem: gameView, attribute: .Left, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: cell, attribute: .Top, relatedBy: .Equal, toItem: cells[row - 1][0], attribute: .Bottom, multiplier: 1, constant: 0)
            gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
            for column in 1..<MinesweeperGame.size {
                let cell = MineCell.cell(row: row, column: column)
                cells[row].append(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.addTarget(self, action: #selector(revealCell(_:)), forControlEvents: .TouchUpInside)
                gameView.addSubview(cell)
                let widthConstraint = NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: gameView, attribute: .Width, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
                let heightConstraint = NSLayoutConstraint(item: cell, attribute: .Height, relatedBy: .Equal, toItem: gameView, attribute: .Height, multiplier: 1 / CGFloat(MinesweeperGame.size), constant: 0)
                let xConstraint = NSLayoutConstraint(item: cell, attribute: .Left, relatedBy: .Equal, toItem: cells[row][column - 1], attribute: .Right, multiplier: 1, constant: 0)
                let yConstraint = NSLayoutConstraint(item: cell, attribute: .Top, relatedBy: .Equal, toItem: cells[row - 1][column], attribute: .Bottom, multiplier: 1, constant: 0)
                gameView.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
            }
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
        game = MinesweeperGame()
        for row in 0..<MinesweeperGame.size {
            for column in 0..<MinesweeperGame.size {
                cells[row][column].isRevealed = false
                cells[row][column].hasMine = game!.hasMine(row: row, column: column)!
                cells[row][column].numberOfMinesNearby = game!.numberOfMinesNear(row: row, column: column)!
            }
        }
        
        numberOfRemainingCells = MinesweeperGame.size * MinesweeperGame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var numberOfRemainingCells = 0

    func revealCell(cell: MineCell) {
        if !game!.finished && !cell.isRevealed {
            cell.isRevealed = true
            numberOfRemainingCells -= 1
            if numberOfRemainingCells == MinesweeperGame.numberOfMines {
                game!.finished = true
                let alert = UIAlertController(title: "You've won!", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                for row in cells {
                    for cell in row {
                        cell.isRevealed = true
                    }
                }
                return
            }
            if cell.hasMine {
                game!.finished = true
                let alert = UIAlertController(title: "You've lost!", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                for row in cells {
                    for cell in row {
                        cell.isRevealed = true
                    }
                }
                return
            } else {
                if cell.numberOfMinesNearby == 0 {
                    if cell.row > 0 {
                        revealCell(cells[cell.row - 1][cell.column])
                    }
                    if cell.column > 0 {
                        revealCell(cells[cell.row][cell.column - 1])
                    }
                    if cell.row < MinesweeperGame.size - 1 {
                        revealCell(cells[cell.row + 1][cell.column])
                    }
                    if cell.column < MinesweeperGame.size - 1 {
                        revealCell(cells[cell.row][cell.column + 1])
                    }
                    if cell.row > 0 && cell.column > 0 {
                        revealCell(cells[cell.row - 1][cell.column - 1])
                    }
                    if cell.row < MinesweeperGame.size - 1 && cell.column > 0 {
                        revealCell(cells[cell.row + 1][cell.column - 1])
                    }
                    if cell.row > 0 && cell.column < MinesweeperGame.size - 1 {
                        revealCell(cells[cell.row - 1][cell.column + 1])
                    }
                    if cell.row < MinesweeperGame.size - 1 && cell.column < MinesweeperGame.size - 1 {
                        revealCell(cells[cell.row + 1][cell.column + 1])
                    }
                }
            }
        }
    }
}

