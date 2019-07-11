//
//  BMSTUController.swift
//  MacMasterHelper
//
//  Created by a.belkov on 09/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Cocoa

class BMSTUController: NSViewController {

    @IBOutlet weak var lastUpdateLabel: NSTextField?
    @IBOutlet weak var peopleIndicator: PeopleIndicator?
    @IBOutlet weak var competitionLabel: NSTextField?
    
    private let maxValue: Int = AppConfig.maxStudentsCount
    private let maxPaid: Int = AppConfig.paidStudentCount
    private let maxBudget: Int = AppConfig.maxStudentsCount - AppConfig.paidStudentCount
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        peopleIndicator?.maxValue = maxValue
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func updateCounter(count: Int, budgetCount: Int, paidCount: Int) {
        peopleIndicator?.currentValue = count
        
        lastUpdateLabel?.stringValue = "Обновлено в \(formatter.string(from: Date()))"
        
        let budgetCompetition = (Float(budgetCount) / Float(maxBudget) * 100).rounded() / 100
        let paidCompetition = (Float(paidCount) / Float(maxPaid) * 100).rounded() / 100
        
        competitionLabel?.stringValue =
        """
        БП: \(budgetCompetition) на место (\(budgetCount)/\(maxBudget))
        ЦП: \(paidCompetition) на место (\(paidCount)/\(maxPaid))
        """
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
    }
}

extension BMSTUController {

    static func fromStoryboard() -> BMSTUController {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(String(describing: BMSTUController.self))
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? BMSTUController else {
            fatalError("Can't find \(String(describing: BMSTUController.self)) in Main.storyboard")
        }
        return viewcontroller
    }
}

