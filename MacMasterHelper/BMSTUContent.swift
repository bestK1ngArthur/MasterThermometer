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
    
    func getApplicantsCount(department: String) -> Int {
        guard var pdfContent = applicantsPDF?.string else { return 0 }
        
        var count = 0
        while let foundRange = pdfContent.range(of: department, options: .diacriticInsensitive) {
            pdfContent = pdfContent.replacingCharacters(in: foundRange, with: "")
            count += 1
        }
        
        return count
    }
}
