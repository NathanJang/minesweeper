//
//  MinesweeperGame.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import Foundation

/// An object of the game state.
/// Conforms to `NSCoding` because the game state persists between launches.
class MinesweeperGame: NSObject, NSCoding {
    static var currentGame: MinesweeperGame?
    
    static let size = 9
    static let numberOfMines = 10
    
    var numberOfRemainingCells = MinesweeperGame.size * MinesweeperGame.size
    
    /// The date when the current session started.
    var startDate: NSDate?
    /// The date when the game finished.
    var endDate: NSDate?
    /// The time offset from previous sessions to be added to the total game duration, if the game was played over multiple sessions.
    var timeOffset: NSTimeInterval = 0
    var isStarted = false
    var isFinished = false
    var won = false
    
    private var mineField: [[Bool]]
    var revealedCells: [[Bool]]
    
    override init() {
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
        
        super.init()
        
        // Put `numberOfMines` mines in random places.
        for _ in 0..<MinesweeperGame.numberOfMines {
            var i, j: Int
            repeat {
                i = Int(arc4random_uniform(UInt32(MinesweeperGame.size)))
                j = Int(arc4random_uniform(UInt32(MinesweeperGame.size)))
            } while self.mineField[i][j]
            self.mineField[i][j] = true
        }
        
        // Print out the matrix so we can see where everything is.
        for row in 0..<MinesweeperGame.size {
            for column in 0..<MinesweeperGame.size {
                if self.hasMine(row: row, column: column)! { print("X", separator: "", terminator: " ") }
                else { print("\(self.numberOfMinesNear(row: row, column: column)!)", separator: "", terminator: " ") }
            }
            print()
        }
        print()
    }
    
    private init(isStarted: Bool, isFinished: Bool, mineField: [[Bool]], revealedCells: [[Bool]], timeOffset: NSTimeInterval) {
        // `self.numberOfRemainingCells` is left equal to the default `size * size` because if we're initting from here, it's from a previous game and that will be recalculated by the VC.
        self.isStarted = isStarted
        self.isFinished = isFinished
        self.mineField = mineField
        self.revealedCells = revealedCells
        self.timeOffset = timeOffset
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
    
    func duration() -> NSTimeInterval {
        guard let startDate = self.startDate, endDate = self.endDate else { return self.timeOffset }
        return endDate.timeIntervalSinceDate(startDate) + self.timeOffset
    }
    
    func formattedDuration() -> String {
        return String(format: "%.2f seconds", MinesweeperGame.currentGame!.duration())
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt(Int32(self.numberOfRemainingCells), forKey: "numberOfRemainingCells")
        aCoder.encodeBool(self.isStarted, forKey: "isStarted")
        aCoder.encodeBool(self.isFinished, forKey: "isFinished")
        aCoder.encodeObject(self.mineField, forKey: "mineField")
        aCoder.encodeObject(self.revealedCells, forKey: "revealedCells")
        aCoder.encodeDouble(self.timeOffset, forKey: "timeOffset")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let mineField = aDecoder.decodeObjectForKey("mineField") as? [[Bool]],
            let revealedCells = aDecoder.decodeObjectForKey("revealedCells") as? [[Bool]]
            else { return nil }
        self.init(
            isStarted: aDecoder.decodeBoolForKey("isStarted"),
            isFinished: aDecoder.decodeBoolForKey("isFinished"),
            mineField: mineField,
            revealedCells: revealedCells,
            timeOffset: aDecoder.decodeDoubleForKey("timeOffset")
        )
    }
}
