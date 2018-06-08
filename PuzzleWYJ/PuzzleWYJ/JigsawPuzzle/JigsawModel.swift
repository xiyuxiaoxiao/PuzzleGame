//
//  jigsawModel.swift
//  JigsawPuzzle
//
//  Created by Vanguard on 16/2/18.
//  Copyright © 2016年 ShouXinTech.Inc. All rights reserved.
//

import UIKit

class JigsawModel: NSObject {

    var image: UIImage?
    var frame: CGRect?
    var index: Int?
    
    init(image: UIImage?, frame: CGRect?, index: Int?) {
        super.init()
        self.image = image
        self.frame = frame
        self.index = index
    }
    
    convenience init(imageView: UIImageView?, index: Int?) {
        self.init(image: imageView?.image,frame: imageView?.frame, index: index)
    }
    
    
    class func creatModelArray(_ frame: CGRect, image: UIImage, row: Int, column: Int, numberArray: [Int]) -> [JigsawModel] {
        
        let puzleM = PuzzleManage()
        puzleM.originX = frame.origin.x
        puzleM.originY = frame.origin.y
        
        let frameArray = puzleM.calculateFrameWithFrame(frame.width, frameH: frame.height, row: row, line: column)
        
        let imageArray = PuzzleManage().imageArrayByCropping(image, numberArray: numberArray, row: row, line: column)
        
        var jigsawModelArray = [JigsawModel]()
        for i in 0 ..< frameArray.count {
            let image = imageArray[i]
            let frame = frameArray[i]
            let index = numberArray[i]
            
            let model = JigsawModel(image: image, frame: frame, index: index)
            
            jigsawModelArray.append(model)
        }
        
        return jigsawModelArray
        
    }
    
    
    // 计算imageView.contentMode = .ScaleAspectFit中 实际imageView在view中的大小frame
    class func imageRegion(_ imageViewFrame: CGRect, image: UIImage) -> CGRect {
        
        let scaleW = imageViewFrame.width / image.size.width
        let scaleH = imageViewFrame.height / image.size.height
        
        var width: CGFloat!
        var height: CGFloat!
        
        // 宽的比例大， 则高先充满
        if scaleW > scaleH {
            // 按照 height 与 height 的比例， 来计算width
            height = imageViewFrame.height
            width =  height * image.size.width / image.size.height
            
        } else {
            width = imageViewFrame.width
            height = width * image.size.height / image.size.width
        }
        
        
        var originX = imageViewFrame.origin.x
        var originY = imageViewFrame.origin.y
        if scaleW > scaleH {
            originX += (imageViewFrame.width - width) / 2
        } else {
            originY += (imageViewFrame.height - height) / 2
        }
        
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
}
