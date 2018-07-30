//
//  CapsuleSliderView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class CapsuleSliderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var capsuleMaskView:UIView!
    var opacityView:UIView!
    var valueLabel = UILabel()
    var slidingCallback:(Int)->Void = {_ in }
    private var startPosition:CGPoint?
    private var currentPosition:CGPoint?
    private var thisTouch:UITouch?
    @IBInspectable public var currentValue:Int = 50{
        didSet{
            let y = bounds.height * (1 - CGFloat(currentValue)/CGFloat(maxValue))
            opacityView.frame = CGRect(x: 0, y:y, width: bounds.width, height: bounds.height-y)
            valueLabel.text = "\(currentValue)"
        }
    }
    
    private var lastValue:Int!
    @IBInspectable public var maxValue:Int = 255{
        didSet{
            
        }
    }
    
    @IBInspectable public var minValue:Int = 0{
        didSet{
            
        }
    }
    
    convenience  init(frame: CGRect, startValue originValue:Int, color color:UIColor, slidingCallback callback:@escaping (Int)->Void) {
        self.init(frame: frame, startValue: originValue)
        slidingCallback = callback
        opacityView.backgroundColor = color
        
    }
    
    convenience init(frame:CGRect, startValue originValue:Int){
        self.init(frame:frame)
        lastValue = originValue
        currentValue = originValue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
    }
    
    private func setupUI(){
        capsuleMaskView = UIView()
        
        
        opacityView = UIView()
        
        capsuleMaskView.backgroundColor = UIColor(red:199/255, green:199/255,blue:205/255,alpha:1.00)
        capsuleMaskView.layer.cornerRadius=8
        
        addSubview(capsuleMaskView)
        addSubview(opacityView)
       
        opacityView.layer.masksToBounds = true
        opacityView.layer.cornerRadius = 8
        //opacityView.layer.mask = maskLayer
        lastValue = currentValue
        
        addSubview(valueLabel)
        valueLabel.font = Font_Light.Size_16
        valueLabel.textColor = UIColor(red:155/255, green:155/255,blue:155/255,alpha:1.00)
        valueLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        capsuleMaskView.frame = bounds
        capsuleMaskView.frame = bounds
        valueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(capsuleMaskView.snp.centerX)
            make.bottom.equalTo(capsuleMaskView.snp.top).offset(-3)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count==1{
            startPosition = touches.first?.location(in: self)
            thisTouch = touches.first
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  touches.count==1 ,let startPosition = self.startPosition else{
            return
        }
        
        if let pos = touches.first?.location(in: self){
            let dy = startPosition.y - pos.y
            let dValue = Int(255*dy/bounds.height)
            currentValue = max(minValue,min(maxValue , lastValue+dValue))
            slidingCallback(currentValue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  touches.count==1 else {
            return
        }
        
        lastValue = currentValue
    }
    
    
    
}
