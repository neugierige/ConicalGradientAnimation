//
//  AnimatingGradientBarView.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/21/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit

class AnimatingGradientBarView: UIView {

    let gradientView = StandardGradientView()
    let cover = UIView()
    let invertedSemiCircle = UIView()

    var outsideColor: UIColor!
    var isAnimating = false

    // MARK: public API
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()

        if !isAnimating {
            setupGradientCover()
        }
    }

    func setOutsideColor(_ outsideColor: UIColor) {
        self.outsideColor = outsideColor
        backgroundColor = UIColor.white
        setupGradient()
        setupGradientCover()
    }

    func animate(duration: TimeInterval, percentage: Double) {
        isAnimating = true
        gradientView.isHidden = false

        let endYPosition = frame.height * (CGFloat(percentage) > 1 ? 1.0 : CGFloat(1 - percentage))
        let currentRect = cover.frame
        UIView.animate(withDuration: duration, animations: {
            self.invertedSemiCircle.frame = CGRect(x: self.invertedSemiCircle.frame.minX,
                                                   y: endYPosition,
                                                   width: self.invertedSemiCircle.frame.width,
                                                   height: self.invertedSemiCircle.frame.height)
            self.cover.frame = UIEdgeInsetsInsetRect(currentRect, UIEdgeInsets(top: 0, left: 0, bottom: currentRect.height - endYPosition, right: 0))
        }) { _ in
            self.isAnimating = false
        }
    }

    // MARK: private API
    private func addSubviews() {
        gradientView.isHidden = true
        addSubview(gradientView)
        addSubview(cover)
        addSubview(invertedSemiCircle)
    }

    private func setupGradient() {
        gradientView.frame = bounds
        gradientView.configureColors(gradientColors: [UIColor.green, UIColor.yellow, UIColor.red])
        gradientView.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.colorLocations = [0.0, 0.5, 1.0]
        gradientView.layer.cornerRadius = frame.width/2
        gradientView.layer.masksToBounds = true
    }

    private func setupGradientCover() {
        let arcRadius = bounds.width/2
        let buffer: CGFloat = 3.0

        cover.frame = bounds
        cover.frame.size.height = bounds.size.height - arcRadius * 2

        invertedSemiCircle.frame = CGRect(x: cover.bounds.minX, y: cover.bounds.maxY - buffer, width: cover.bounds.width, height: arcRadius + buffer)

        cover.backgroundColor = outsideColor
        invertedSemiCircle.backgroundColor = outsideColor
        bringSubview(toFront: cover)
        bringSubview(toFront: invertedSemiCircle)

        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: invertedSemiCircle.bounds.minX, y: invertedSemiCircle.bounds.minY))
        maskPath.addLine(to: CGPoint(x: invertedSemiCircle.bounds.minX, y: invertedSemiCircle.bounds.maxY))
        maskPath.addArc(withCenter: CGPoint(x: invertedSemiCircle.bounds.midX, y: invertedSemiCircle.bounds.maxY),
                        radius: arcRadius,
                        startAngle: .pi,
                        endAngle: .pi * 2,
                        clockwise: true)
        maskPath.addLine(to: CGPoint(x: invertedSemiCircle.bounds.maxX, y: invertedSemiCircle.bounds.minY))
        maskPath.close()
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        invertedSemiCircle.layer.mask = maskLayer
    }
}
