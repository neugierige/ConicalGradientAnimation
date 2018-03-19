//
//  ViewController.swift
//  AnimatingGradient
//
//  Created by Nathan, Lu on 3/13/18.
//  Copyright © 2018 Nathan, Lu. All rights reserved.
//

import UIKit
import AEConicalGradient

class ViewController: UIViewController {

    // MARK: Properties
    let gradientView = ConicalGradientView()
    var gradientCoverView = UIView()
    let strokeCoverLayer = CAShapeLayer()
    let strokeStartCap = UIView()
    let rotationArm = UIView()

    let grayscaleColors: [UIColor] = [.white, .white, .white, .white, .lightGray, .gray, .darkGray, .black, .black]
    let backgroundColor = UIColor(red: 10/255, green: 189/255, blue: 227/255, alpha: 1.0)

    let viewWidth: CGFloat = 250
    let strokeWidth: CGFloat = 50
    let percentageToFill: CGFloat = 0.75

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupGradientView(gradientView)
        setupGradientCoverView(gradientCoverView)
        setupStrokeStartCap()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animateGradientView(duration: 8.0)
        }
    }

    func setupGradientView(_ gradientView: ConicalGradientView) {
        gradientView.frame = CGRect(x: view.frame.midX - viewWidth/2, y: 100, width: viewWidth, height: viewWidth)
        gradientView.gradient.colors = grayscaleColors
        let mask = circleMaskLayer(for: gradientView)
        gradientView.layer.mask = mask
        view.addSubview(gradientView)

        let strokePath = UIBezierPath(
            arcCenter: CGPoint(x: gradientView.frame.size.width / 2.0, y: gradientView.frame.size.height / 2.0),
            radius: (gradientView.frame.size.width - strokeWidth) / 2,
            startAngle: CGFloat(0.0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true)
        gradientView.gradient.path = strokePath.cgPath
        gradientView.gradient.lineWidth = strokeWidth
        gradientView.gradient.fillColor = backgroundColor.cgColor // TODO: change to backgroundColor.cgColor
        gradientView.gradient.strokeColor = UIColor.clear.cgColor
        gradientView.gradient.strokeEnd = 1.0
    }


    func setupGradientCoverView(_ gradientCoverView: UIView) {
        gradientCoverView.frame = gradientView.frame
        gradientCoverView.center = gradientView.center

        let mask = circleMaskLayer(for: gradientCoverView)
        gradientCoverView.layer.mask = mask
        view.addSubview(gradientCoverView)

        let strokeCoverPath = UIBezierPath(
            arcCenter: CGPoint(x: gradientView.frame.size.width / 2.0, y: gradientView.frame.size.height / 2.0),
            radius: (gradientView.frame.size.width - strokeWidth/2) / 2,
            startAngle: CGFloat(Double.pi * 7/2),
            endAngle: CGFloat(Double.pi * 3/2),
            clockwise: false)
        strokeCoverLayer.path = strokeCoverPath.cgPath
        strokeCoverLayer.lineWidth = strokeWidth/2
        strokeCoverLayer.lineCap = kCALineCapButt
        strokeCoverLayer.fillColor = UIColor.clear.cgColor
        strokeCoverLayer.strokeColor = backgroundColor.cgColor // TODO: change to backgroundColor.cgColor

        gradientCoverView.layer.addSublayer(strokeCoverLayer)
    }

    func setupStrokeStartCap() {
        strokeStartCap.frame = CGRect(x: gradientView.frame.midX - strokeWidth/4 + 3, y: gradientView.frame.minY, width: strokeWidth/4, height: strokeWidth/2)
        view.addSubview(strokeStartCap)
        view.bringSubview(toFront: strokeStartCap)

        let semiCircleMaskLayer = CAShapeLayer()
        let semiCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: strokeStartCap.bounds.maxX, y: strokeStartCap.bounds.midY),
            radius: strokeWidth/4,
            startAngle: CGFloat(Double.pi * 3/2),
            endAngle: CGFloat(Double.pi * 5/2),
            clockwise: false)
        semiCircleMaskLayer.path = semiCirclePath.cgPath
        strokeStartCap.layer.mask = semiCircleMaskLayer
    }

    func setupRotationArm() {
        rotationArm.frame = CGRect(x: gradientView.frame.midX, y: gradientView.frame.minY, width: 0.1, height: gradientView.frame.width)
        view.addSubview(rotationArm)

        let invertedHalfCircleMaskLayer = CAShapeLayer()
        let invertedHalfCirclePathFrame = CGRect(x: -strokeWidth/4, y: 0, width: strokeWidth/4, height: strokeWidth/2)

        let invertedHalfCirclePath = UIBezierPath()
        invertedHalfCirclePath.move(to: CGPoint(x: invertedHalfCirclePathFrame.minX, y: invertedHalfCirclePathFrame.minY))
        invertedHalfCirclePath.addArc(
            withCenter: CGPoint(x: invertedHalfCirclePathFrame.minX, y: invertedHalfCirclePathFrame.midY),
            radius: strokeWidth/4,
            startAngle: CGFloat(Double.pi * 3/2),
            endAngle: CGFloat(Double.pi * 5/2),
            clockwise: true)
        invertedHalfCirclePath.addLine(to: CGPoint(x: invertedHalfCirclePathFrame.maxX, y: invertedHalfCirclePathFrame.maxY))
        invertedHalfCirclePath.addLine(to: CGPoint(x: invertedHalfCirclePathFrame.maxX, y: invertedHalfCirclePathFrame.minY))
        invertedHalfCirclePath.close()
        invertedHalfCircleMaskLayer.fillColor = outsideColor.cgColor

        invertedHalfCircleMaskLayer.path = invertedHalfCirclePath.cgPath
        rotationArm.layer.addSublayer(invertedHalfCircleMaskLayer)
    }

    func animateGradientView(duration: CFTimeInterval) {
        CATransaction.begin()

        strokeStartCap.backgroundColor = gradientColors.first

        let uncoverAnimation = CABasicAnimation(keyPath: "strokeEnd")
        uncoverAnimation.duration = duration
        uncoverAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        uncoverAnimation.fromValue = 1.0
        uncoverAnimation.toValue = 1 - percentageToFill
        strokeCoverLayer.strokeEnd = 1 - percentageToFill
        strokeCoverLayer.add(uncoverAnimation, forKey: "show gradient")

        let zRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        zRotationAnimation.duration = duration
        zRotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        zRotationAnimation.fromValue = 0
        zRotationAnimation.toValue = .pi * (2 * (percentageToFill))
        zRotationAnimation.isRemovedOnCompletion = false
        zRotationAnimation.fillMode = kCAFillModeForwards
        rotationArm.layer.add(zRotationAnimation, forKey:nil)

        CATransaction.commit()
    }

    func circleMaskLayer(for view: UIView) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.frame.height/2).cgPath
        return maskLayer
    }
}

