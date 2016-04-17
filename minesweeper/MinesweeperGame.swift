//
//  MinesweeperGame.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import Foundation

struct MinesweeperGame {
    static let size: Int = 9
    static let numberOfMines: Int = 10
    
    var finished = false
    
    private var mineField: [[Bool]]
    var revealedCells: [[Bool]]
    
    init() {
        /// Matrix of `size * size` with `false` values.
        var initialArray = [[Bool]]()
        for _ in 0..<MinesweeperGame.size {
            var row = [Bool]()
            for _ in 0..<MinesweeperGame.size {
                row.append(false)
            }
            initialArray.append(row)
        }
        self.mineField = initialArray
        self.revealedCells = initialArray
        
        // put `numberOfMines` mines in random places
        for _ in 0..<MinesweeperGame.numberOfMines {
            var i, j: Int
            repeat {
                i = Int(arc4random_uniform(UInt32(MinesweeperGame.size)))
                j = Int(arc4random_uniform(UInt32(MinesweeperGame.size)))
            } while self.mineField[i][j]
            self.mineField[i][j] = true
        }
        
        // print out the matrix so we can see where everything is
        for row in 0..<MinesweeperGame.size {
            for column in 0..<MinesweeperGame.size {
                if self.hasMine(row: row, column: column)! { print("X", separator: "", terminator: " ") }
                else { print("\(self.numberOfMinesNear(row: row, column: column)!)", separator: "", terminator: " ") }
            }
            print()
        }
        print()
    }
    
    func hasMine(row row: Int, column: Int) -> Bool? {
        if row < 0 || column < 0 || row >= MinesweeperGame.size || column >= MinesweeperGame.size { return nil }
        return self.mineField[row][column]
    }
    
    func numberOfMinesNear(row row: Int, column: Int) -> Int? {
        if row < 0 || column < 0 || row >= MinesweeperGame.size || column >= MinesweeperGame.size { return nil }
        var numberOfMines = 0
        
        if row > 0 && row < MinesweeperGame.size - 1 {
            if column > 0 && column < MinesweeperGame.size - 1 {
                for i in (column - 1)...(column + 1) {
                    if self.mineField[row - 1][i] { numberOfMines += 1 }
                    if self.mineField[row + 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column - 1] { numberOfMines += 1 }
                if self.mineField[row][column + 1] { numberOfMines += 1 }
            } else if column == 0 {
                for i in (column)...(column + 1) {
                    if self.mineField[row - 1][i] { numberOfMines += 1 }
                    if self.mineField[row + 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column + 1] { numberOfMines += 1 }
            } else if column == MinesweeperGame.size - 1 {
                for i in (column - 1)...(column) {
                    if self.mineField[row - 1][i] { numberOfMines += 1 }
                    if self.mineField[row + 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column - 1] { numberOfMines += 1 }
            }
        } else if row == 0 {
            if column > 0 && column < MinesweeperGame.size - 1 {
                for i in (column - 1)...(column + 1) {
                    if self.mineField[row + 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column - 1] { numberOfMines += 1 }
                if self.mineField[row][column + 1] { numberOfMines += 1 }
            } else if column == 0 {
                for i in (column)...(column + 1) {
                    if self.mineField[row + 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column + 1] { numberOfMines += 1 }
            } else if column == MinesweeperGame.size - 1 {
                for i in (column - 1)...(column) {
                    if self.mineField[row + 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column - 1] { numberOfMines += 1 }
            }
        } else if row == MinesweeperGame.size - 1 {
            if column > 0 && column < MinesweeperGame.size - 1 {
                for i in (column - 1)...(column + 1) {
                    if self.mineField[row - 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column - 1] { numberOfMines += 1 }
                if self.mineField[row][column + 1] { numberOfMines += 1 }
            } else if column == 0 {
                for i in (column)...(column + 1) {
                    if self.mineField[row - 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column + 1] { numberOfMines += 1 }
            } else if column == MinesweeperGame.size - 1 {
                for i in (column - 1)...(column) {
                    if self.mineField[row - 1][i] { numberOfMines += 1 }
                }
                if self.mineField[row][column - 1] { numberOfMines += 1 }
            }
        }
        
        return numberOfMines
    }
}
