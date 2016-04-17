//
//  MineCell.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit

//class MineCell: UIButton {
//    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        self.setTitle("-", forState: .Normal)
//////        self.addTarget(self, action: #selector(onTouchUpInside), forControlEvents: .TouchUpInside)
////    }
////    
////    required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
////    }
//    
//    class func cell(row row: Int, column: Int) -> MineCell {
//        let cell = MineCell(type: .System)
//        cell._row = row
//        cell._column = column
//        cell.setTitle("-", forState: .Normal)
//        return cell
//    }
//    
//    private var _row: Int = 0
//    var row: Int { return _row }
//    private var _column: Int = 0
//    var column: Int { return _column }
//
//    private var _hasMine: Bool = false
//    var hasMine: Bool {
//        get { return _hasMine }
//        set {
//            _hasMine = newValue
//            if hasMine {
////                self.setTitle("X", forState: .Normal)
//            }
//        }
//    }
//    
//    private var _numberOfMinesNearby: Int = 0
//    var numberOfMinesNearby: Int {
//        get { return _numberOfMinesNearby }
//        set {
//            _numberOfMinesNearby = newValue
////            if !hasMine { self.setTitle("\(numberOfMinesNearby)", forState: .Normal) }
//        }
//    }
//    
//    private var _isRevealed: Bool = false
//    var isRevealed: Bool {
//        get { return _isRevealed }
//        set {
//            _isRevealed = newValue
//            if isRevealed {
//                if hasMine {
//                    self.setTitle("X", forState: .Normal)
//                } else {
//                    self.setTitle(numberOfMinesNearby > 0 ? "\(numberOfMinesNearby)" : "", forState: .Normal)
//                }
//            } else {
//                self.setTitle("-", forState: .Normal)
//            }
//        }
//    }
//
////    func onTouchUpInside() {
////        isRevealed = true
////    }
//}

//struct MineCell {
//    let row: Int
//    let column: Int
//    
//    init(row: Int, column: Int) {
//        self.row = row
//        self.column = column
//        
//        self.buttonView = UIButton(type: .System)
//    }
//    
//    let buttonView: UIButton
//    
//    var hasMine: Bool = false
//    var numberOfMinesNearby: Int = 0
//    
//    private var _isRevealed: Bool = false
//    var isRevealed: Bool {
//        get { return self._isRevealed }
//        set {
//            self._isRevealed = newValue
//            if isRevealed {
//                if hasMine {
//                    self.buttonView.setTitle("X", forState: .Normal)
//                } else {
//                    self.buttonView.setTitle(numberOfMinesNearby > 0 ? "\(numberOfMinesNearby)" : "", forState: .Normal)
//                }
//            } else {
//                self.buttonView.setTitle("-", forState: .Normal)
//            }
//        }
//    }
//}
