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
    let strokeEndCapView = UIView()
    let strokeEndCapLayer = CAShapeLayer()

    let grayscaleColors: [UIColor] = [.white, .white, .white, .white, .lightGray, .gray, .darkGray, .black, .black]
    let backgroundColor = UIColor.blue

    let viewWidth: CGFloat = 250
    let strokeWidth: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupGradientView(gradientView)
        setupGradientCoverView(gradientCoverView)
        setupStrokeStartCap()
        setupStrokeEndCap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateGradientView()
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            animateGradientView()
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
        gradientView.gradient.fillColor = UIColor.green.cgColor // TODO: change to backgroundColor.cgColor
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
        strokeCoverLayer.strokeColor = UIColor.red.cgColor // TODO: change to backgroundColor.cgColor

        gradientCoverView.layer.addSublayer(strokeCoverLayer)
    }

    func setupStrokeStartCap() {
        let circleRadius = strokeWidth/2

        // TODO: would look better as a semicircle
        let strokeStartCap = UIView(frame: CGRect(x: gradientView.frame.midX - circleRadius/2, y: gradientView.frame.minY, width: circleRadius, height: circleRadius))
        strokeStartCap.layer.cornerRadius = circleRadius/2
        strokeStartCap.backgroundColor = grayscaleColors.first
        view.addSubview(strokeStartCap)
    }

    func setupStrokeEndCap() {
        strokeEndCapView.frame = CGRect(x: 0, y: 0, width: strokeWidth/2, height: strokeWidth/2)
        strokeEndCapView.backgroundColor = .lightGray
//        view.addSubview(strokeEndCapView)

        let BIG_WIDTH: CGFloat = 300
        let invertedSemiCircle = UIView(frame: CGRect(x: 50, y: 200, width: BIG_WIDTH/2, height: BIG_WIDTH))
        invertedSemiCircle.backgroundColor = UIColor.orange
        view.addSubview(invertedSemiCircle)

        let semiCircleMaskLayer = CAShapeLayer()
        let semiCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: invertedSemiCircle.bounds.minX, y: invertedSemiCircle.bounds.midY),
            radius: BIG_WIDTH/2,
            startAngle: CGFloat(Double.pi * 3/2),
            endAngle: CGFloat(Double.pi * 5/2),
            clockwise: true)
        semiCirclePath.append(UIBezierPath(rect: invertedSemiCircle.bounds))
        semiCircleMaskLayer.fillRule = kCAFillRuleEvenOdd

        semiCircleMaskLayer.path = semiCirclePath.cgPath
        invertedSemiCircle.layer.mask = semiCircleMaskLayer
//        invertedSemiCircle.layer.addSublayer(semiCircleMaskLayer)
    }

    func animateGradientView() {
        CATransaction.begin()
        let uncoverAnimation = CABasicAnimation(keyPath: "strokeEnd")
        uncoverAnimation.duration = 8.0
        uncoverAnimation.fromValue = 1.0
        uncoverAnimation.toValue = 0.25
        strokeCoverLayer.strokeEnd = 0.25
        uncoverAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        strokeCoverLayer.add(uncoverAnimation, forKey: "show gradient")

        let orbitAnimation = CAKeyframeAnimation(keyPath: "position")
        let circlePath = UIBezierPath(
            arcCenter: gradientView.center,
            radius: (gradientView.frame.size.width) / 2,
            startAngle: .pi * 3/2,
            endAngle: .pi * 6/2,
            clockwise: true)
        orbitAnimation.path = circlePath.cgPath
        orbitAnimation.duration = 8.0
        orbitAnimation.repeatCount = 0
        orbitAnimation.timingFunction = uncoverAnimation.timingFunction
        strokeEndCapView.layer.add(orbitAnimation, forKey: "orbit")

        CATransaction.commit()
    }

    func circleMaskLayer(for view: UIView) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.frame.height/2).cgPath
        return maskLayer
    }
}

