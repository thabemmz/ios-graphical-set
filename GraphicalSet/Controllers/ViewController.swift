//
//  ViewController.swift
//  Set
//
//  Created by Christiaan van Bemmel on 09/08/2019.
//  Copyright © 2019 Christiaan van Bemmel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var setGame: SetGame!
    private var canDealThreeMoreCards: Bool { return !setGame.deck.isEmpty() }
    
    // MARK: Outlets
    @IBOutlet weak var openCardsView: OpenCardsView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
            swipe.direction = [.down]
            openCardsView.addGestureRecognizer(swipe)
            
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotated))
            openCardsView.addGestureRecognizer(rotation)
        }
    }
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak var threeMoreCardsButton: UIButton!
    
    // MARK: Actions
    @IBAction private func touchNewGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    @IBAction private func touchDealThreeMoreCardsButton(_ sender: UIButton) {
        maybeDealThreeMoreCards()
    }
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    // MARK: ObjectiveC gesture responders
    @objc private func swipedDown(_ sender: UISwipeGestureRecognizer) {
        switch(sender.state) {
        case .ended:maybeDealThreeMoreCards()
        default:break
        }
    }
    
    @objc private func rotated(_ sender: UIRotationGestureRecognizer) {
        switch(sender.state) {
        case .changed: fallthrough
        case .ended:
            if sender.rotation >= 0.6 {
                setGame.shuffleOpenCards()
                updateViewFromModel()
                sender.rotation = 0.0
            }
        default: break
        }
    }
    
    @objc func cardTouched(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            // Cast view of the sender to a CardView
            if let senderAsCardView = sender.view as? CardView {
                // Retrieve index of cardView in the openCardsView
                if let cardViewIndex = openCardsView.cardViews.firstIndex(of: senderAsCardView) {
                    // Select the card and update the view
                    setGame.selectOrDeselectCard(at: cardViewIndex)
                    updateViewFromModel()
                } else {
                    print("Chosen card was recognized in open cards")
                }
            }
        default: break
        }
    }
    
    // MARK: Game features
    // Deal three more cards if we are allowed to
    private func maybeDealThreeMoreCards() {
        if canDealThreeMoreCards {
            setGame.dealThreeMoreCards()
            updateViewFromModel()
        }
    }
        
    private func startNewGame() {
        setGame = SetGame()
        updateViewFromModel()
    }
    
    private func createCardView(_ card: Card) -> CardView {
        let cardView = CardView()
        cardView.colorProperty = card.color
        cardView.numberOfShapesProperty = card.numberOfShapes
        cardView.shapeProperty = card.shape
        cardView.shadeProperty = card.shade
        cardView.isSelected = setGame.selectedCards.contains(card)
        
        if cardView.isSelected, setGame.threeCardsSelected {
            // Only set the optional isMatch when the card is part of three selected cards
            cardView.isMatch = setGame.selectedCardsMatch
        } else {
            // If the card is not selected or less then three cards have been selected, don't visualize matching border
            cardView.isMatch = nil
        }
        
        // Add tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTouched))
        cardView.addGestureRecognizer(tap)
        
        return cardView
    }
    
    private func updateViewFromModel () {
        // Create a new Card view for each card in openCardsView
        openCardsView.cardViews = setGame.openCards.map(createCardView)
        
        // Update score label with current setGame score
        scoreLabel.text = "Score: \(setGame.score)"
        
        // If no more then three cards can be dealt, grey out the button
        if !canDealThreeMoreCards {
            // Disable the button
            threeMoreCardsButton.isEnabled = false
            threeMoreCardsButton.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            // Enable the button
            threeMoreCardsButton.isEnabled = true
            threeMoreCardsButton.layer.backgroundColor = #colorLiteral(red: 0.07361408323, green: 0.2849535346, blue: 0.8010703921, alpha: 1)
        }

    }
}

