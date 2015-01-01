//
//  INDLinkLabel.swift
//  Example
//
//  Created by Indragie on 12/31/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

import UIKit

public class INDLinkLabel: UIView {
    // MARK: Text Attributes
    
    public var text: NSString? {
        didSet {
            if let text = text {
                setAttributedStringForString(text)
            } else {
                clear()
            }
        }
    }
    
    public var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                setAttributedString(attributedText)
            } else {
                clear()
            }
        }
    }
    
    public var font: UIFont = UIFont.systemFontOfSize(17) {
        didSet {
            applyAttributeWithKey(NSFontAttributeName, value: font)
        }
    }
    
    public var textColor: UIColor = UIColor.blackColor() {
        didSet {
            applyAttributeWithKey(NSForegroundColorAttributeName, value: textColor)
        }
    }
    
    public var textAlignment: NSTextAlignment = .Left {
        didSet {
            applyAttributeWithKey(NSParagraphStyleAttributeName, value: paragraphStyle)
        }
    }
    
    public var lineBreakMode: NSLineBreakMode = .ByTruncatingTail {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
            applyAttributeWithKey(NSParagraphStyleAttributeName, value: paragraphStyle)
        }
    }
    
    public var shadowColor: UIColor? {
        didSet {
            applyAttributeWithKey(NSShadowAttributeName, value: shadow)
        }
    }
    
    public var shadowOffset: CGSize? {
        didSet {
            applyAttributeWithKey(NSShadowAttributeName, value: shadow)
        }
    }
    
    // MARK: Text Layout

    public var numberOfLines: Int = 1 {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
            invalidateDisplayAndLayout()
        }
    }
    
    // MARK: Private
    
    private var layoutManager: NSLayoutManager!
    private var textStorage: NSTextStorage!
    private var textContainer: NSTextContainer!
    
    // MARK: Initialization
    
    private func commonInit() {
        textContainer = NSTextContainer()
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0
        
        layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        contentMode = .Redraw
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Applying Attributes
    
    private var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        return style
    }
    
    private var shadow: NSShadow? {
        if let color = shadowColor {
            let shadow = NSShadow()
            shadow.shadowColor = color
            if let offset = shadowOffset {
                shadow.shadowOffset = offset
            }
            return shadow
        }
        return nil
    }
    
    private func clear() {
        textStorage.deleteCharactersInRange(NSRange(location: 0, length: textStorage.length))
        invalidateDisplayAndLayout()
    }
    
    private func setAttributedStringForString(string: NSString) {
        textStorage.mutableString.setString(string)
        
        applyAttributeWithKey(NSFontAttributeName, value: font)
        applyAttributeWithKey(NSForegroundColorAttributeName, value: textColor)
        applyAttributeWithKey(NSParagraphStyleAttributeName, value: paragraphStyle)
        applyAttributeWithKey(NSShadowAttributeName, value: shadow)
    }
    
    private func setAttributedString(attrString: NSAttributedString) {
        textStorage.setAttributedString(attrString)
        invalidateDisplayAndLayout()
    }
    
    private func applyAttributeWithKey(key: NSString, value: AnyObject?) {
        let range = NSRange(location: 0, length: textStorage.length)
        if let value: AnyObject = value {
            textStorage.addAttribute(key, value: value, range: range)
        } else {
            textStorage.removeAttribute(key, range: range)
        }
        invalidateDisplayAndLayout()
    }
    
    private func invalidateDisplayAndLayout() {
        setNeedsDisplay()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: Drawing
    
    public override func drawRect(rect: CGRect) {
        textContainer.size = bounds.size
        
        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
        layoutManager.drawBackgroundForGlyphRange(glyphRange, atPoint: bounds.origin)
        layoutManager.drawGlyphsForGlyphRange(glyphRange, atPoint: bounds.origin)
    }
    
    // MARK: Layout
    
    private var contentSize: CGSize {
        let glyphRange = layoutManager.glyphRangeForTextContainer(textContainer)
        return layoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer).size
    }
    
    public override func intrinsicContentSize() -> CGSize {
        textContainer.size = bounds.size
        return contentSize
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        textContainer.size = size
        return contentSize
    }
}