//
//  Convolution.swift
//  Convolution
//
//  Created by Ben Johnson on 4/9/15.
//  Copyright (c) 2015 Bixelcog LLC. All rights reserved.
//

import UIKit

public struct Convolution {
    public let image: UIImage
    public let kernel: [CGFloat]
    
    var convolvedImage: UIImage {
        let inputImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CIConvolution3X3")
        filter.setValue(inputImage, forKey: "inputImage")
        assert(kernel.count == 9)
        let vector = CIVector(values: normalizedKernel, count: 9)
        filter.setValue(vector, forKey: "inputWeights")
        
        let context = CIContext(options: nil)
        let outputCGImage = context.createCGImage(filter.outputImage, fromRect: inputImage.extent())
        return UIImage(CGImage: outputCGImage) ?? image
    }
    
    var normalizedKernel: [CGFloat] {
        let sum = kernel.reduce(0, combine: +)
        let normalization: [CGFloat]
        if sum != 0 {
            normalization = kernel.map { $0 / sum }
        }
        else {
            normalization = kernel
        }
        return normalization
    }
}