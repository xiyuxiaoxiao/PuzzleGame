//
//  JigsawPuzzleView2.swift
//  ShouXinSwift
//
//  Created by Vanguard on 16/2/27.
//  Copyright © 2016年 ShouXinTech.Inc. All rights reserved.
//

import UIKit

var JigsawPuzzleSucceedNotificationKey = "JigsawPuzzleSucceedNotificationKey"

var TopViewBackColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 36/255.0, alpha: 1)
class JigsawPuzzleView: UIView {

    
    var puzzleImage: UIImage!
    var numberArray: [Int]!
    var row: Int!
    var column: Int!
    var jigsawPuzzlePhoto: JigsawPuzzlePhoto!

    
    var puzzleSuccessBlock: (()->Void)! // 成功的回调
    
    var photo: Photo? {
        didSet {
            
//            topView.text = photo?.user?.getNicknameOrUsername()
            addPuzzledSucceededUser()
        }
    }
    
    var topView: UILabel!
    var buttomView: UIView!
    
//    var portraitBlock: ((user: AVUser) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, row: Int, column: Int, numberArray: [Int], jigsawPuzzlePhoto: JigsawPuzzlePhoto, portraitImage: UIImage?) {

        self.init(frame: JigsawPuzzleView.viewFrame())
        self.puzzleImage = image
        self.row = row
        self.column = column
        self.numberArray = numberArray

        self.jigsawPuzzlePhoto = jigsawPuzzlePhoto
        
        addTopView()
        addJigsawPuzzleImageView()
        addButtomView()
    }
    
    convenience init(image: UIImage, jigsawPuzzlePhoto: JigsawPuzzlePhoto, portraitImage: UIImage?) {
        
        let row = jigsawPuzzlePhoto.row?.intValue
        let column = jigsawPuzzlePhoto.column?.intValue
        let numberArray = jigsawPuzzlePhoto.numberArray
        
        self.init(image: image, row: row!, column: column!, numberArray: numberArray!, jigsawPuzzlePhoto: jigsawPuzzlePhoto, portraitImage: portraitImage)
    }
    
    func addTopView() {
        
        topView = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: JigsawPuzzleView.topViewHeight()))
        topView.backgroundColor = TopViewBackColor
        addSubview(topView)
        
        let bezirepath = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight] , cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = topView.bounds
        maskLayer.path = bezirepath.cgPath
        topView.layer.mask = maskLayer
        
        topView.textAlignment = .center
        topView.textColor = UIColor.white
        
    }
    
    func addButtomView() {
        
        buttomView = UIView(frame: CGRect(x: 0, y: JigsawPuzzleView.viewFrame().height - JigsawPuzzleView.buttomViewHeight(), width: frame.width, height: JigsawPuzzleView.buttomViewHeight()))
        buttomView.backgroundColor = TopViewBackColor
        addSubview(buttomView)
        
        let bezirepath = UIBezierPath(roundedRect: buttomView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight] , cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = buttomView.bounds
        maskLayer.path = bezirepath.cgPath
        buttomView.layer.mask = maskLayer
        
    }
    
    func addJigsawPuzzleImageView() {
        
        let jigsawPuzzleImageView = JigsawPuzzleImageView(frame: CGRect(x: 0, y: JigsawPuzzleView.topViewHeight(), width: frame.width, height: frame.width))
        jigsawPuzzleImageView.row = row
        jigsawPuzzleImageView.column = column
        jigsawPuzzleImageView.numberArray = numberArray
        jigsawPuzzleImageView.jigsawPuzzlePhoto = jigsawPuzzlePhoto
        jigsawPuzzleImageView.puzzleImage = puzzleImage
        jigsawPuzzleImageView.puzzleSuccessBlock =  {
            self.puzzleSuccessBlock()
        }
        
        jigsawPuzzleImageView.addView()
        addSubview(jigsawPuzzleImageView)

        if (UserDefault .getPermission()) {
            // 添加自动还原权限
            let button = UIButton(type: .system)
            button.frame = CGRect(x: frame.width - 50, y: 10 , width: 40, height: 20)
            button.setTitle("超级", for: UIControlState())
            button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.layer.cornerRadius = 5
            addSubview(button)
            
            button.addTarget(jigsawPuzzleImageView, action: "superPower", for: UIControlEvents.touchUpInside)
            
            let superButton2 = UIButton(type: .system)
            superButton2.frame = CGRect(x: frame.width - 140, y: 10 , width: 80, height: 20)
            superButton2.setTitle("超级server", for: UIControlState())
            superButton2.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            superButton2.setTitleColor(UIColor.white, for: UIControlState())
            superButton2.layer.cornerRadius = 5
            addSubview(superButton2)
            
            superButton2.addTarget(jigsawPuzzleImageView, action: "superPowerNeewNewwork", for: UIControlEvents.touchUpInside)
        }
        
        
        
    }
    
    
    func addPuzzledSucceededUser() {
        
    }
    
    class func viewFrame() -> CGRect {
        // 固定写死
        let topHeight = topViewHeight()
        let buttomHeight = buttomViewHeight()
        
        let bothSpace: CGFloat = 20        //  屏幕两边间距
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let width = screenWidth - bothSpace * 2
        let height = width + topHeight + buttomHeight
        
        let y = (screenHeight - height) / 2

        return CGRect(x: bothSpace, y: y, width: width, height: height)
    }
    
    class func topViewHeight() -> CGFloat {
        return 40
    }
    class func buttomViewHeight() -> CGFloat {
        return 40
    }
    
    class func ddddd(_ suss: (_ s: Int?)->Void) {
        
    }

}

extension JigsawPuzzleView {
    
    // 调用前  先判断时候是拼图（否则就要在里面进行判断）
/*
     class func addJigsawPuzzleView(viewController: UIViewController, image: UIImage, photo: Photo, succeededBlock: (rank: Int?, count: Int) -> Void)
     当参数有block的时候 则oc中无法调用
*/
    class func addJigsawPuzzleView(_ viewController: UIViewController, image: UIImage, photo: Photo) {
        
        
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.slide)
        
        // 模糊view
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(visualEffectView)
        
        let jigsawView = JigsawPuzzleView(image: image, jigsawPuzzlePhoto: photo.jigsawPuzzle!, portraitImage: nil)
        jigsawView.photo = photo
        jigsawView.puzzleSuccessBlock = {
            
            visualEffectView.removeFromSuperviewAnimateWithDuration(0.5)
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
            photo.jigsawPuzzle?.puzzleSucceed = true
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: JigsawPuzzleSucceedNotificationKey), object: nil, userInfo: nil)
            // 成功
            jigsawView.removeFromSuperview()
        }
        
        visualEffectView.addSubview(jigsawView)
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(JigsawPuzzleView.dismissTapped(_:)))
        visualEffectView.addGestureRecognizer(dismissTap)
    }
    
    
    class func dismissTapped(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: tap.view)
        
        // 这里需要计算出如果是按比例的 实际image占的frame
        if !JigsawPuzzleView.viewFrame().contains(point) {
            
            tap.view?.removeFromSuperviewAnimateWithDuration(0.3)
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        }
    }
   
}

extension UIView {
    
    func removeFromSuperviewAnimateWithDuration(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = 0
            }, completion: { (finished) -> Void in
                if finished {
                    self.removeFromSuperview()
                }
        })
    }
    
    func shakeToShow() {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.2
        
        var values = [NSValue]()
        
        _ = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        let value2 = NSValue(caTransform3D: CATransform3DMakeScale(0.4, 0.4, 1.0))
        let value3 = NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0))
        let value4 = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        //        values.append(value1)
        values.append(value2)
        values.append(value3)
        values.append(value4)
        animation.values = values
        layer.add(animation, forKey: nil)
    }
}
