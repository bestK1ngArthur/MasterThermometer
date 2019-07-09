//
//  PeopleIndicator.swift
//  MasterHelper
//
//  Created by a.belkov on 03/07/2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Cocoa

class PeopleIndicator: NSView {
    
    var currentValue: Int = 1 {
        didSet { setNeedsUpdate() }
    }
    
    var maxValue: Int = 1 {
        didSet { setNeedsUpdate() }
    }
    
    private var topValue: Int {
        return max(currentValue, maxValue) * 4/3
    }
    
    private let lineHeight: CGFloat = 8
    private let scaleWidth: CGFloat = 70
    
    private let deltaOffset: CGFloat = 4
    private let titleOffset: String = " "
    
    private let gradientLayer = CAGradientLayer()
    
    private let maxLabel = NSTextField()
    private let currentLabel = NSTextField()
    private let minLabel = NSTextField()

    private let maxLine = NSView()
    private let currentLine = NSView()
    
    private var maxLabelHeightConstraint: NSLayoutConstraint?
    private var currentLabelHeightConstraint: NSLayoutConstraint?

    private var maxLineHeightConstraint: NSLayoutConstraint?
    private var currentLineHeightConstraint: NSLayoutConstraint?
    
    override func layout() {
        super.layout()
        updateUI()
    }
    
    private var needUpdate = true
    private func updateUI() {
        guard needUpdate else { return }
        needUpdate = false
        createUI()
        
        // Update gradient
        
        gradientLayer.frame = CGRect(origin: .zero,
                                     size: CGSize(width: bounds.width - scaleWidth,
                                                  height: bounds.height))
        let maxLocation = NSNumber(value: 1 - Float(maxValue) / Float(topValue))
        gradientLayer.locations = [0.0, maxLocation, 1.0]
        
        // Update labels
        
        maxLabel.stringValue = "\(titleOffset)\(maxValue)"
        currentLabel.stringValue = "\(titleOffset)\(currentValue) ←"
        
        maxLabelHeightConstraint?.constant = CGFloat(1 - Float(maxValue) / Float(topValue)) * bounds.height
        currentLabelHeightConstraint?.constant = CGFloat(1 - Float(currentValue) / Float(topValue)) * bounds.height
        
        // Update line
        
        if let maxHeight = maxLabelHeightConstraint?.constant {
            maxLineHeightConstraint?.constant = maxHeight + 13
        }
        
        if let currentHeight = currentLabelHeightConstraint?.constant {
            currentLineHeightConstraint?.constant = currentHeight + 13
        }
        
        // Update corners
        
        gradientLayer.cornerRadius = bounds.width / 3.5
    }
    
    private var needCreate = true
    private func createUI() {
        guard needCreate else { return }
        needCreate = false

        wantsLayer = true
        
        // Create gradient

        gradientLayer.colors = [NSColor.green.cgColor, NSColor.yellow.cgColor, NSColor.red.cgColor]
        
        layer?.insertSublayer(gradientLayer, at: 0)
        layer?.masksToBounds = true
        
        // Create labels
        
        let labels = [maxLabel, currentLabel, minLabel]
        
        labels.forEach { label in
            label.alignment = .left
            label.font = NSFont.boldSystemFont(ofSize: 24)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isEditable = false
            label.isBordered = false
            label.drawsBackground = false
            addSubview(label)
        }
        
        minLabel.stringValue = "\(titleOffset)0"
        
        // Create line
        
        addSubview(maxLine)
        addSubview(currentLine)

        maxLine.wantsLayer = true
        maxLine.layer?.backgroundColor = NSColor.darkGray.withAlphaComponent(0.25).cgColor
        maxLine.translatesAutoresizingMaskIntoConstraints = false
        
        currentLine.wantsLayer = true
        currentLine.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
        currentLine.translatesAutoresizingMaskIntoConstraints = false
        
        // Make constraints
        
        var constraints: [NSLayoutConstraint] = []
        
        let maxLabelTopConstraint = maxLabel.topAnchor.constraint(equalTo: topAnchor)
        constraints.append(contentsOf: [
            maxLabel.rightAnchor.constraint(equalTo: rightAnchor),
            maxLabel.widthAnchor.constraint(equalToConstant: scaleWidth - deltaOffset),
            maxLabelTopConstraint
        ])
        maxLabelHeightConstraint = maxLabelTopConstraint
        
        let currentLabelTopConstraint = currentLabel.topAnchor.constraint(equalTo: topAnchor)
        constraints.append(contentsOf: [
            currentLabel.rightAnchor.constraint(equalTo: rightAnchor),
            currentLabel.widthAnchor.constraint(equalToConstant: scaleWidth - deltaOffset),
            currentLabelTopConstraint
        ])
        currentLabelHeightConstraint = currentLabelTopConstraint
        
        constraints.append(contentsOf: [
            minLabel.rightAnchor.constraint(equalTo: rightAnchor),
            minLabel.widthAnchor.constraint(equalToConstant: scaleWidth - deltaOffset),
            minLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let maxLineTopConstraint = maxLine.topAnchor.constraint(equalTo: topAnchor)
        constraints.append(contentsOf: [
            maxLine.leftAnchor.constraint(equalTo: leftAnchor),
            maxLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -scaleWidth),
            maxLine.heightAnchor.constraint(equalToConstant: lineHeight),
            maxLineTopConstraint
        ])
        maxLineHeightConstraint = maxLineTopConstraint
        
        let currentLineTopConstraint = currentLine.topAnchor.constraint(equalTo: topAnchor)
        constraints.append(contentsOf: [
            currentLine.leftAnchor.constraint(equalTo: leftAnchor),
            currentLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -scaleWidth),
            currentLine.heightAnchor.constraint(equalToConstant: lineHeight),
            currentLineTopConstraint
        ])
        currentLineHeightConstraint = currentLineTopConstraint
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setNeedsUpdate() {
        needUpdate = true

        needsLayout = true
        layoutSubtreeIfNeeded()
    }
}
