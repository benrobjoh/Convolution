//
//  Extensions.swift
//  Convolution
//
//  Created by Ben Johnson on 4/17/15.
//  Copyright (c) 2015 Bixelcog LLC. All rights reserved.
//

import Foundation

extension NSScanner {
    func scanFloat() -> Float? {
        var value: Float = 0.0
        if scanFloat(&value) {
            return value
        }
        return nil
    }
}