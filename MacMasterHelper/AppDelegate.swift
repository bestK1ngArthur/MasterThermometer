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

    var config: AppConfig = AppConfig.saved ?? AppConfig.standart
    
    private var repeatInterval: TimeInterval {
        return config.updateInterval
    }

    private let content = BMSTUContent()
    
    private let statusBar: NSStatusBar = .system
    private var statusBarItem: NSStatusItem = .init()
    
    private let popover = NSPopover()
    
    private var timer: Timer?
    
    private var count: Int {
        return content.getApplicantsCount(department: config.department)
    }
    private var budgetCount: Int {
        return content.getBudgetApplicantsCount(department: config.department)
    }
    private var paidCount: Int {
        return content.getPaidApplicantsCount(department: config.department)
    }
    
    private var lastCount: Int = 0
    private var lastBudgetCount: Int = 0
    private var lastPaidCount: Int = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusBarItem = statusBar.statusItem(withLength: 52)
        statusBarItem.button?.action = #selector(buttonTapped)
        statusBarItem.button?.image = NSImage(named: "student")
        statusBarItem.button?.imageScaling = .scaleProportionallyUpOrDown
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.button?.title = "⌛"
        
        popover.contentViewController = BMSTUController.fromStoryboard()
        
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
        
        DispatchQueue.global().async {
         
            let count = self.count
            let budgetCount = self.budgetCount
            let paidCount = self.paidCount
            
            DispatchQueue.main.async {
                self.statusBarItem.button?.title = "\(count)"
                
                if let controller = self.popover.contentViewController as? BMSTUController {
                    controller.updateCounter(count: count, budgetCount: budgetCount, paidCount: paidCount)
                }
            }
            
            self.lastCount = count
            self.lastBudgetCount = budgetCount
            self.lastPaidCount = paidCount
        }
    }
    
    // MARK: Popover
    
    func showPopover() {
        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
            if let controller = popover.contentViewController as? BMSTUController {
                controller.updateCounter(count: lastCount, budgetCount: lastBudgetCount, paidCount: lastPaidCount)
            }
        }
    }
    
    func closePopover() {
        popover.performClose(statusBarItem.button)
    }
}

