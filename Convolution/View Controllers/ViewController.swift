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
    
    var collectionViewDelegate: FilterCollectionViewDelegate? {
        didSet {
            collectionView.dataSource = collectionViewDelegate
            collectionView.delegate = collectionViewDelegate
        }
    }
    
    var filters = Filter.standardFilters {
        didSet {
            collectionViewDelegate?.filters
            collectionView.reloadData()
        }
    }
    
    var imageToEdit: UIImage = UIImage(named: "tech-tower")! {
        didSet {
            collectionViewDelegate?.image = imageToEdit
            imageView.image = editedImage
            collectionView.reloadData()
        }
    }
    
    var appliedFilter: Filter = Filter.identityFilter {
        didSet {
            imageView.image = editedImage
        }
    }
    
    var editedImage: UIImage? {
        return Convolution(image: imageToEdit, filter: appliedFilter).convolvedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleFilterLongPressed:")
        collectionView.addGestureRecognizer(gestureRecognizer)
        
        let delegate = FilterCollectionViewDelegate(image: imageToEdit, filters: filters)
        delegate.filterSelectedHandler = { [unowned self] in
            self.appliedFilter = $0
        }
        collectionViewDelegate = delegate
        imageView.image = editedImage
    }

    // MARK: User Interaction
    @IBAction func handlePhotoLibraryButtonPressed(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func handleFilterLongPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            performSegueWithIdentifier(StoryboardSegue.editFilter, sender: sender)
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryboardSegue.editFilter {
            if let gesture = sender as? UILongPressGestureRecognizer, gestureView = gesture.view {
                let destinationViewController = segue.destinationViewController as? UINavigationController
                let filterController = destinationViewController?.topViewController as? FilterTableViewController
                
                let popoverPresentationController = destinationViewController?.popoverPresentationController
                let location = gesture.locationInView(gestureView)
                if let indexPath = collectionView.indexPathForItemAtPoint(location), let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                    popoverPresentationController?.sourceView = gestureView
                    popoverPresentationController?.sourceRect = cell.frame
                    
                    filterController?.filter = collectionViewDelegate?.filters[indexPath.row]
                    filterController?.filterChangeHandler = { [unowned self] in
                        self.filters[indexPath.row] = $0
                        self.imageView.image = self.editedImage
                    }
                }
            }
        }
    }
    
    // MARK: Protocol UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageToEdit = image!
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

class FilterCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var image: UIImage
    
    var filters: [Filter]
    
    init(image: UIImage, filters: [Filter]) {
        self.image = image
        self.filters = filters
        super.init()
    }
    
    var filterSelectedHandler: ((Filter) -> Void)?
    
    // MARK: Protocol - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier.filterCell, forIndexPath: indexPath) as! UICollectionViewCell
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

