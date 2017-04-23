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
    var startDate: Date?
    /// The date when the game finished.
    var endDate: Date?
    /// The time offset from previous sessions to be added to the total game duration, if the game was played over multiple sessions.
    var timeOffset: TimeInterval = 0
    var isStarted = false
    var isFinished = false
    var won = false
    
    fileprivate var mineField: [[Bool]]
    var revealedCells: [[Bool]]
    var markedCells: [[Bool]]
    
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
        self.markedCells = initialArray
        
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
    
    fileprivate init(isStarted: Bool, isFinished: Bool, mineField: [[Bool]], revealedCells: [[Bool]], markedCells: [[Bool]], timeOffset: TimeInterval) {
        // `self.numberOfRemainingCells` is left equal to the default `size * size` because if we're initting from here, it's from a previous game and that will be recalculated by the VC.
        self.isStarted = isStarted
        self.isFinished = isFinished
        self.mineField = mineField
        self.revealedCells = revealedCells
        self.markedCells = markedCells
        self.timeOffset = timeOffset
    }
    
    func hasMine(row: Int, column: Int) -> Bool? {
        if row < 0 || column < 0 || row >= MinesweeperGame.size || column >= MinesweeperGame.size { return nil }
        return self.mineField[row][column]
    }
    
    func numberOfMinesNear(row: Int, column: Int) -> Int? {
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
    
    func duration() -> TimeInterval {
        guard let startDate = self.startDate, let endDate = self.endDate else { return self.timeOffset }
        return endDate.timeIntervalSince(startDate) + self.timeOffset
    }
    
    func formattedDuration() -> String {
        return String(format: "%.2f seconds", MinesweeperGame.currentGame!.duration())
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encodeCInt(Int32(self.numberOfRemainingCells), forKey: "numberOfRemainingCells")
        aCoder.encode(self.isStarted, forKey: "isStarted")
        aCoder.encode(self.isFinished, forKey: "isFinished")
        aCoder.encode(self.mineField, forKey: "mineField")
        aCoder.encode(self.revealedCells, forKey: "revealedCells")
        aCoder.encode(self.markedCells, forKey: "markedCells")
        aCoder.encode(self.timeOffset, forKey: "timeOffset")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let mineField = aDecoder.decodeObject(forKey: "mineField") as? [[Bool]],
            let revealedCells = aDecoder.decodeObject(forKey: "revealedCells") as? [[Bool]],
            let markedCells = aDecoder.decodeObject(forKey: "markedCells") as? [[Bool]]
            else { return nil }
        self.init(
            isStarted: aDecoder.decodeBool(forKey: "isStarted"),
            isFinished: aDecoder.decodeBool(forKey: "isFinished"),
            mineField: mineField,
            revealedCells: revealedCells,
            markedCells: markedCells,
            timeOffset: aDecoder.decodeDouble(forKey: "timeOffset")
        )
    }

}
