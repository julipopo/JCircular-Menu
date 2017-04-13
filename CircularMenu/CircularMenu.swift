//
//  customLoader.swift
//  CustomLoader
//
//  Created by Julien Simmer  on 15/03/2017.
//  Copyright © 2017 Julien Simmer . All rights reserved.
//

import UIKit

class CircularMenu: UIView {
    
    let displayButton = UIButton()
    let circularView = UIView()
    let whiteCircularView = UIView()
    let circularLayer = CAShapeLayer()
    let subCircularLayer = CAShapeLayer()
    
    var originPoint = CGPoint()
    var originRotation:CGFloat = 0.0
    
    let circularWidth:CGFloat = 80
    let displayMaxButtonHeight:CGFloat = 70
    let newDisplayMaxButtonHeight:CGFloat = 60
    var kH = CGFloat()
    var kW = CGFloat()
    var buttons:[UIButton] = []
    var displayMode = false
    var dragging = false
    var inset = UIEdgeInsets()
    var inset2 = UIEdgeInsets()
    
    var titleArray:[String] = []
    var nameImagearray:[String] = []

    var menuColor = UIColor(red: 41/255, green: 128/255, blue : 185/255, alpha: 1.0)
    
    var delegate: CircularMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(inView : UIView, withColor: UIColor){ //withImageNamed : String, inRect: CGRect){
        
        //traiter les parametres du constructeur ici
        self.menuColor = withColor
        let SUPER = inView.frame.size
        let wid = 0.9 * (SUPER.width)
        kW = wid
        let hei = wid / 2
        kH = hei
        let inRect = CGRect(x: 0.05 * (SUPER.width), y: (SUPER.height) - hei, width: kW, height: kH)
        super.init(frame: inRect)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let pathh2 = UIBezierPath()
        pathh2.move(to: CGPoint(x: 0, y: kH))
        pathh2.addArc(withCenter: CGPoint(x: kW/2, y: kH), radius: kW/2, startAngle: CGFloat(2 * M_PI) / CGFloat(2.0), endAngle: 0, clockwise: true)
        pathh2.addArc(withCenter: CGPoint(x: kW/2, y: kH), radius: kW/2 - circularWidth, startAngle: 0, endAngle: CGFloat(2 * M_PI) / CGFloat(2.0), clockwise: false)
        pathh2.close()
        
        subCircularLayer.path = pathh2.cgPath
        subCircularLayer.backgroundColor = menuColor.cgColor
        subCircularLayer.fillColor = menuColor.cgColor
        self.layer.addSublayer(subCircularLayer)
        subCircularLayer.isHidden = true
        
        whiteCircularView.frame = CGRect(x: circularWidth, y: circularWidth, width: kW - circularWidth * 2, height: (kH - circularWidth) * 2)
        whiteCircularView.backgroundColor = UIColor.clear
        whiteCircularView.layer.cornerRadius = (kW - circularWidth * 2) / 2
        
        circularView.frame = CGRect(x: 0, y: 0, width: kW, height: kH*2)
        circularView.backgroundColor = UIColor.clear
        circularView.layer.cornerRadius = kW / 2
        circularView.isHidden = true
        circularView.alpha = 0
        self.circularView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        circularView.addSubview(whiteCircularView)
        self.addSubview(circularView)
        
        circularView.bounds = CGRect(x: -kW/2, y: -kH, width: kW, height: kH*2)
        
        let pathh = UIBezierPath()
        pathh.move(to: CGPoint(x: -kW/2, y: 0))
        pathh.addArc(withCenter: CGPoint(x: 0, y: 0), radius: kW/2, startAngle: CGFloat(2 * M_PI) / CGFloat(2.0), endAngle: 0, clockwise: true)
        pathh.addArc(withCenter: CGPoint(x: kW/2 - circularWidth/2, y: 0), radius: circularWidth/2, startAngle: 0, endAngle: CGFloat(2 * M_PI) / CGFloat(2.0), clockwise: true)
        pathh.addArc(withCenter: CGPoint(x: 0, y: 0), radius: kW/2 - circularWidth, startAngle: 0, endAngle: CGFloat(2 * M_PI) / CGFloat(2.0), clockwise: false)
        pathh.addArc(withCenter: CGPoint(x: -kW/2 + circularWidth/2, y: 0), radius: circularWidth/2, startAngle: 0, endAngle: CGFloat(2 * M_PI) / CGFloat(2.0), clockwise: true)
        pathh.close()
        
        circularLayer.path = pathh.cgPath
        circularLayer.backgroundColor = menuColor.cgColor
        circularLayer.fillColor = menuColor.cgColor
        circularView.layer.addSublayer(circularLayer)
        
        let centerYVoute = self.kH/2 + self.circularWidth/2
        let newHeight = kH - circularWidth
        
        displayButton.frame = CGRect(x: self.kW/2 - newHeight/2, y: centerYVoute - newHeight/2 - 10, width: newHeight, height: newHeight)
        displayButton.backgroundColor = menuColor
        displayButton.layer.cornerRadius = newHeight/2
        displayButton.layer.masksToBounds = true
        let insetPourcent = CGFloat(0.3)
        let insetPourcent2 = CGFloat(0.25)
        inset2 =  UIEdgeInsetsMake(newHeight *  insetPourcent2,newHeight *  insetPourcent2,newHeight *  insetPourcent2,newHeight *  insetPourcent2)
        inset = UIEdgeInsetsMake(newHeight *  insetPourcent,newHeight *  insetPourcent,newHeight *  insetPourcent,newHeight *  insetPourcent)
        displayButton.imageEdgeInsets = inset
        let buttonImage = UIImage(named: "circularMenu_icon_button")
        displayButton.setImage(buttonImage, for: .normal)
        displayButton.addTarget(self, action: #selector(actionDisplayButton), for: .touchUpInside)
        self.addSubview(displayButton)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
        
        for i in 0..<titleArray.count {
            let title = titleArray[i]
            let image = nameImagearray[i]
            
            setupButton(title: title, imageName: image, index: i)
        }
        
//        setupButton(title: "Heel", imageName: "heel", action: #selector(actionDisplayButton))
//        setupButton(title: "Truck", imageName: "truck", action: #selector(actionDisplayButton))
//        setupButton(title: "Spidedfcgvhjbnjkbjr", imageName: "spider", action: #selector(actionDisplayButton))
//        setupButton(title: "Briquegfhgvjhbnk", imageName: "brique", action: #selector(actionDisplayButton))
//        setupButton(title: "jhbnfd", imageName: "cardio", action: #selector(actionDisplayButton))
//        setupButton(title: "Trrduck", imageName: "path", action: #selector(actionDisplayButton))
//        setupButton(title: "dvfgrbdfev", imageName: "medecin", action: #selector(actionDisplayButton))
        //setupButton(title: "Camembert", imageName: "camembert", action: #selector(actionDisplayButton))
        
    }
    
    func addButton(title: String, imageName: String){
        titleArray.append(title)
        nameImagearray.append(imageName)
    }
    
    func panAction(_ recognizer: UIPanGestureRecognizer){
        if self.buttons.count > 4 {
            switch recognizer.state {
            case .began:
                originPoint = recognizer.location(in: self)
                self.circularView.layer.removeAllAnimations()
                for b in self.buttons{
                    b.layer.removeAllAnimations()
                    b.isUserInteractionEnabled = false
                }
            case .changed:
                for b in self.buttons{
                    b.isUserInteractionEnabled = false
                }
                let changeX = recognizer.location(in: self).x - originPoint.x
                //print(originRotation)
                if(originRotation > 0 && changeX > 0 && buttons.count < 8){
                    placeButtons(dX: changeX/(1+(originRotation)*5))
                } else if (originRotation < valueToAdapt() && changeX < 0 && buttons.count > 4 && buttons.count < 8){
                    placeButtons(dX: changeX/(1+(valueToAdapt()-originRotation)*5))
                } else {
                    placeButtons(dX: changeX)
                }
                originPoint = recognizer.location(in: self)
            //print(originRotation)
            case .ended:
                UIView.animate(withDuration: 1, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                    if(self.originRotation > 0 && self.buttons.count < 8){
                        self.placeButtons(dX: (-self.originRotation)*CGFloat(100))
                    } else if (self.originRotation < self.valueToAdapt() && self.buttons.count > 4 && self.buttons.count < 8){
                        self.placeButtons(dX: (self.valueToAdapt() - self.originRotation)*CGFloat(100)) //change that perhaps
                    } else {
                        var vX = recognizer.velocity(in: self).x
                        if vX > 3100{vX = 3100}
                        if vX < -3100{vX = -3100}
                        let tolerance:CGFloat = 0.2
                        if (self.buttons.count < 8 && self.originRotation < -tolerance && self.originRotation > self.valueToAdapt()+tolerance){
                            if vX>0{
                                self.placeButtons(dX: (-self.originRotation)*CGFloat(100))
                            } else {
                                self.placeButtons(dX: (self.valueToAdapt() - self.originRotation)*CGFloat(100))
                            }
                        } else {
                            self.placeButtons(dX: vX/10.0)
                        }
                    }
                }, completion: { (finished) in
                    for b in self.buttons{
                        b.isUserInteractionEnabled = true
                    }
                })
            default:
                break
            }
        }
    }
    
    func setupButton(title: String, imageName: String, index: Int){
        let button = UIButton()
        buttons.append(button)
        button.frame = CGRect(x: 0, y: 0, width: circularWidth, height: circularWidth)
        
        let btnLabel = UILabel()
        btnLabel.frame = CGRect(x: 15, y: circularWidth - 25, width: circularWidth-30, height: 20)
        btnLabel.font = UIFont.systemFont(ofSize: 10)
        btnLabel.textAlignment = .center
        btnLabel.text = title
        btnLabel.numberOfLines = 1
        if btnLabel.intrinsicContentSize.width < 70{
            btnLabel.adjustsFontSizeToFitWidth = true
        }else{
            btnLabel.font = UIFont.systemFont(ofSize: 7)
        }
        btnLabel.textColor = UIColor.white
        button.addSubview(btnLabel)
        
        button.imageEdgeInsets = UIEdgeInsetsMake(5,10,15,10)
        button.backgroundColor = UIColor.clear
        let buttonImage = UIImage(named: imageName)
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(delegateMethod(_:)), for: .touchUpInside)
        button.tag = index
        circularView.addSubview(button)
        
        placeButtons()
    }
    
    func delegateMethod(_ sender: UIButton){
        delegate?.circularMenuDidSelect(atIndex: sender.tag)
        self.actionDisplayButton()
    }
    
    func placeButtons(dX: CGFloat){
        originRotation = originRotation + dX/100.0
        self.circularView.transform = CGAffineTransform(rotationAngle: originRotation)
        for b in self.buttons{
            b.transform = CGAffineTransform(rotationAngle: -originRotation)
        }
    }
    
    func placeButtons(){
        originRotation = 0
        for b in buttons{
            let i = buttons.index(of: b)
            let radius = kW/2 - circularWidth/2 + 3
            var angle = (CGFloat(M_PI) + CGFloat(i!) * CGFloat(M_PI / 4))
            if self.buttons.count < 8 && self.buttons.count > 3{
                angle += CGFloat(M_PI / 8.6)
            } else if self.buttons.count == 3{
                angle = (CGFloat(M_PI) + CGFloat(i!) * CGFloat(M_PI / 3)) + CGFloat(M_PI / 6)
            } else if self.buttons.count == 2{
                angle = (CGFloat(M_PI) + CGFloat(i!) * CGFloat(M_PI / 2)) + CGFloat(M_PI / 4)
            }
            let xx = cos(Double(angle)) * Double(radius)
            let yy = sin(Double(angle)) * Double(radius)
            //let inset = (angle - CGFloat(1.5 * M_PI)) * 10
            //b.titleEdgeInsets = UIEdgeInsetsMake(55, -67 + inset, 0, 0)
            b.center = CGPoint(x: xx,y: yy)
            b.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    func displayButtons(){
        for b in buttons{
            let i = buttons.index(of: b)
            let angle = (CGFloat(M_PI) + CGFloat(i!) * CGFloat(M_PI / 4))
            var angleToCompare = CGFloat(2*M_PI)
            if self.buttons.count < 8 {
                angleToCompare -= CGFloat(M_PI / 8.6)
            }
            if angle > angleToCompare{
                b.alpha = 0
            }else{
                b.alpha = 1
            }
        }
    }
    
    func actionDisplayButton(){
        if buttons.count < 3 || buttons.count > 8 {
            print("CIRCULAR_MENU ERROR : the circularMenu is made to work with a number of buttons between 3 and 8, currently : \(buttons.count) buttons")
        }
        
        if !displayMode {
            delegate?.circularMenuDidOpen?()
        } else {
            delegate?.circularMenuDidClose?()
        }
        
        displayButtons()
        animateCircular(display: displayMode)
        animateDisplayButton(display : displayMode)
        displayMode = !displayMode
        originRotation = 0
    }
    
    func animateDisplayButton(display : Bool){
        //animer le corner radius avec CABasicAnimation
        let centerYVoute = self.kH/2 + self.circularWidth/2
        var newHeight = display ? (kH - circularWidth) : (kH - circularWidth) - 20
        if newHeight > displayMaxButtonHeight && !display{
            newHeight = displayMaxButtonHeight
        }
        let cornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerAnimation.fromValue = newHeight/2
        cornerAnimation.toValue = 0
        cornerAnimation.duration = 0.3
        cornerAnimation.fillMode = kCAFillModeForwards
        cornerAnimation.isRemovedOnCompletion = false
        displayButton.layer.add(cornerAnimation, forKey: "")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.displayButton.frame = CGRect(x: self.kW/2, y: display ? centerYVoute - 5 : centerYVoute, width: 0, height: 0)
            self.displayButton.alpha = 0
            self.displayButton.imageEdgeInsets = self.inset
        }) { (finish) in
            self.displayButton.backgroundColor = display ? self.menuColor : UIColor(red: 241/255, green: 196/255, blue : 15/255, alpha: 1.0)
            let buttonImage = UIImage(named: display ? "circularMenu_icon_button" : "circularMenu_icon_cross")
            self.displayButton.setImage(buttonImage, for: .normal)
            cornerAnimation.fromValue = 0
            cornerAnimation.duration = 0.3
            cornerAnimation.toValue = newHeight/2
            self.displayButton.layer.add(cornerAnimation, forKey: "")
            
            UIView.animate(withDuration: 0.3, animations: {
                self.displayButton.imageEdgeInsets = display ? self.inset : self.inset2
                self.displayButton.alpha = 1
                let newFrame:CGRect
                newFrame = CGRect(x: self.kW/2 - newHeight/2, y: display ? centerYVoute - newHeight/2 - 10 : centerYVoute - newHeight/2, width: newHeight, height: newHeight)
                self.displayButton.frame = newFrame
            }) { (finish) in
            }
        }
    }
    
    func animateCircular(display : Bool){
        if display{
            self.circularView.transform = CGAffineTransform(rotationAngle: 0)
        }
        self.circularView.isHidden = false
        self.subCircularLayer.isHidden = true
        UIView.animate(withDuration: 0.54, animations: {
            self.circularView.alpha = !display ? 1 : 0
        })
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.circularView.transform = CGAffineTransform(rotationAngle: !display ? 0 : CGFloat(M_PI))
        }) { (finish) in
            self.circularView.isHidden = !display ? false : true
            self.subCircularLayer.isHidden = !display ? false : true
            self.placeButtons()
            for b in self.buttons{
                b.alpha = 1
            }
        }
    }
    
    func valueToAdapt() -> CGFloat{
        var valueToReturn : CGFloat = 0.0
        if(self.buttons.count == 5){
            valueToReturn = 0.73
        }
        if(self.buttons.count == 6){
            valueToReturn = -1.53
        }
        if(self.buttons.count == 7){
            valueToReturn = -2.35
        }
        return valueToReturn
    }
    
}

@objc protocol CircularMenuDelegate {
    
    func circularMenuDidSelect(atIndex index: Int)
    
    @objc optional func circularMenuDidOpen()
    
    @objc optional func circularMenuDidClose()
    
}

