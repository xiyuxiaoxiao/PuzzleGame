//
//  BlurImageView.swift
//  ShouXinSwift
//
//  Created by Vanguard on 16/3/24.
//  Copyright © 2016年 ShouXinTech.Inc. All rights reserved.
//

import UIKit

class BlurImageView: UIImageView {

    @IBOutlet var view: UIView!

    
    // 默认alpha ＝ 0
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
//    override func awakeFromNib() {
//        NSBundle.mainBundle().loadNibNamed("BlurImageView", owner: self, options: nil)
//        self.addSubview(self.view)
//    }
    
    func resetFrame(_ frame: CGRect) {
//        var rect = frame
//        rect.origin.x = 0
//        rect.origin.y = 0
//        self.view.frame = rect
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initFromXB()
    }
    
    // 代码创建
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initFromXB()
    }
    
    func initFromXB() {
        let boundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BlurImageView", bundle: boundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        self.addSubview(view)
    }
 

}
