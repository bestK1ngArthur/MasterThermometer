//
//  AppConfig.swift
//  MacMasterHelper
//
//  Created by a.belkov on 09/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Foundation

struct AppConfig {
    
    static let updateNotificationName: Notification.Name = .init(rawValue: "configUpdated")
    
    /// Кафедра
    let department: String
    
    /// Количество мест в магистратуре
    let maxStudentsCount: Int
    
    /// Количество целевых мест
    let paidStudentCount: Int
    
    /// Количество бюджетных мест
    var budgetStudentsCount: Int {
        return maxStudentsCount - paidStudentCount
    }
    
    /// Время до следующего обновления (в секундах)
    let updateInterval: TimeInterval
    
    private enum StorageKey: String {
        case department
        case maxStudentsCount
        case paidStudentCount
        case updateInterval
    }
    
    static var standart: AppConfig {
        return AppConfig(
            department: "ИУ5",
            maxStudentsCount: 43,
            paidStudentCount: 8,
            updateInterval: 5 * 60)
    }
    
    static var saved: AppConfig? {
        guard let department = UserDefaults.standard.string(forKey: StorageKey.department.rawValue),
            let maxStudentsCount = UserDefaults.standard.object(forKey: StorageKey.maxStudentsCount.rawValue) as? Int,
            let paidStudentCount = UserDefaults.standard.object(forKey: StorageKey.paidStudentCount.rawValue) as? Int,
            let updateInterval = UserDefaults.standard.object(forKey: StorageKey.updateInterval.rawValue) as? TimeInterval else {
                return nil
        }

        return AppConfig(department: department, maxStudentsCount: maxStudentsCount, paidStudentCount: paidStudentCount, updateInterval: updateInterval)
    }
    
    func save() {
        UserDefaults.standard.set(department, forKey: StorageKey.department.rawValue)
        UserDefaults.standard.set(maxStudentsCount, forKey: StorageKey.maxStudentsCount.rawValue)
        UserDefaults.standard.set(paidStudentCount, forKey: StorageKey.paidStudentCount.rawValue)
        UserDefaults.standard.set(updateInterval, forKey: StorageKey.updateInterval.rawValue)
    }
}
