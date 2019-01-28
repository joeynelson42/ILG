//
//  ExampleDetailswift
//  InteractiveLineGraphExample
//
//  Created by Joey Nelson on 1/28/19.
//

import UIKit

class ExampleDetailCardView: UIView {
  
  // MARK: - Properties
  private let circleSize: CGFloat = 12
  
  // MARK: - Subviews
  let textLabel = UILabel()
  let circleView = UIView()
  
  // MARK: - Stored Constraints
  // (Store any constraints that might need to be changed or animated later)
  
  
  // MARK: - Initialization
  
  convenience init() {
    self.init(frame: .zero)
    configureSubviews()
    configureTesting()
    configureLayout()
  }
  
  /// Set view/subviews appearances
  fileprivate func configureSubviews() {
    backgroundColor = .white
    layer.cornerRadius = 3
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 3
    layer.shadowOpacity = 0.25
    layer.shadowOffset = CGSize(width: -1, height: 1)
    
    textLabel.font = UIFont.init(name: "Avenir", size: 14)
    textLabel.textColor = .darkGray
    textLabel.text = "TEST"
    
    circleView.layer.cornerRadius = circleSize / 2
    circleView.backgroundColor = .purple
  }
  
  /// Set AccessibilityIdentifiers for view/subviews
  fileprivate func configureTesting() {
    accessibilityIdentifier = "ExampleDetailCardView"
  }
  
  /// Add subviews, set layoutMargins, initialize stored constraints, set layout priorities, activate constraints
  fileprivate func configureLayout() {
    
    addAutoLayoutSubview(textLabel)
    addAutoLayoutSubview(circleView)
    
    // Activate NSLayoutAnchors within this closure
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 2.25),
      
      textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      textLabel.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 8),
      textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
      
      circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
      circleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
      circleView.widthAnchor.constraint(equalToConstant: circleSize),
      circleView.heightAnchor.constraint(equalToConstant: circleSize)
      ])
  }
}

