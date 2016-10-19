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

    var timer: Timer?
    
    var started = false
    let title = "H."
    let titleStarted = "H->"
    
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
        if (started) {
            return
        }
        started = true
        statusItem.title = titleStarted
        timer = Timer.scheduledTimer(
            timeInterval: 2,
            target:self,
            selector: #selector(AppDelegate.tick),
            userInfo: nil,
            repeats: true
        )
    }
    @IBAction func stopClicked(_ sender: NSMenuItem) {
        if (!started) {
            return
        }
        started = false
        statusItem.title = title
        timer?.invalidate()
    }
    
    func tick() {
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

