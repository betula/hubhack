//
//  AppDelegate.swift
//  hubhack
//
//  Created by Icons8 on 19.10.16.
//  Copyright © 2016 hubhack. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.system().statusItem(withLength:NSVariableStatusItemLength)

    var timerForActivity: Timer?
    var timerForActivityTremble: Timer?
    
    var activityTimeInterval: Double = 5*60
    
    var started = false
    var activityPlus = false
    
    let title = "H"
    let titleActive = "H-->"
    let titleActivePlus = "H-->++>"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.title = title
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func startClicked(_ sender: NSMenuItem) {
        activityPlus = false
        start();
    }
    @IBAction func startPlusClicked(_ sender: NSMenuItem) {
        activityPlus = true
        start();
    }
    @IBAction func stopClicked(_ sender: NSMenuItem) {
        stop()
    }
    
    func start() {
        if started {
            stop()
        }
        started = true
        statusItem.title = activityPlus ? titleActivePlus : titleActive
        
        startActivityTremble()
        startActivity();
    }
    
    func stop() {
        if !started {
            return
        }
        started = false
        statusItem.title = title
        
        stopActivity()
        stopActivityTremble()
    }
    
    func stopActivity() {
        timerForActivity?.invalidate()
    }
    
    func stopActivityTremble() {
        timerForActivityTremble?.invalidate()
    }
    
    func startActivityTremble() {
        
        let activityTrembleTimeInterval: Double = 10*60
        
        func resetActivityTimeInterval() {
            let plusFactor = 0.8
            let timeInterval = 2 + 3 * drand48()

            activityTimeInterval = activityPlus ? timeInterval * plusFactor : timeInterval
        }
        
        timerForActivityTremble?.invalidate();
        timerForActivityTremble = Timer.scheduledTimer(
            withTimeInterval: activityTrembleTimeInterval,
            repeats: true
        ) {
            _ in
            resetActivityTimeInterval()
        }
        
        resetActivityTimeInterval()
    }
    
    func startActivity() {
        tickActivity()
    }
    
    func tickActivity() {
        mouseTremble()

        timerForActivity?.invalidate();
        timerForActivity = Timer.scheduledTimer(
            timeInterval: activityTimeInterval,
            target:self,
            selector: #selector(AppDelegate.tickActivity),
            userInfo: nil,
            repeats: false
        )
    }
    
    func mouseTremble() {
        let cursor = NSEvent.mouseLocation()
        let screen = NSScreen.main()!.frame
        let offsets = [
            [0, -1],
            [1, 0],
            [0, 1],
            [-1, 0],
            [0, -1],
            [0, 0]
        ]
        
        for offset in offsets {
            let dx = offset[0]
            let dy = offset[1]
            
            let mouseMoveEvent = CGEvent(
                mouseEventSource: nil,
                mouseType: .mouseMoved,
                mouseCursorPosition: CGPoint(
                    x: Double(cursor.x) + Double(dx),
                    y: Double(screen.height) - Double(cursor.y) + Double(dy)
                ),
                mouseButton: CGMouseButton.left
            )
            mouseMoveEvent?.post(tap: .cghidEventTap)
            usleep(10_000)
        }
    }

}

