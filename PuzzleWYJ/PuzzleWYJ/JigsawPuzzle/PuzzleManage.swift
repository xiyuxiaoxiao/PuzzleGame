//
//  PuzzleManage.swift
//  ShouXinSwift
//
//  Created by Vanguard on 16/2/20.
//  Copyright © 2016年 ShouXinTech.Inc. All rights reserved.
//

import UIKit
//import SDWebImage

protocol PuzzleManageDeledate {
    func puzzleImage(_ image: UIImage);
}

class PuzzleManage: NSObject {
    
    var imageViewFrame: CGRect!
    var image: UIImage!
    
    var row: Int!
    var line: Int!
    
    var originX: CGFloat = 0
    var originY: CGFloat = 0
    
    var width: CGFloat!
    var height: CGFloat!
    
    
    var deledate: PuzzleManageDeledate?

    // 裁减 image 根据序列 numberArray
    func imageArrayByCropping(_ imageToCrop: UIImage, numberArray: [Int], row: Int, line: Int) -> [UIImage] {
        
        
        // 得到一个最大值为切成图片数量－1的随机数组
        //        let randomNumbers = getRandomNumbersArray(numberOfImages.rawValue)
        let randomNumbers = numberArray
        
        var regularImageArray = [UIImage]()
        var randomImageArray = [UIImage]()
        
        
        UIGraphicsBeginImageContextWithOptions(imageToCrop.size, false, UIScreen.main.scale)
        
        
        for i in 0 ..< row {
            for j in 0 ..< line {
                
                // 如果图片压缩过的话 可能裁剪出来的是按照之前的像素裁剪的，结果会不一样，所以应该使用绘图的方式得到新的image在去裁剪
                let width = imageToCrop.size.width/CGFloat(line) * imageToCrop.scale
                let height = imageToCrop.size.height/CGFloat(row) * imageToCrop.scale
                
                let rect = CGRect(x: CGFloat(j)*width, y: CGFloat(i)*height, width: width, height: height)
                
                // Create bitmap image from context using the rect
                let imageRef: CGImage = imageToCrop.cgImage!.cropping(to: rect)!
                
                // Create a new image based on the imageRef and rotate back to the original orientation
                let croppedImage = UIImage(cgImage: imageRef)
                
                regularImageArray.append(croppedImage)
            }
        }
        
        
        for i in 0 ..< numberArray.count {
            
            randomImageArray.append(regularImageArray[randomNumbers[i]])
        }
        
        UIGraphicsEndImageContext()
        
        return randomImageArray
    }
    
    //MARK: 将一个frame分割为row行 line列
    func calculateFrameWithFrame(_ frameW: CGFloat, frameH: CGFloat, row: Int, line: Int!) -> [CGRect]{
        
        // 这是设置每个拼图间的水平和垂直间距
        let horizontalSpace: CGFloat = 0.5
        let verticalSpace: CGFloat = 0.5
        
        let oneSizeWidth = (frameW - (CGFloat(line) - 1) * horizontalSpace) / CGFloat(line)
        let oneSizeHeight = (frameH - (CGFloat(row) - 1) * verticalSpace) / CGFloat(row)
        
        
        var frameArray = [CGRect]()
        
        for i in 1 ..< row+1  {
            
            for j in 1 ..< line+1 {
                
                let x = CGFloat(j - 1) * (oneSizeWidth + horizontalSpace) + originX
                let y = CGFloat(i - 1) * (oneSizeHeight + verticalSpace) + originY
                
                let frame = CGRect(x: x, y: y, width: oneSizeWidth, height: oneSizeHeight)
                frameArray.append(frame)
            }
        }
        
        return frameArray
    }
    
    func getRandomNumbersArray(_ maxNumber: Int) -> [Int] {
 
        var remainingNumbers: [Int] = []
        var randomNumbers: [Int] = []
        
        for i in 0 ..< maxNumber {
            remainingNumbers.append(i)
        }
        
        for i in 0 ..< maxNumber - 1 {
            let maxIndex: Int = remainingNumbers.count - 1
            
            //随机数
            let count = UInt32(maxIndex)
            let randomNumber = Int(arc4random_uniform(count))
            // 不适用于5 以下的处理器
            // let randomNumber = Int(arc4random()) % maxIndex
            
            randomNumbers.append(remainingNumbers[randomNumber])
            remainingNumbers.remove(at: randomNumber)
            
        }
        
        randomNumbers.append(remainingNumbers[0])
        
        return randomNumbers
    }

    
    // 创建数组套数组来表示二维(设置了row和column)，便可以只用1维数组来表示le
    func getFrame(_ numberarray: [Int], row: Int!, line: Int) -> [AnyObject]{
        
        var numberRArray = [AnyObject]()
        for i in 0 ..< row {
            
            var numberLArray = [Int]()
            for j in 0 ..< line {
                let number = numberarray[i * line + j]
                numberLArray.append(number)
            }
            
            numberRArray.append(numberLArray as AnyObject)
        }
        
        return numberRArray
    }
    
    func puzzleImageView(_ imageView: UIImageView, image: UIImage, size: CGSize, photo2: Photo) {
        if photo2.jigsawPuzzle == nil {
            return
        }
        
        let jigsawPuzzle = photo2.jigsawPuzzle!
        if jigsawPuzzle.puzzleSucceed == true {
            return
        }
        // 不设置nil的话，有可能会使得展示了原图后，再去展示拼图
        imageView.image = UIImage(named: "puzzleDefault")
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
//        
//            let row = jigsawPuzzle.row!.integerValue
//            let column = jigsawPuzzle.column!.integerValue
//            let numberArray = jigsawPuzzle.numberArray!
//            
//            
//            let jigsawImage = PuzzleManage.getComposeImage(size, image: image, row: row, column: column, numberArray: numberArray)
//            
//            self.deledate?.puzzleImage(jigsawImage)
//        }
        
        var url = photo2.imageURL
        
        if (url != nil) {
            url = url! + "PuzzleURL"
        }
        if url == nil {
            return
            return
        }
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { () -> Void in
            
        let cacheImage = SDImageCache.shared().imageFromMemoryCache(forKey: url)
        if cacheImage != nil {
            self.deledate?.puzzleImage(cacheImage!)
        } else {
                let row = jigsawPuzzle.row!.intValue
                let column = jigsawPuzzle.column!.intValue
                let numberArray = jigsawPuzzle.numberArray!
                
                
                let jigsawImage = PuzzleManage.getComposeImage(size, image: image, row: row, column: column, numberArray: numberArray)
                
            
                
                SDImageCache.shared().store(jigsawImage, forKey: url, toDisk: false)
            
                self.deledate?.puzzleImage(jigsawImage)
                
            }
          
        }
        
    }
    // 直接对imageView设置
    class func puzzleImageView(_ imageView: UIImageView, image: UIImage, size: CGSize, photo: Photo) {
        
        if photo.jigsawPuzzle == nil {
            return
        }
        
        let jigsawPuzzle = photo.jigsawPuzzle!
        if jigsawPuzzle.puzzleSucceed == true {
            return
        }
        // 不设置nil的话，有可能会使得展示了原图后，再去展示拼图
//        imageView.image = nil
        imageView.image = UIImage(named: "puzzleDefault")
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { () -> Void in
        
            let row = jigsawPuzzle.row!.intValue
            let column = jigsawPuzzle.column!.intValue
            let numberArray = jigsawPuzzle.numberArray!
            
            
            let jigsawImage = PuzzleManage.getComposeImage(size, image: image, row: row, column: column, numberArray: numberArray)
            
            DispatchQueue.main.async(execute: { () -> Void in
                imageView.image = jigsawImage
            })
        }

    }
    
    // 通过裁剪后字合并为新的图片
    class func getComposeImage(_ size: CGSize, image: UIImage, row: Int, column: Int, numberArray: [Int]) -> UIImage {


        let frameArray = PuzzleManage().calculateFrameWithFrame(image.size.width, frameH: image.size.height, row: row, line: column)
        
        let imageArray = PuzzleManage().imageArrayByCropping(image, numberArray: numberArray, row: row, line: column)
        
//        UIGraphicsBeginImageContext(image.size)
        // 使用iamge的大小绘制 这样出来的图片大小会小一点，按照大的size出来的也不会失真，但是大小会大一点
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        
        for i in 0 ..< numberArray.count {
            imageArray[i].draw(in: frameArray[i])
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
