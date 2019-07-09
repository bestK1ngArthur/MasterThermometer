//
//  AppDelegate.swift
//  MacMasterHelper
//
//  Created by a.belkov on 09/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let repeatInterval: Double = 10 * 60

    private let content = BMSTUContent()
    
    private let statusBar: NSStatusBar = .system
    private var statusBarItem: NSStatusItem = .init()
    
    private let popover = NSPopover()
    
    private var timer: Timer?
    
    private var lastCount: Int = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusBarItem = statusBar.statusItem(withLength: 52)
        statusBarItem.button?.action = #selector(buttonTapped)
        statusBarItem.button?.image = NSImage(named: "student")
        statusBarItem.button?.imageScaling = .scaleProportionallyUpOrDown
        statusBarItem.button?.imagePosition = .imageLeading
        
        popover.contentViewController = ViewController.fromStoryboard()
        
        startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: repeatInterval, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    @objc private func buttonTapped() {
        
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }
    
    @objc private func updateCounter() {
        let count = content.getApplicantsCount(department: "ИУ5")
        
        statusBarItem.button?.title = "\(count)"

        if let controller = popover.contentViewController as? ViewController {
            controller.updateCounter(count: count)
        }
        
        lastCount = count
    }
    
    // MARK: Popover
    
    func showPopover() {
        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
            if let controller = popover.contentViewController as? ViewController {
                controller.updateCounter(count: lastCount)
            }
        }
    }
    
    func closePopover() {
        popover.performClose(statusBarItem.button)
    }
}

