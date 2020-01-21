//
//  CardView.swift
//  GraphicalSet
//
//  Created by Christiaan van Bemmel on 22/08/2019.
//  Copyright © 2019 Christiaan van Bemmel. All rights reserved.
//

import UIKit

class CardView: UIView {
    var colorProperty: CardProperty = .optionOne { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private lazy var color = SymbolView.Color.fromProperty(colorProperty)
    var shadeProperty: CardProperty = .optionOne { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private lazy var shade = SymbolView.Shade.fromProperty(shadeProperty)
    var shapeProperty: CardProperty = .optionOne { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private lazy var shape = SymbolView.Shape.fromProperty(shapeProperty)
    var numberOfShapesProperty: CardProperty = .optionOne { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var symbolViews = [Int: SymbolView]()
    var isSelected = false { didSet { setNeedsDisplay() } }
    var isMatch: Bool?
    private lazy var grid = Grid(layout: .aspectRatio(Ratios.symbolAspectRatio), frame: bounds.insetBy(dx: cardCornerOffset, dy: cardCornerOffset))
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Set opaqueness in initializer
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Set opaqueness in initializer
        isOpaque = false
    }
    
    // MARK: Rendering and drawing
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Reset the frame of the grid by the bounds of this view
        grid.frame = bounds.insetBy(dx: cardCornerOffset, dy: cardCornerOffset)
        grid.cellCount = numberOfShapes
        
        // Remove all previous subviews to force rerender
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        for cellIndex in 0..<numberOfShapes {
            if let gridFrame = grid[cellIndex] {
                // Create a new symbolview and set the properties
                let symbolView = SymbolView(frame: gridFrame.insetBy(dx: 0, dy: symbolInset))
                symbolView.color = color
                symbolView.shade = shade
                symbolView.shape = shape
                
                // Add subview to grid
                addSubview(symbolView)
            } else {
                print("Grid frame could not be found")
            }
        }
    }
        
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isMatch != nil {
            roundedRect.lineWidth = cardStrokeWidth

            if isMatch! {
                UIColor.green.setStroke()
            } else {
                UIColor.red.setStroke()
            }
        } else if isSelected {
            UIColor.blue.setStroke()
            roundedRect.lineWidth = cardStrokeWidth
        } else {
            UIColor.black.setStroke()
        }
        
        roundedRect.stroke()
    }
}

extension CardView {
    struct Ratios {
        static let cardCornerRadiusToBoundsWidth: CGFloat = 0.1
        static let cardCornerOffsetToCornerRadius: CGFloat = 0.8
        static let cardStrokeWidthToBoundsWidth: CGFloat = 0.05
        static let symbolAspectRatio: CGFloat = 110 / 55
        static let symbolInsetToBoundsHeight: CGFloat = 0.025
    }
    
    private var cardCornerRadius: CGFloat {
        return bounds.size.width * Ratios.cardCornerRadiusToBoundsWidth
    }
    
    private var cardCornerOffset: CGFloat {
        return cardCornerRadius * Ratios.cardCornerOffsetToCornerRadius
    }
    
    private var cardStrokeWidth: CGFloat {
        return bounds.size.width * Ratios.cardStrokeWidthToBoundsWidth
    }
    
    private var symbolInset: CGFloat {
        return bounds.size.height * Ratios.symbolInsetToBoundsHeight
    }
    
    private var numberOfShapes: Int {
        switch numberOfShapesProperty {
        case .optionOne: return 1
        case .optionTwo: return 2
        case .optionThree: return 3
        }
    }
}
