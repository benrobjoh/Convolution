//: Playground - noun: a place where people can play

import UIKit
import CoreImage

let image = UIImage(named: "tech-tower")
let inputImage = CIImage(CGImage: image?.CGImage)

let grayFilter = CIFilter(name: "CIColorMonochrome")
grayFilter.setValue(inputImage, forKey: "inputImage")
grayFilter.setValue(CIColor(CGColor: UIColor.grayColor().CGColor), forKey: "inputColor")
let grayOutput = UIImage(CIImage: grayFilter.outputImage)

let filter = CIFilter(name: "CIConvolution3X3")
let attributes = filter.attributes()
filter.setValue(inputImage, forKey: "inputImage")
//let weight: [CGFloat] = [1.0, 0.0, -1.0, 2.0, 1.0, -2.0, 1.0, 0.0, -1.0]
//let weight: [CGFloat] = [-2.0, -2.0, 0.0, -2.0, 6.0, 0.0, 0.0, 0.0, 0.0]
//filter.setValue(NSNumber(float: 0.5), forKey: "inputBias")
let weight: [CGFloat] = [1.0, 1.0, 1.0, 1.0, -7.0, 1.0, 1.0, 1.0, 1.0]
let vector = CIVector(values: weight, count: 9)
filter.setValue(vector, forKey: "inputWeights")
let output = UIImage(CIImage: filter.outputImage)


let alphaFilter = CIFilter(name: "CIColorMatrix")
alphaFilter.setValue(filter.outputImage, forKey: "inputImage")
let alpha: [CGFloat] = [0.0, 0.0, 0.0, 1.0]
alphaFilter.setValue(CIVector(values: alpha, count: 4), forKey: "inputAVector")
let alphaOutput = UIImage(CIImage: alphaFilter.outputImage)
