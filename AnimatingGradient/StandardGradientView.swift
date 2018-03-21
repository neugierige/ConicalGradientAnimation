//
//  StandardGradientView.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/20/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit

class StandardGradientView: UIView {
    private var gradientLayer = CAGradientLayer()
    private var gradientColors: [UIColor]?

    var startPoint = CGPoint(x: 0.0, y: 0.5)
    var endPoint = CGPoint(x: 1.0, y: 0.5)

    var colorLocations: [NSNumber] = [0.0, 0.5]

    override func draw(_ rect: CGRect) {
        guard let colors = gradientColors else { return }
        gradientLayer.removeFromSuperlayer()

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds

        gradientLayer.colors = colors.map { $0.cgColor }

        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        gradientLayer.locations = colorLocations

        layer.addSublayer(gradientLayer)
    }

    func configureColors(gradientColors: [UIColor]) {
        self.gradientColors = gradientColors
        self.setNeedsDisplay()
    }
}
