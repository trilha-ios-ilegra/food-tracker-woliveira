//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Walter Oliveira on 22/10/18.
//  Copyright © 2018 Walter Oliveira. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize  = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    private func setupButtons() {
        
        let (emptyStar, filledStar, highlightedStar) = loadImages()
        
        clearButton()
        
        for index in 0..<starCount {
            
            let button = createButton(emptyStar: emptyStar!, filledStar: filledStar!, highlightedStar: highlightedStar!, index: index)
            
            addArrangedSubview(button)
            
            ratingButtons.append(button)
            
            updateButtonSelectionStates()
        }
    }
    
    private func createButton(emptyStar: UIImage, filledStar: UIImage, highlightedStar: UIImage, index: Int) -> UIButton {
        
        let button = UIButton()
        
        button.setImage(filledStar, for: .selected)
        button.setImage(emptyStar, for: .normal)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
        button.accessibilityLabel = "Set \(index + 1) star rating"
        
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        
        return button

    }

    private func loadImages() -> (UIImage?, UIImage?, UIImage?) {
        
        let filledStar = UIImage(named: "filledStar")
        let emptyStar = UIImage(named: "emptyStar")
        let highlightedStar = UIImage(named: "highlightedStar")
        
        return (emptyStar, filledStar, highlightedStar)
    }
    
    private func clearButton() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
    }
 
    private func updateButtonSelectionStates() {
        
        let valueString: String
        switch(rating) {
        case 0:
            valueString = "No rating set."
        case 1:
            valueString = "1 star set"
        default:
            valueString = "/(rating) stars set"
        }
        
        for (index, button) in ratingButtons.enumerated(){
            
           button.isSelected = index < rating
            
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }

            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
    }
}