//
//  PhotoConfirmView.swift
//  J.Todo
//
//  Created by JinYoung Lee on 24/07/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoCropView : UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var foregroundView: UIImageView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cropAreaBottomConstraint: NSLayoutConstraint!
    
    private var superVC:UIViewController?
    private var circleLayer:CAShapeLayer?
    private var outsideLayer:CAShapeLayer?
    private var circleCenter:CGPoint?
    private var circleRadius:CGFloat?
    private var startPoint:CGPoint?
    private var startCircleRadius:CGFloat?
    private final let TopbarHeight:CGFloat = 69
    
    var ProcessListener: CroppingImageProtocol?
    
    override func awakeFromNib() {
        self.isHidden = false
        self.frame = (UIApplication.shared.keyWindow?.rootViewController?.view.frame)!
        
        if let window = UIApplication.shared.keyWindow {
            topBarHeightConstraint.constant = TopbarHeight + window.safeAreaInsets.top
            cropAreaBottomConstraint.constant = window.safeAreaInsets.bottom
        }
        initializeLayer()
        initializeImageView()
        initializeGestureRecognizer()
        localized()
    }
    
    private func initializeLayer() {
        circleLayer = CAShapeLayer()
        circleLayer?.lineWidth = 3
        circleLayer?.fillColor = UIColor.clear.cgColor
        circleLayer?.strokeColor = UIColor.white.cgColor
        
        outsideLayer = CAShapeLayer()
        outsideLayer?.frame = self.frame
        outsideLayer?.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor
        outsideLayer?.fillRule = CAShapeLayerFillRule.evenOdd
        
        foregroundView.isUserInteractionEnabled = false
        foregroundView.layer.addSublayer(circleLayer!)
        foregroundView.layer.addSublayer(outsideLayer!)
    }
    
    private func initializeImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.black
        imageView.addSubview(foregroundView)
    }
    
    private func initializeGestureRecognizer() {
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(onMoveCrop(gesture:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinchCrop(gesture:)))
        imageView.addGestureRecognizer(longPress)
        imageView.addGestureRecognizer(pinch)
        updatePathAtLocation(location: CGPoint(x:imageView.frame.width/2,y:imageView.frame.height/2), radius: imageView.frame.width * 0.25)
    }
    
    private func localized() {
        confirmButton.setTitle("select", for: .normal)
        cancelButton.setTitle("cancel", for: .normal)
        title.text = "crop photo"
    }
    
    func updatePathAtLocation(location:CGPoint, radius:CGFloat) {
        circleCenter = location
        circleRadius = radius

        let path:UIBezierPath = UIBezierPath(arcCenter: circleCenter!, radius: circleRadius!, startAngle: 0.0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
        let outsidePath:UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height) , cornerRadius: 0)
        outsidePath.append(path)
        
        circleLayer?.path = path.cgPath
        outsideLayer?.path = outsidePath.cgPath
    }

    @objc func onMoveCrop(gesture:UIPanGestureRecognizer) {
        if gesture.state == .began {
            startPoint = circleCenter!
        }
        
        let pointTranslation:CGPoint = gesture.translation(in: imageView)
        let movePosition:CGPoint = CGPoint(x: pointTranslation.x + (startPoint?.x)!, y: (startPoint?.y)! + pointTranslation.y)

        updatePathAtLocation(location: movePosition, radius: circleRadius!)
        
    }
    
    @objc func onPinchCrop(gesture:UIPinchGestureRecognizer) {
        if gesture.state == .began {
            startCircleRadius = circleRadius!
         }
        
        updatePathAtLocation(location: circleCenter!, radius: startCircleRadius! * gesture.scale)
    }
    
    func setImageInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        if let image:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        } else {
            hide()
        }
    }
    
    func revertImageLayer() {
        let center:CGPoint = CGPoint(x: circleCenter!.x, y: circleCenter!.y)
        let cropRect:CGRect = CGRect(x: center.x-circleRadius!, y: center.y-circleRadius!, width: circleRadius!*2, height: circleRadius!*2)
    
        UIGraphicsBeginImageContext(self.foregroundView.bounds.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.fill(cropRect)
        context.setFillColor(UIColor.black.withAlphaComponent(0.3).cgColor)
        context.setBlendMode(CGBlendMode.clear)
        context.fillEllipse(in: cropRect)

        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        self.foregroundView?.image = image
    }
    
    @IBAction func onClickConfirm(_ sender: Any) {
        let scale:CGFloat = (imageView.window?.screen.scale)!
        let radius:CGFloat = circleRadius! * scale
        let center:CGPoint = CGPoint(x: circleCenter!.x * scale, y: circleCenter!.y * scale)
        let cropRect:CGRect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2.0, height: radius * 2.0)
        
        circleLayer?.removeFromSuperlayer()
        outsideLayer?.removeFromSuperlayer()
        
        UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, false, 0.0);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        if imageView.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            context.setFillColor(UIColor.white.withAlphaComponent(0.3).cgColor)
            context.fill(cropRect)
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        } else {
            context.addArc(center: circleCenter!, radius: circleRadius!, startAngle: 0, endAngle: .pi * 2.0, clockwise: true)
            context.clip()
            imageView.layer.render(in: context)
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let imageRef:CGImage = image.cgImage!.cropping(to: cropRect)!
        let croppedImage:UIImage = UIImage(cgImage: imageRef)
        ProcessListener?.onCompleteWithImage(croppedImage)
        ProcessListener = nil
        hide()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        hide()
    }
    
    private func hide() {
        isHidden = true
        removeFromSuperview()
    }
}
