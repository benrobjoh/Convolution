//
//  Convolution.swift
//  Convolution
//
//  Created by Ben Johnson on 4/9/15.
//  Copyright (c) 2015 Bixelcog LLC. All rights reserved.
//

import UIKit

struct Convolution {
    let image: UIImage
    let filter: Filter
    
    var convolvedImage: UIImage {
        let inputImage = CIImage(image: image)
        let context = CIContext(options: nil)
        let outputCGImage = context.createCGImage(filter.filteredImage(inputImage), fromRect: inputImage.extent())
        return UIImage(CGImage: outputCGImage) ?? image
    }
}

class Filter {
    var name: String
    var kernel: [CGFloat]
    var grayscale: Bool
    
    static var standardFilters: [Filter] {
        return [Filter.identityFilter, Filter.edgeFilter, Filter.diamondFilter, Filter.embossFilter]
    }
    
    init(kernel: [CGFloat], name: String = "Untitled", grayscale: Bool = false) {
        self.kernel = kernel
        self.name = name
        self.grayscale = grayscale
    }
    
    var normalizedKernel: [CGFloat] {
        let sum = kernel.reduce(0.0, combine: +)
        let normalization: [CGFloat]
        if sum != 0 {
            normalization = kernel.map { $0 / sum }
        }
        else {
            normalization = kernel
        }
        return normalization
    }
    
    var vector: CIVector {
        return CIVector(values: normalizedKernel, count: kernel.count)
    }
    
    func filteredImage(image: CIImage) -> CIImage {
        var output = convolutionFilter(forImage: image).outputImage
        if grayscale {
            output = grayFilter(forImage: output).outputImage
        }
        return output
    }
    
    private func convolutionFilter(forImage image: CIImage) -> CIFilter {
        let filter = CIFilter(name: "CIConvolution3X3")
        filter.setValue(image, forKey: "inputImage")
        assert(kernel.count == 9)
        let vector = CIVector(values: normalizedKernel, count: 9)
        filter.setValue(vector, forKey: "inputWeights")
        return filter
    }
    
    private func grayFilter(forImage image: CIImage) -> CIFilter {
        let grayFilter = CIFilter(name: "CIColorMonochrome")
        grayFilter.setValue(image, forKey: "inputImage")
        grayFilter.setValue(CIColor(CGColor: UIColor.grayColor().CGColor), forKey: "inputColor")
        return grayFilter
    }
}

extension Filter {
    static var identityFilter: Filter {
        return Filter(kernel: [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0], name: "Identity")
    }
    
    static var edgeFilter: Filter {
        return Filter(kernel: [1.0, 1.0, 1.0, 1.0, -7.0, 1.0, 1.0, 1.0, 1.0], name: "Edge")
    }
    
    static var embossFilter: Filter {
        return Filter(kernel: [-2.0, -2.0, 0.0, -2.0, 7.0, 0.0, 0.0, 0.0, 0.0], name: "Emboss", grayscale: true)
    }
    
    static var gaussianFilter: Filter {
        return Filter(kernel: [1.0, 2.0, 1.0, 2.0, 4.0, 2.0, 1.0, 2.0, 1.0], name: "Gaussian")
    }
    
    static var diamondFilter: Filter {
        return Filter(kernel: [0.0, -2.0, 0.0, -2.0, 9.0, -2.0, 0.0, -2.0, 0.0], name: "Diamond")
    }
    
    static var specialFilter: Filter {
        return Filter(kernel: [-21.0, 0.0, 9.0, 0.0, 1.0, 0.0, 0.0, 0.0, 12.0], name: "My Filter")
    }
}