//
//  ViewController.swift
//  MacMasterHelper
//
//  Created by a.belkov on 09/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var lastUpdateLabel: NSTextField?
    @IBOutlet weak var peopleIndicator: PeopleIndicator?
    @IBOutlet weak var competitionLabel: NSTextField?
    
    private let maxValue: Int = 43
    
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
    
    func updateCounter(count: Int) {
        peopleIndicator?.currentValue = count
        
        lastUpdateLabel?.stringValue = "Обновлено в \(formatter.string(from: Date()))"
        
        let competition = (Float(count) / Float(maxValue) * 100).rounded() / 100
        competitionLabel?.stringValue = "Конкурс \(competition) на место"
    }
}

extension ViewController {

    static func fromStoryboard() -> ViewController {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Can't find ViewController in Main.storyboard")
        }
        return viewcontroller
    }
}

