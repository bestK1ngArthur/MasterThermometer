//
//  PopoverController.swift
//  MacMasterHelper
//
//  Created by a.belkov on 09/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Cocoa

protocol BMSTUControllerDelegate: AnyObject {
    func settingsButtonTapped()
    func updateButtonTapped()
}

class PopoverController: NSViewController {

    weak var delegate: BMSTUControllerDelegate?
    
    @IBOutlet weak var titleLabel: NSTextField?
    @IBOutlet weak var lastUpdateLabel: NSTextField?
    @IBOutlet weak var peopleIndicator: PeopleIndicator?
    @IBOutlet weak var competitionLabel: NSTextField?
    
    private var config: AppConfig?
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateCounter(current: (count: Int, budgetCount: Int, paidCount: Int), config: AppConfig) {
        titleLabel?.stringValue = config.department
        
        peopleIndicator?.currentValue = current.count
        peopleIndicator?.maxValue = config.maxStudentsCount

        lastUpdateLabel?.stringValue = "Обновлено в \(formatter.string(from: Date()))"
        
        let budgetCompetition = (Float(current.budgetCount) / Float(config.budgetStudentsCount) * 100).rounded() / 100
        let paidCompetition = (Float(current.paidCount) / Float(config.paidStudentCount) * 100).rounded() / 100
        
        competitionLabel?.stringValue =
        """
        БП: \(budgetCompetition) на место (\(current.budgetCount)/\(config.budgetStudentsCount))
        ЦП: \(paidCompetition) на место (\(current.paidCount)/\(config.paidStudentCount))
        """
        
        self.config = config
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        delegate?.updateButtonTapped()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == NSStoryboardSegue.Identifier("OpenSettings") {
            if let window = segue.destinationController as? NSWindowController,
                let settingsController = window.contentViewController as? SettingsController {
                settingsController.config = config
            }
            
            delegate?.settingsButtonTapped()
        }
    }
}

extension PopoverController {

    static func fromStoryboard() -> PopoverController {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(String(describing: PopoverController.self))
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverController else {
            fatalError("Can't find \(String(describing: PopoverController.self)) in Main.storyboard")
        }
        return viewcontroller
    }
}

