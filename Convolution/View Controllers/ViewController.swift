//
//  ViewController.swift
//  Convolution
//
//  Created by Ben Johnson on 4/9/15.
//  Copyright (c) 2015 Bixelcog LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewDelegate: protocol<UICollectionViewDataSource, UICollectionViewDelegate>? {
        didSet {
            collectionView.dataSource = collectionViewDelegate
            collectionView.delegate = collectionViewDelegate
        }
    }
    
    var imageToEdit: UIImage? {
        didSet {
            imageView.image = editedImage
            let delegate = imageToEdit.map { FilterCollectionViewDelegate(image: $0) }
            delegate?.filterSelectedHandler = { [unowned self] in
                self.appliedFilter = $0
            }
            collectionViewDelegate = delegate
            collectionView.reloadData()
        }
    }
    
    var appliedFilter: Filter = Filter.identityFilter {
        didSet {
            imageView.image = editedImage
        }
    }
    
    var kernel: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0]
    
    var editedImage: UIImage? {
        return imageToEdit.map { Convolution(image: $0, filter: appliedFilter).convolvedImage }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func handlePhotoLibraryButtonPressed(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: Protocol UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageToEdit = image.map { Convolution(image: $0, filter: Filter(kernel: self.kernel)).convolvedImage }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

class FilterCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    let image: UIImage
    var filters = [Filter.identityFilter, Filter.edgeFilter, Filter.diamondFilter, Filter.gaussianFilter, Filter.embossFilter]
    
    var filterSelectedHandler: ((Filter) -> Void)?
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    // MARK: Protocol - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier.FilterCellReuseIdentifier.rawValue, forIndexPath: indexPath) as! UICollectionViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let filterCell = cell as? FilterCollectionViewCell {
            filterCell.image = Convolution(image: image, filter: filters[indexPath.row]).convolvedImage
        }
    }
    
    // MARK: Protocol - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        filterSelectedHandler?(filters[indexPath.row])
    }
}

