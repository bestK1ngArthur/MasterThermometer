//
//  SettingsController.swift
//  MacMasterHelper
//
//  Created by a.belkov on 12/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Cocoa

class SettingsController: NSViewController {

    var config: AppConfig?
    
    @IBOutlet weak var departmentField: NSTextField!
    @IBOutlet weak var studentsCountField: NSTextField!
    @IBOutlet weak var paidStudentsCountField: NSTextField!
    @IBOutlet weak var timeIntervalField: NSTextField!
    @IBOutlet weak var notificationsCheckBox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let config = config else { return }
        departmentField.stringValue = config.department
        studentsCountField.integerValue = config.maxStudentsCount
        paidStudentsCountField.integerValue = config.paidStudentCount
        timeIntervalField.doubleValue = config.updateInterval / 60
        notificationsCheckBox.state = config.needNotifications ? .on : .off
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let newConfig = AppConfig(department: departmentField.stringValue,
                                  maxStudentsCount: studentsCountField.integerValue,
                                  paidStudentCount: paidStudentsCountField.integerValue,
                                  updateInterval: timeIntervalField.doubleValue * 60,
                                  needNotifications: notificationsCheckBox.state == .on)
        
        let notification = Notification(name: AppConfig.updateNotificationName, object: newConfig, userInfo: nil)
        NotificationCenter.default.post(notification)
        
        view.window?.close()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}
