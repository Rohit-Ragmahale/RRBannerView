//
//  RRBannerView.swift
//  RRBannerView
//
//  Created by Rohit Ragmahale on 19/03/17.
//  Copyright © 2017 Rohit Ragmahale. All rights reserved.
//

import UIKit

class RRBannerView: UIView {
    // This is enum which decides the position of the banner in view
    enum BannerPosition: Int {
        case top = 0    // Top in view
        case middle = 1 // Middle in view
        case bottom = 2 // Bottom in view. Default value.
    }
    
    fileprivate var parentView: UIView? = nil
    fileprivate var message: String? = nil
    fileprivate var title: String? = nil
    fileprivate var image: UIImage? = nil
    
    var autoDismiss: Bool = true
    var titleFont = UIFont.boldSystemFont(ofSize: 16)
    var messageFont = UIFont.systemFont(ofSize: 14)
    fileprivate let viewDisplayDuration: TimeInterval = 3.0
    fileprivate let imageViewSize: CGFloat = 30.0
    fileprivate let defaultPadding: CGFloat = 10.0
    fileprivate let interMessagePadding: CGFloat = 5.0
    fileprivate var bannerViewHeight: CGFloat = 100.0
    fileprivate let miniBannerHeight: CGFloat = 70.0
    fileprivate let maxLineLimitForTitle = 5
    fileprivate var position: BannerPosition = .bottom
    fileprivate var timer: Timer? = nil
    
    // MARK: - Init Methods
    /**
     This method creates new RRBannerView
     
     - parameter title: title to be shown banner.
     - parameter message: message to be shown banner .
     - parameter image: image on banner.
     - parameter view: view in which banner is to be shown.
     */
    convenience init(title: String?, message: String?, image: UIImage?, view: UIView) {
        self.init()
        self.title = title
        self.message = message
        self.image = image
        self.parentView = view
    }
    
    // MARK: - LifeCycle Methods
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = superview {
            NotificationCenter.default.addObserver(self, selector: #selector(RRBannerView.deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            self.alpha = 0.0
            populateDetails()
            addToParent()
            addTapgesture()
            if autoDismiss {
                timer = Timer.scheduledTimer(timeInterval: viewDisplayDuration, target: self, selector: #selector(RRBannerView.dissmissSelf(_:)), userInfo: nil, repeats: true)
            }
            layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.alpha = 1.0
            })
        }
    }
    
    // MARK: - Public Methods
    /**
     This method adds RRBannerView to parent view
     
     - parameter position: banner position in parent view
     
     */
    func show(_ position: BannerPosition = .bottom) {
        self.position = position
        if let _ = parentView {
            //backgroundColor = UIColor.redColor()
            translatesAutoresizingMaskIntoConstraints = false
            alpha = 0.0
            parentView?.addSubview(self)
        }
    }
    
    // MARK: - Notification Handling
    
    /**
     This method refresh the contents when device rotates
     
     */
    func deviceRotated() {
        // TODO: optimise this
        self.removeConstraints(self.constraints)
        let subViews = self.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }
        layoutIfNeeded()
        populateDetails()
        addToParent()
        layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    /**
     This method removes RRBannerView from parent view
     
     - parameter sender: UITapGestureRecognizer.
     */
    func dissmissSelf(_ sender: UITapGestureRecognizer) {
        timer?.invalidate()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (success: Bool) -> Void in
            NotificationCenter.default.removeObserver(self)
            self.removeFromSuperview()
        }) 
    }
    
    /**
     This method adds tap gesture to RRBannerView
     
     */
    fileprivate func addTapgesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RRBannerView.dissmissSelf(_:)))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    /**
     This method adds RRBannerView to parent view
     
     */
    fileprivate func addToParent() {
        let views : [String : AnyObject] = ["self": self, "parentView": parentView!]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[self]-0-|", options: [.alignAllCenterY], metrics: nil, views: views)
        switch(position) {
        case .top:
            allConstraints += NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(\(defaultPadding))-[self(\(bannerViewHeight))]", options: [], metrics: nil,views: views)
            break
        case .middle:
            // TODO: Add visual constraint
            allConstraints += [NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: parentView!, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)]
            allConstraints += [NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: bannerViewHeight)]
            break
        case .bottom:
            allConstraints += NSLayoutConstraint.constraints(
                withVisualFormat: "V:[self(\(bannerViewHeight))]-0-|", options: [], metrics: nil,views: views)
            break
        }
        NSLayoutConstraint.activate(allConstraints)
    }
    
    fileprivate func addTitleLabel(_ titleLabel: UILabel, containerView: UIView) -> (titleLabel: UILabel, labelHeight: CGFloat) {
        let leftPadding = image == nil ? defaultPadding : defaultPadding + imageViewSize + defaultPadding
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.font = titleFont
        titleLabel.numberOfLines = maxLineLimitForTitle
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        let views = ["titleLabel" : titleLabel, "containerView" : containerView]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(\(leftPadding))-[titleLabel]-(\(defaultPadding))-|", options: [.alignAllCenterY], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(\(defaultPadding))-[titleLabel]", options: [], metrics: nil,views: views)
        NSLayoutConstraint.activate(allConstraints)
        titleLabel.text = title
        
        let paddingForHeight = image == nil ? defaultPadding * 4 : defaultPadding * 5 + imageViewSize
        titleLabel.frame = CGRect(x: 0, y: 0, width: (parentView?.frame.width)! - paddingForHeight, height: CGFloat.greatestFiniteMagnitude)
        titleLabel.sizeToFit()
        
        return (titleLabel: titleLabel, labelHeight: titleLabel.frame.height)
    }
    
    fileprivate func addMessageTextView(_ titleLabel: UILabel, containerView: UIView) -> CGFloat {
        let messageTextView: UITextView = UITextView(frame: .zero)
        let leftPadding = image == nil ? defaultPadding : defaultPadding + imageViewSize + defaultPadding
        var textViewHeight: CGFloat = 0
        messageTextView.frame = CGRect(x: 0, y: 0, width: (parentView?.frame.width)! - (image == nil ? defaultPadding * 4 : defaultPadding * 5 + imageViewSize), height: parentView!.frame.height)
        messageTextView.isEditable = false
        messageTextView.font = messageFont
        messageTextView.textAlignment = .center
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageTextView)
        let views = ["titleLabel" : titleLabel, "containerView" : containerView, "messageTextView" : messageTextView]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-\(leftPadding)-[messageTextView]-(\(defaultPadding))-|", options: [.alignAllCenterY], metrics: nil, views: views)
        if let title = title, title.characters.count > 0 {
            allConstraints +=  NSLayoutConstraint.constraints(
                withVisualFormat: "V:[titleLabel]-(\(interMessagePadding))-[messageTextView]", options: [], metrics: nil,views: views)
        }
        else {
            allConstraints += NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(\(defaultPadding))-[messageTextView]", options: [], metrics: nil,views: views)
        }
        messageTextView.text = message
        let maxTextViewHeight: CGFloat = parentView!.frame.height * 0.60
        let contentSize = messageTextView.sizeThatFits(messageTextView.bounds.size)
        textViewHeight = maxTextViewHeight > contentSize.height ? contentSize.height : maxTextViewHeight
        var frame = messageTextView.frame
        frame.size.height = textViewHeight
        messageTextView.frame = frame
        allConstraints += [NSLayoutConstraint(item: messageTextView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: textViewHeight)]
        NSLayoutConstraint.activate(allConstraints)
        messageTextView.isScrollEnabled = (contentSize.height >= maxTextViewHeight) ? true : false
        return textViewHeight
    }
    
    fileprivate func addImageView(_ containerView: UIView) {
        let imageView = UIImageView(frame: .zero)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        let views = ["imageView" : imageView, "containerView" : containerView]
        var allConstraints = [NSLayoutConstraint]()
        if title?.characters.count == 0 && message?.characters.count == 0 {
            //allConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(defaultPadding)-[imageView(\(imageViewSize))]", options: [.AlignAllCenterY], metrics: nil, views: views)
            
            // TODO: Add visual constraint
            allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)]
            allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: imageViewSize)]
            NSLayoutConstraint.activate(allConstraints)
        }
        else {
            allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(defaultPadding)-[imageView(\(imageViewSize))]", options: [.alignAllCenterY], metrics: nil, views: views)
        }
        
        // TODO: Add visual constraint
        allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)]
        allConstraints += [NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: imageViewSize)]
        NSLayoutConstraint.activate(allConstraints)
        
    }
    
    fileprivate func addContainerView() -> UIView {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addShadow()
        addSubview(containerView)
        let views : [String : AnyObject] = ["self": self, "containerView": containerView]
        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(defaultPadding))-[containerView]-(\(defaultPadding))-|", options: [.alignAllCenterY], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(defaultPadding))-[containerView]-(\(defaultPadding))-|", options: [], metrics: nil,views: views)
        NSLayoutConstraint.activate(allConstraints)
        return containerView
    }
    
    /**
     This method populates RRBannerView. It adds title, message and image to be shown on banner.
     
     */
    fileprivate func populateDetails() {
        var titleLabel: UILabel = UILabel(frame: .zero)
        
        var textViewHeight: CGFloat = 0
        var titleLabelHeight: CGFloat = 0
        var interMessagePadding: CGFloat = 0
        let containerView = addContainerView()
        
        // Add message text if given
        if let title = title, title.characters.count > 0 {
            let titleTuple = addTitleLabel(titleLabel, containerView: containerView)
            titleLabel = titleTuple.titleLabel
            titleLabelHeight = titleTuple.labelHeight
            interMessagePadding = self.interMessagePadding
        }
        // Add message text if given
        if let message = message, message.characters.count > 0 {
            textViewHeight = addMessageTextView(titleLabel, containerView: containerView)
        }
        // Add image if given
        if let _ = image {
            addImageView(containerView)
        }
        // Calclating view height
        let viewHeight: CGFloat = 4 * defaultPadding + titleLabelHeight + interMessagePadding + textViewHeight
        bannerViewHeight = viewHeight > parentView!.frame.height ? parentView!.frame.height : viewHeight
        bannerViewHeight = (bannerViewHeight >= miniBannerHeight) ? bannerViewHeight : miniBannerHeight
    }
}

private extension UIView {
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0), shadowOpacity: Float = 0.4, shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
