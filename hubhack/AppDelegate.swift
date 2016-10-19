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
            timeInterval: 5,
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
        
        for dx in -1...0 {
            for dy in -1...0 {
                
                let mouseMoveEvent = CGEvent(
                    mouseEventSource: nil,
                    mouseType: .mouseMoved,
                    mouseCursorPosition: CGPoint(
                        x: Double(Float(cursor.x) + Float(dx)),
                        y: Double(Float(cursor.y) + Float(dy))
                    ),
                    mouseButton: CGMouseButton.left
                )
                mouseMoveEvent?.post(tap: .cghidEventTap)
                usleep(200_000)
            }
        }
        
        
        
    }

}

