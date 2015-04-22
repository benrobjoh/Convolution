//
//  FilterTableViewController.swift
//  Convolution
//
//  Created by Ben Johnson on 4/17/15.
//  Copyright (c) 2015 Bixelcog LLC. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    @IBOutlet private weak var filterTextField: UITextField!
    @IBOutlet private weak var blackAndWhiteSwitch: UISwitch!

    @IBOutlet private weak var kernel00: UITextField!
    @IBOutlet private weak var kernel01: UITextField!
    @IBOutlet private weak var kernel02: UITextField!
    @IBOutlet private weak var kernel10: UITextField!
    @IBOutlet private weak var kernel11: UITextField!
    @IBOutlet private weak var kernel12: UITextField!
    @IBOutlet private weak var kernel20: UITextField!
    @IBOutlet private weak var kernel21: UITextField!
    @IBOutlet private weak var kernel22: UITextField!
    
    var filter: Filter? {
        didSet {
            if filter != nil && isViewLoaded() {
                updateFilterCells()
            }
        }
    }
    
    var filterChangeHandler: (Filter -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFilterCells()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateFilter()
        filter.map { filterChangeHandler?($0) }
    }
    
    // MARK: Update Model
    func updateFilter() {
        if let filterToEdit = filter {
            filterToEdit.name = filterTextField.text
            filterToEdit.grayscale = blackAndWhiteSwitch.on
            
            let component00 = NSScanner(string: kernel00.text).scanFloat()
            let component01 = NSScanner(string: kernel01.text).scanFloat()
            let component02 = NSScanner(string: kernel02.text).scanFloat()
            let component10 = NSScanner(string: kernel10.text).scanFloat()
            let component11 = NSScanner(string: kernel11.text).scanFloat()
            let component12 = NSScanner(string: kernel12.text).scanFloat()
            let component20 = NSScanner(string: kernel20.text).scanFloat()
            let component21 = NSScanner(string: kernel21.text).scanFloat()
            let component22 = NSScanner(string: kernel22.text).scanFloat()
            
            let computedKernel = [component00, component01, component02, component10, component11, component12, component20, component21, component22]
            let finalKernel = computedKernel.filter { $0 != nil }.map { CGFloat($0!) }
            assert(finalKernel.count == 9)
            filterToEdit.kernel = finalKernel
        }
    }
    
    func updateFilterCells() {
        if let filterToEdit = filter {
            filterTextField.text = filterToEdit.name
            blackAndWhiteSwitch.on = filterToEdit.grayscale
            
            kernel00.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[0], numberStyle: .DecimalStyle)
            kernel01.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[1], numberStyle: .DecimalStyle)
            kernel02.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[2], numberStyle: .DecimalStyle)
            kernel10.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[3], numberStyle: .DecimalStyle)
            kernel11.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[4], numberStyle: .DecimalStyle)
            kernel12.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[5], numberStyle: .DecimalStyle)
            kernel20.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[6], numberStyle: .DecimalStyle)
            kernel21.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[7], numberStyle: .DecimalStyle)
            kernel22.text = NSNumberFormatter.localizedStringFromNumber(filterToEdit.kernel[8], numberStyle: .DecimalStyle)
        }
    }
}
