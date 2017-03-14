//
//  ViewController.swift
//  DrawPad
//
//  Copyright (c) 2017 Neil Nie. All rights reserved.
//

import UIKit

open class HandwritingView: UIView {
    
    var mainImageView: UIImageView!
    var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect.init(x: 20, y: 20, width: 200, height: 30))
        label.text = "Please write a number"
        label.font = UIFont.init(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor.black
        self.addSubview(label)
        
        let clear = UIButton(frame: CGRect.init(x: 400, y: 20, width: 60, height: 30))
        clear.setTitleColor(UIColor.black, for: UIControlState.normal)
        clear.setTitle("Clear", for: UIControlState.normal)
        clear.addTarget(self, action: #selector(clearScreen(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(clear)
        
        backgroundColor = UIColor.white
        mainImageView = UIImageView(frame: frame)
        tempImageView = UIImageView(frame: frame)
        self.addSubview(self.mainImageView)
        self.addSubview(self.tempImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    
    func clearScreen(sender: UIButton) {
        mainImageView = nil;
        tempImageView = nil;
    }

    public func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {

        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))

        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)

        context?.strokePath()

        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint
        }
        
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
 
}
