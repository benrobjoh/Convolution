//: Playground - noun: a place where people can play

import UIKit
import CoreImage

let image = UIImage(named: "tech-tower")
let inputImage = CIImage(CGImage: image?.CGImage)

let filter = CIFilter(name: "CIConvolution3X3")
let attributes = filter.attributes()
filter.setValue(inputImage, forKey: "inputImage")
//let weight: [CGFloat] = [1.0, 0.0, -1.0, 2.0, 1.0, -2.0, 1.0, 0.0, -1.0]
let weight: [CGFloat] = [1.0, 1.0, 1.0, 1.0, -7.0, 1.0, 1.0, 1.0, 1.0]
let vector = CIVector(values: weight, count: 9)
filter.setValue(vector, forKey: "inputWeights")
let output = UIImage(CIImage: filter.outputImage)
