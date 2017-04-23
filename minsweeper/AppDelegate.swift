//
//  AppDelegate.swift
//  minesweeper
//
//  Created by Jonathan Chan on 2016-04-13.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "game") as? Data {
            MinesweeperGame.currentGame = NSKeyedUnarchiver.unarchiveObject(with: data) as? MinesweeperGame
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        if !MinesweeperGame.currentGame!.isFinished {
            MinesweeperGame.currentGame!.endDate = Date()
        }
        MinesweeperGame.currentGame!.timeOffset = MinesweeperGame.currentGame!.duration()
        MinesweeperGame.currentGame!.startDate = nil
        MinesweeperGame.currentGame!.endDate = nil
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let defaults = UserDefaults.standard
        if MinesweeperGame.currentGame != nil {
            let data = NSKeyedArchiver.archivedData(withRootObject: MinesweeperGame.currentGame!)
            defaults.set(data, forKey: "game")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Start the time immediately if the game was already started before.
        if let currentGame = MinesweeperGame.currentGame, currentGame.isStarted && !currentGame.isFinished {
            MinesweeperGame.currentGame!.startDate = Date()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

