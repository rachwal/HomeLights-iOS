//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//  https://github.com/johankasperi/SwiftHSVColorPicker
//  Created by johankasperi on 2015-08-20.
//
//  Modified by rachwal
//  selectedColorView removed
//  callback added

import UIKit

public class SwiftHSVColorPicker: UIView {
    var colorWheel: ColorWheel!
    var brightnessView: BrightnessView!
    var callback: (() -> Void)?
    
    public var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setViewColor(color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color
        setup()
    }
    
    public func setColorChangedCallback(callback: () -> Void)
    {
        self.callback = callback
    }
    
    func setup() {
        // Remove all subviews
        let views = self.subviews
        for view in views {
            view.removeFromSuperview()
        }
        
        let brightnessViewHeight: CGFloat = 48.0
        
        // let color wheel get the maximum size that is not overflow from the frame for both width and height
        let colorWheelSize = min(self.bounds.width, self.bounds.height - brightnessViewHeight)
        
        // let the all the subviews stay in the middle of universe horizontally
        let centeredX = (self.bounds.width - colorWheelSize) / 2.0
        
        // Init new ColorWheel subview
        colorWheel = ColorWheel(frame: CGRect(x: centeredX, y: 30, width: colorWheelSize, height: colorWheelSize), color: self.color)
        colorWheel.delegate = self
        // Add colorWheel as a subview of this view
        self.addSubview(colorWheel)
        
        // Init new BrightnessView subview
        brightnessView = BrightnessView(frame: CGRect(x: centeredX, y: CGRectGetMaxY(colorWheel.frame)+70, width: colorWheelSize, height: brightnessViewHeight), color: self.color)
        brightnessView.delegate = self
        // Add brightnessView as a subview of this view
        self.addSubview(brightnessView)
    }
    
    func hueAndSaturationSelected(hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        brightnessView.setViewColor(self.color)
        
        if let callback = callback { callback() }
    }
    
    func brightnessSelected(brightness: CGFloat) {
        self.brightness = brightness
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        colorWheel.setViewBrightness(brightness)
        
        if let callback = callback { callback() }
    }
}
