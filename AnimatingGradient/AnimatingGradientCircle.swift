//
//  AnimatingGradientCircle.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/19/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit
import AEConicalGradient

class AnimatingGradientCircle: UIView {

    private let gradientView = ConicalGradientView()
    private let gradientCoverView = UIView()
    private let gradientCoverLayer = CAShapeLayer()
    private let strokeStartCapView = UIView()
    private let rotationArm = UIView()

    var gradientColors: [UIColor]
    var outsideColor: UIColor
    var strokeWidth: CGFloat

    private let startAngle = CGFloat(Double.pi * 3/2)
    private let halfwayAngle = CGFloat(Double.pi * 5/2)
    private let endAngle = CGFloat(Double.pi * 7/2)
    private let fullCircle = CGFloat(Double.pi * 2)

    init(frame: CGRect, gradientColors: [UIColor], outsideColor: UIColor, strokeWidth: CGFloat) {
        self.gradientColors = gradientColors
        self.outsideColor = outsideColor
        self.strokeWidth = strokeWidth
        super.init(frame: frame)
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)

        setupGradientView()
        setupGradientCoverView()
        setupRotationArm()
        setupStrokeStartCap()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateGradientView(duration: CFTimeInterval, percentageToFill: CGFloat) {
        CATransaction.begin()
        strokeStartCapView.backgroundColor = gradientColors.first

        let uncoverAnimation = CABasicAnimation(keyPath: "strokeEnd")
        uncoverAnimation.duration = duration
        uncoverAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        uncoverAnimation.fromValue = 1.0
        uncoverAnimation.toValue = 1 - percentageToFill
        gradientCoverLayer.strokeEnd = 1 - percentageToFill
        gradientCoverLayer.add(uncoverAnimation, forKey: "uncover gradient")

        let zRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        zRotationAnimation.duration = duration
        zRotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        zRotationAnimation.fromValue = 0
        zRotationAnimation.toValue = fullCircle * percentageToFill
        zRotationAnimation.isRemovedOnCompletion = false
        zRotationAnimation.fillMode = kCAFillModeForwards
        rotationArm.layer.add(zRotationAnimation, forKey: "z rotation")

        CATransaction.commit()
    }

    func clearLayers() {
        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }

    private func setupGradientView() {
        gradientView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        gradientView.gradient.colors = gradientColors
        let mask = circleMaskLayer(for: gradientView)
        gradientView.layer.mask = mask
        addSubview(gradientView)

        let strokePath = UIBezierPath(
            arcCenter: CGPoint(x: gradientView.frame.size.width / 2.0, y: gradientView.frame.size.height / 2.0),
            radius: (gradientView.frame.size.width - strokeWidth) / 2,
            startAngle: CGFloat(0.0),
            endAngle: fullCircle,
            clockwise: true)
        gradientView.gradient.path = strokePath.cgPath
        gradientView.gradient.lineWidth = strokeWidth
        gradientView.gradient.fillColor = outsideColor.cgColor
        gradientView.gradient.strokeColor = UIColor.clear.cgColor
        gradientView.gradient.strokeEnd = 0.0
    }

    private func setupGradientCoverView() {
        gradientCoverView.frame = gradientView.frame
        gradientCoverView.center = gradientView.center
        addSubview(gradientCoverView)

        let mask = circleMaskLayer(for: gradientCoverView)
        gradientCoverView.layer.mask = mask

        let gradientCoverPath = UIBezierPath(
            arcCenter: CGPoint(x: gradientView.frame.size.width / 2.0, y: gradientView.frame.size.height / 2.0),
            radius: (gradientView.frame.size.width - strokeWidth/2) / 2,
            startAngle: endAngle,
            endAngle: startAngle,
            clockwise: false)
        gradientCoverLayer.path = gradientCoverPath.cgPath
        gradientCoverLayer.lineWidth = strokeWidth/2
        gradientCoverLayer.lineCap = kCALineCapButt
        gradientCoverLayer.fillColor = UIColor.clear.cgColor
        gradientCoverLayer.strokeColor = outsideColor.cgColor

        gradientCoverView.layer.addSublayer(gradientCoverLayer)
    }

    private func setupRotationArm() {
        rotationArm.frame = CGRect(x: gradientView.frame.midX, y: gradientView.frame.minY, width: 3, height: gradientView.frame.width)
        addSubview(rotationArm)

        let invertedHalfCircleMaskLayer = CAShapeLayer()
        let invertedHalfCirclePathFrame = CGRect(x: -strokeWidth/4, y: 0, width: strokeWidth/4, height: strokeWidth/2)

        let invertedHalfCirclePath = UIBezierPath()
        let buffer: CGFloat = 5.0
        invertedHalfCirclePath.move(to: CGPoint(x: invertedHalfCirclePathFrame.minX, y: invertedHalfCirclePathFrame.minY))
        invertedHalfCirclePath.addArc(
            withCenter: CGPoint(x: invertedHalfCirclePathFrame.minX, y: invertedHalfCirclePathFrame.midY),
            radius: strokeWidth/4,
            startAngle: startAngle,
            endAngle: halfwayAngle,
            clockwise: true)
        invertedHalfCirclePath.addLine(to: CGPoint(x: invertedHalfCirclePathFrame.minX, y: invertedHalfCirclePathFrame.maxY + buffer))
        invertedHalfCirclePath.addLine(to: CGPoint(x: invertedHalfCirclePathFrame.maxX + buffer, y: invertedHalfCirclePathFrame.maxY + buffer))
        invertedHalfCirclePath.addLine(to: CGPoint(x: invertedHalfCirclePathFrame.maxX + buffer, y: invertedHalfCirclePathFrame.minY - buffer))
        invertedHalfCirclePath.addLine(to: CGPoint(x: invertedHalfCirclePathFrame.minX, y: invertedHalfCirclePathFrame.minY - buffer))
        invertedHalfCirclePath.close()
        invertedHalfCircleMaskLayer.fillColor = outsideColor.cgColor

        invertedHalfCircleMaskLayer.path = invertedHalfCirclePath.cgPath
        rotationArm.layer.addSublayer(invertedHalfCircleMaskLayer)
    }

    private func setupStrokeStartCap() {
        strokeStartCapView.frame = CGRect(x: gradientView.frame.midX - strokeWidth/4 + 3, y: gradientView.frame.minY, width: strokeWidth/4, height: strokeWidth/2)
        addSubview(strokeStartCapView)
        bringSubview(toFront: strokeStartCapView)

        let semiCircleMaskLayer = CAShapeLayer()
        let semiCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: strokeStartCapView.bounds.maxX, y: strokeStartCapView.bounds.midY),
            radius: strokeWidth/4,
            startAngle: startAngle,
            endAngle: halfwayAngle,
            clockwise: false)
        semiCircleMaskLayer.path = semiCirclePath.cgPath
        strokeStartCapView.layer.mask = semiCircleMaskLayer
    }

    // MARK: Helper Methods
    private func circleMaskLayer(for view: UIView) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: frame.height/2).cgPath
        return maskLayer
    }
}
