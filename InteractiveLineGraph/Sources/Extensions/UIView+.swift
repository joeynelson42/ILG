//
//  UIView+.swift
//

import UIKit

extension UIView {
  
  // MARK: - NSLayoutConstraint Convenience Methods
  
  func addAutoLayoutSubview(_ subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func insertAutoLayoutSubview(_ view: UIView, belowSubview: UIView) {
    insertSubview(view, belowSubview: belowSubview)
    view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func insertAutoLayoutSubview(_ view: UIView, aboveSubview: UIView) {
    insertSubview(view, aboveSubview: aboveSubview)
    view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // MARK: - Layout
  
  func fillSuperview() {
    guard let superview = self.superview else { return }
    NSLayoutConstraint.activate([
      leftAnchor.constraint(equalTo: superview.leftAnchor),
      rightAnchor.constraint(equalTo: superview.rightAnchor),
      topAnchor.constraint(equalTo: superview.topAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor)
      ])
  }
  
  func fillSuperviewLayoutMargins() {
    guard let superview = self.superview else { return }
    NSLayoutConstraint.activate([
      leftAnchor.constraint(equalTo: superview.leftMargin),
      rightAnchor.constraint(equalTo: superview.rightMargin),
      topAnchor.constraint(equalTo: superview.topMargin),
      bottomAnchor.constraint(equalTo: superview.bottomMargin)
      ])
  }
  
  func centerInSuperView() {
    guard let superview = self.superview else { return }
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: superview.centerXAnchor),
      centerYAnchor.constraint(equalTo: superview.centerYAnchor)
      ])
  }
  
  // MARK: - Layout Shortcuts
  func rightToRight(constant: CGFloat = 0) {
    guard let superview = self.superview else { return }
    rightAnchor.constraint(equalTo: superview.rightAnchor, constant: constant).isActive = true
  }
  
  // MARK: - Iphone X Constraints
  var safeTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11, *) {
      return safeAreaLayoutGuide.topAnchor
    } else {
      return topAnchor
    }
  }
  
  var safeLeftAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11, *) {
      return safeAreaLayoutGuide.leftAnchor
    } else {
      return leftAnchor
    }
  }
  
  var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11, *) {
      return safeAreaLayoutGuide.bottomAnchor
    } else {
      return bottomAnchor
    }
  }
  
  var safeRightAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11, *) {
      return safeAreaLayoutGuide.rightAnchor
    } else {
      return rightAnchor
    }
  }
  
  // MARK: - Layout Margins Guide Shortcut
  
  var leftMargin: NSLayoutXAxisAnchor {
    return layoutMarginsGuide.leftAnchor
  }
  
  var rightMargin: NSLayoutXAxisAnchor {
    return layoutMarginsGuide.rightAnchor
  }
  
  var centerXMargin: NSLayoutXAxisAnchor {
    return layoutMarginsGuide.centerXAnchor
  }
  
  var widthMargin: NSLayoutDimension {
    return layoutMarginsGuide.widthAnchor
  }
  
  var topMargin: NSLayoutYAxisAnchor {
    return layoutMarginsGuide.topAnchor
  }
  
  var bottomMargin: NSLayoutYAxisAnchor {
    return layoutMarginsGuide.bottomAnchor
  }
  
  var centerYMargin: NSLayoutYAxisAnchor {
    return layoutMarginsGuide.centerYAnchor
  }
  
  var heightMargin: NSLayoutDimension {
    return layoutMarginsGuide.heightAnchor
  }
}
