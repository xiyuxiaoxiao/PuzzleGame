//
//  JigsawPuzzleImageView.swift
//  ShouXinSwift
//
//  Created by Vanguard on 16/2/27.
//  Copyright © 2016年 ShouXinTech.Inc. All rights reserved.
//

import UIKit

class JigsawPuzzleImageView: UIImageView {

    var puzzleImage: UIImage!
    var numberArray: [Int]!
    var row: Int!
    var column: Int!
    var jigsawPuzzlePhoto: JigsawPuzzlePhoto!
    
    // 模型
    fileprivate var jigsawModelArray = [JigsawModel]()
    
    var selectImageView: UIImageView?   // 选中的imageView
    var selectIndex: Int?               // 选中的imageView的下标
    var selectModel: JigsawModel?       // 选中的模型
    
    
    // 存放每个imageView 放在数组中
    var imageViewArray = [UIImageView]()
    
    var puzzleSuccessBlock: (()->Void)! // 成功的回调
    

    var imageViewFrame: CGRect!
    
    var dismissBlock: (() -> Void)!
    var portraitImage: UIImage?
    
    
    // 自动恢复的时候，是否进行网络请求
    var superPowerNewwork = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, imageViewFrame: CGRect, image: UIImage, row: Int, column: Int, numberArray: [Int], jigsawPuzzlePhoto: JigsawPuzzlePhoto, portraitImage: UIImage?) {
        self.init(frame: frame)
        self.puzzleImage = image
        self.row = row
        self.column = column
        self.numberArray = numberArray
        self.imageViewFrame = imageViewFrame
        self.portraitImage = portraitImage
        self.jigsawPuzzlePhoto = jigsawPuzzlePhoto
        
        self.addView()
    }
    
    convenience init(frame: CGRect, imageViewFrame: CGRect, image: UIImage, jigsawPuzzlePhoto: JigsawPuzzlePhoto, portraitImage: UIImage?) {
        
        let row = jigsawPuzzlePhoto.row?.intValue
        let column = jigsawPuzzlePhoto.column?.intValue
        let numberArray = jigsawPuzzlePhoto.numberArray
        
        self.init(frame: frame, imageViewFrame: imageViewFrame, image: image, row: row!, column: column!, numberArray: numberArray!, jigsawPuzzlePhoto: jigsawPuzzlePhoto, portraitImage: portraitImage)
    }
    
    
    func addView() {
        
        jigsawModelArray = JigsawModel.creatModelArray(bounds, image: puzzleImage, row: row, column: column, numberArray: numberArray)
        
        for i in 0 ..< jigsawModelArray.count {
            
            let model = jigsawModelArray[i]
            
            let imageView =  UIImageView(frame: model.frame!)
            imageView.image = model.image
            imageViewArray.append(imageView)
            addSubview(imageView)
        }
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(JigsawPuzzleImageView.handPanGR(_:)))
        addGestureRecognizer(panGR)
    }
    
    /*
    设置当前imageView的frame  （此处是设置为正方形，然后让图片按比例填充，最后计算出图片真实占的frame
    如果不需要按比例填充，而是全部展示， 则可以直接返回所需的frame
    */
    
    
    func handPanGR(_ panGR: UIPanGestureRecognizer) {
        
        
        let point = panGR.location(in: self)
        
        if (panGR.state == UIGestureRecognizerState.began) {
            
            if let i = getImageViewIndexByPoint(point) {
                setSelectedImageViewByIndex(i)
            }
        }
        
        if selectIndex == nil {
            return
        }
        
        
        if (panGR.state == UIGestureRecognizerState.ended) {
            
            if let i = getImageViewIndexByPoint(point) {
                
                if i != selectIndex {
                    // 判断一下距离两点的距离 是否小于一个数来交换
                    
                    let modelFrame = jigsawModelArray[i].frame!
                    
                    
                    let centerX = modelFrame.origin.x + modelFrame.width / 2
                    let centerY = modelFrame.origin.y + modelFrame.height / 2
                    
                    let distanceSqrt = sqrt(pow(point.x - centerX, 2) + pow(point.y - centerY, 2))
                    
                    if distanceSqrt < sqrt(pow(modelFrame.width / 2, 2)) {
                        
                        setImageViewByModel(selectIndex!, jigsawModel: jigsawModelArray[i])
                        
                        setImageViewByModel(i, jigsawModel: selectModel)
                        
                        // selectIndex = i   除非在移动的时候需要重新指定，因为是结束
                        // 如果在移动过程中 切换，则需要在指定
                        
                        removeSelectImageView()
                        
                        if puzzleSucceeded() {
                            puzzleSuccessBlock()
                        }
                        return
                    }
                    
                    
                }
                
            }
            
            setImageViewByModel(selectIndex!, jigsawModel: selectModel)
            
            removeSelectImageView()
            
        } else {
            self.selectImageView?.center = point
            
        }
        
    }
    
    
    // 设置当前选中的view
    func setSelectedImageViewByIndex(_ i: Int) {
        
        let model = jigsawModelArray[i]
        // 不能交换模型 因为frame不变
        selectImageView = UIImageView(frame: model.frame!)
        selectImageView?.image = model.image
        addSubview(selectImageView!)
        
        selectIndex = i
        // 不能直接赋值 不然会指向同一个地址（selectModel ＝ model）
        selectModel = JigsawModel(image: model.image, frame: model.frame, index: model.index)
        setImageViewByModel(i, jigsawModel: nil)
    }
    
    // 设置数据
    func setImageViewByModel(_ index: Int, jigsawModel: JigsawModel?) {
        
        // 修改UI
        let imageView = getImageViewFromIndex(index)
        imageView?.image = jigsawModel?.image
        
        // 修改数据源
        let model = jigsawModelArray[index]
        model.image = jigsawModel?.image
        model.index = jigsawModel?.index
    }
    
    func removeSelectImageView() {
        selectImageView?.removeFromSuperview()
        selectImageView = nil
        selectModel = nil
        selectIndex = nil
    }
    
    
    func getImageViewIndexByPoint(_ point: CGPoint) -> Int?{
        for i in 0 ..< jigsawModelArray.count {
            if jigsawModelArray[i].frame!.contains(point) {
                return i
            }
        }
        
        return nil
    }
    
    func getImageViewFromIndex(_ index: Int) -> UIImageView? {
        return imageViewArray[index]
    }
    
    
    func puzzleSucceeded() -> Bool{
        
        for i in 0 ..< jigsawModelArray.count {
            let model = jigsawModelArray[i]
            
            if model.index != i {
                return false
            }
        }
        
        
        return true
    }
    

}

extension JigsawPuzzleImageView {
    
    // 自动恢复
    func superPower() {
        kaigua(0)
    }
    
    func superPowerNeewNewwork() {
        superPowerNewwork = true
        kaigua(0)
    }
    
    func kaigua(_ i: Int) {
        // 自动还原
        
        if i < numberArray.count {
            let index = getNumberArrayIndex(i)
            if i == index {
                self.kaigua(i + 1)
            } else {
                
                // 交换 index 起始的
                setSelectedImageViewByIndex(index)
                moveFromeIndex(index, toIndex: i)
            }
        }
        
    }
    
    func moveFromeIndex(_ index: Int, toIndex: Int) {
        
        let frame =  self.jigsawModelArray[toIndex].frame
        UIView.animate(withDuration: 0.08, animations: { () -> Void in
            
            if frame != nil {
                self.selectImageView?.frame = frame!
            }
            
            }, completion: { (finished) -> Void in
                self.setImageViewByModel(index, jigsawModel: self.jigsawModelArray[toIndex])
                
                self.setImageViewByModel(toIndex, jigsawModel: self.selectModel)
                self.removeSelectImageView()
                // 成功了 但是不发网络请求，只是本地查看
                
                if  self.superPowerNewwork {
                    if self.puzzleSucceeded() {
                        self.puzzleSuccessBlock()
                    }
                }
                
                self.kaigua(toIndex + 1)
        }) 
        
    }
    
    func getNumberArrayIndex(_ i: Int) -> Int {
        for j in i ..< jigsawModelArray.count {
            
            if jigsawModelArray[j].index == i {
                return j
            }
        }
        
        // 不可能执行到此处
        return 0
    }
}
