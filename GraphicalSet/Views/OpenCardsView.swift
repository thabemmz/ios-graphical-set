//
//  OpenCardsView.swift
//  GraphicalSet
//
//  Created by Christiaan van Bemmel on 22/08/2019.
//  Copyright © 2019 Christiaan van Bemmel. All rights reserved.
//

import UIKit

class OpenCardsView: UIView {
    var cardViews = [CardView]() {
        didSet {
            // When the cardViews (that are given by the controller) change, rerender.
            setNeedsLayout()
            // And reset the cellCount of the grid.
            grid.cellCount = cardViews.count
        }
    }
    private lazy var grid = Grid(layout: .aspectRatio(Ratios.cardAspectRatio), frame: bounds)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Reset grid frame as `layoutSubviews` is called when bounds change
        grid.frame = bounds
        
        // Remove all previous subViews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // Calculate gutter of grid frames since grid frame size depends on `grid.cellCount`
        let gutter = grid.cellSize.width * Ratios.gutterToWidthRatio
        
        for cardViewsIndex in cardViews.indices {
            // Find the gridFrame for each cardView. Since the `grid.cellCount` changed in the `didSet` of `cardViews`, these should have the same size.
            guard let gridFrame = grid[cardViewsIndex] else {
                 return print("Griditem with index \(cardViewsIndex) could not be found")
            }
            
            let cardView = cardViews[cardViewsIndex]
            // Inset the frames with the gutter
            cardView.frame = gridFrame.insetBy(dx: gutter, dy: gutter)
            
            addSubview(cardView)
        }
    }
}

extension OpenCardsView {
    private struct Ratios {
        static let cardAspectRatio: CGFloat = 5.5 / 8.5
        static let gutterToWidthRatio: CGFloat = 0.05
    }
}
