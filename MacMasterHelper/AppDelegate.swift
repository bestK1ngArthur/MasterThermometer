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
        
        let controller = PopoverController.fromStoryboard()
        controller.delegate = self
        popover.contentViewController = controller
        
        NotificationCenter.default.addObserver(self, selector: #selector(configUpdated(_:)), name: AppConfig.updateNotificationName, object: nil)
        
        startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        stopTimer()
        config.save()
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
         
            let count = self.content.getApplicantsCount(department: self.config.department)
            let budgetCount = self.content.getBudgetApplicantsCount(department: self.config.department)
            let paidCount = self.content.getPaidApplicantsCount(department: self.config.department)
            
            DispatchQueue.main.async {
                self.statusBarItem.button?.title = "\(count)"
                
                if let controller = self.popover.contentViewController as? PopoverController {
                    controller.updateCounter(current: (count: count, budgetCount: budgetCount, paidCount: paidCount), config: self.config)
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
            
            if let controller = popover.contentViewController as? PopoverController {
                controller.updateCounter(current: (count: lastCount, budgetCount: lastBudgetCount, paidCount: lastPaidCount), config: self.config)
            }
        }
    }
    
    func closePopover() {
        popover.performClose(statusBarItem.button)
    }
    
    // MARK: Config
    
    @objc private func configUpdated(_ notification: Notification) {
        guard let newConfig = notification.object as? AppConfig else { return }
        config = newConfig
        reset()
    }
    
    // MARK: Data
    
    private func reset() {
        lastCount = 0
        lastBudgetCount = 0
        lastPaidCount = 0

        update()
    }
    
    private func update() {
        statusBarItem.button?.title = "⌛"
        timer?.fire()
    }
}

extension AppDelegate: BMSTUControllerDelegate {
    func updateButtonTapped() {
        update()
    }
    
    func settingsButtonTapped() {
        closePopover()
    }
}
