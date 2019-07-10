//
//  BMSTUContent.swift
//  MasterHelper
//
//  Created by a.belkov on 02/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Foundation
import Quartz

class BMSTUContent {

    let applicantsListURL = "http://priem.bmstu.ru/UserFiles/registered-magister-Moscow.pdf"

    private var applicantsPDF: PDFDocument? {
        guard let url = URL(string: applicantsListURL) else { return nil }
        return PDFDocument(url: url)
    }
    
    func getApplicantsContent(department: String) -> String? {
        guard var pdfContent = applicantsPDF?.string else { return nil }

        while let foundRange = pdfContent.range(of: "\(department)-И", options: .diacriticInsensitive) {
            pdfContent = pdfContent.replacingCharacters(in: foundRange, with: "")
        }

        return pdfContent
    }
    
    func getApplicantsCount(department: String) -> Int {
        guard var content = getApplicantsContent(department: department) else { return 0 }
        
        var count = 0
        while let foundRange = content.range(of: department, options: .diacriticInsensitive) {
            content = content.replacingCharacters(in: foundRange, with: "")
            count += 1
        }
        
        return count
    }
    
    func getPaidApplicantsCount(department: String) -> Int {
        guard var content = getApplicantsContent(department: department) else { return 0 }

        var count = 0
        while let foundRange = content.range(of: "\(department) (ЦП)", options: .diacriticInsensitive) {
            content = content.replacingCharacters(in: foundRange, with: "")
            count += 1
        }
        
        return count
    }
    
    func getBudgetApplicantsCount(department: String) -> Int {
        let allApplicantsCount = getApplicantsCount(department: department)
        let paidApplicantsCount = getPaidApplicantsCount(department: department)
        
        return allApplicantsCount - paidApplicantsCount
    }
}
