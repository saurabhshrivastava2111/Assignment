//
//  FileListViewController.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit
import Swime
import AVFoundation

enum DisplayStyle:String {
    case grid = "Grid"
    case list = "List"
}

class HeaderView:UICollectionReusableView{
}

class FileListViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var isListView:Bool = true
    var toggleButton = UIBarButtonItem()
    var slectedItem:File!
    var progressView: UIProgressView!
    var displayStyle:DisplayStyle = .grid
    var selectButton : UIBarButtonItem?
    var isSelectionModeOn:Bool = false
    var selectedIndexPath:IndexPath!
    
    @IBOutlet weak var btnShare:UIBarButtonItem!
    @IBOutlet weak var btnDelete:UIBarButtonItem!
    @IBOutlet weak var btnDEleteAll:UIBarButtonItem!
    
    //MARK: -- custom methods
      func configureNavBar(){
        self.toggleButton = UIBarButtonItem.init(title: DisplayStyle.list.rawValue, style: .plain, target: self, action: #selector(sel_toggleListGrid(button:)))
        
        self.selectButton = UIBarButtonItem.init(title: "Select", style: .plain, target: self, action: #selector(sel_select(button:)))
        
        self.navigationItem.setLeftBarButtonItems([self.toggleButton], animated: true)
        self.navigationItem.setRightBarButton(self.selectButton, animated: true)
    }
    
    @objc func refreshContent(){
        // clear content and download fresh one.
    }
    
    @IBAction func add(){
        let alertController = UIAlertController(title: "Add New Entry", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        weak var weakSelf = self
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let nameTextField = alertController.textFields![0] as UITextField
            let urltextfield = alertController.textFields![1] as UITextField
            FileViewModel.add(with: nameTextField.text!, and: urltextfield.text!)
            weakSelf?.collectionView?.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter URL"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func toggleSelectButton() {
        if !self.isSelectionModeOn {
            self.selectButton?.title = "Cancel"
            
        } else {
            self.selectButton?.title = "Select"
            FileViewModel.cancelSelection()
        }
    }
    
    @objc func sel_select(button:UIBarButtonItem){
        self.toggleSelectButton()
        self.isSelectionModeOn = !self.isSelectionModeOn
        self.enableActionButtons()// enable action buttons once selectionMode is on
        self.collectionView?.reloadData()
    }
    
    @objc func sel_toggleListGrid(button:UIBarButtonItem){
        
        self.displayStyle = DisplayStyle.init(rawValue: button.title!)!
        
        switch self.displayStyle {
        case .grid:
            self.toggleButton = UIBarButtonItem.init(title: DisplayStyle.list.rawValue, style: .plain, target: self, action: #selector(sel_toggleListGrid))
            
            break;
        case .list:
            self.toggleButton = UIBarButtonItem.init(title: DisplayStyle.grid.rawValue, style: .plain, target: self, action: #selector(sel_toggleListGrid))
            break;
        }
        self.displayStyle = DisplayStyle.init(rawValue: self.toggleButton.title!)!
        self.navigationItem.setLeftBarButtonItems([self.toggleButton], animated: true)
        self.collectionView?.reloadData()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.lightGray
        self.collectionView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProgressBarReuseIdentifier")
        
        self.configureNavBar()
        self.navigationItem.title = "FileList"
        self.collectionView?.allowsMultipleSelection = true
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
//    func downLoadFiles(){
//        weak var weakself = self
//        FileListHelper.shared.startDownLoad(with:fileURLss ) { (success) in
//            weakself?.refreshContentArray()
//
//            OperationQueue.main.addOperation {
//                 weakself?.collectionView?.reloadData()
//            }
//        }
//    }
    
    
    func refreshContentArray(){
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FileListViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FileViewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FileViewModel.numberOfItems(in:section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.displayStyle {
        case .grid:
            return gridCellForItem(at: indexPath)
        case .list:
            break;
        }
        
        return UICollectionViewCell()
    }
    
    
    fileprivate func gridCellForItem(at indexPath:IndexPath) -> UICollectionViewCell{
        let gridCell = self.collectionView?.dequeueReusableCell(withReuseIdentifier:fileGridCellReuseIdentifier , for: indexPath) as! GridFileCell
        
        let file:File = FileViewModel.item(at:indexPath)
        
        if !(file.isDownloaded?.boolValue)!  {
            gridCell.btnDownload.isHidden = false
        }else{
            gridCell.btnDownload.isHidden = true
        }
        
        gridCell.cellModel = CellModel.init(with:file)
        
        return gridCell
        
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView?.frame.width
        
        switch self.displayStyle {
        case .grid:
            switch self.traitCollection.horizontalSizeClass{
            case .compact:
                return CGSize(width: (width! - 15)/2, height: (width! - 15)/2)
            case .regular:
                 return CGSize(width: (width! - 15)/4, height: (width! - 15)/4)
            case .unspecified:
                return CGSize(width: (width! - 15)/2, height: (width! - 15)/2)
            }
        case .list:
            return CGSize(width: width!, height: 120)
        }
    }*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4.0
        return CGSize(width: picDimension, height: picDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }

    
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.isSelectionModeOn {
            _ = FileViewModel.selectItem(at: indexPath.row)
            self.enableActionButtons()
        }
    }
    
    func showAlert(with message:String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isSelectionModeOn {
            let success = FileViewModel.selectItem(at: indexPath.row)
            if !success{
                collectionView.deselectItem(at: indexPath, animated: false)
                self.showAlert(with: "File is not downloaded, download to share")
            }
            self.enableActionButtons()
        }else{
            self.selectedIndexPath = indexPath
            collectionView.deselectItem(at: indexPath, animated: false)
            self.performSegue(withIdentifier: "DocumentVCSegueIdentifier", sender: self)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
}

// Bottom toolbar action Methods.
extension FileListViewController{
    
    func enableActionButtons(){
        
        if self.isSelectionModeOn {
            if let selectedFiles = FileViewModel.shared.selectedFiles {
                if selectedFiles.count > 0 {
                    self.btnDelete.isEnabled = true
                    self.btnShare.isEnabled  = true
                }
                else{
                    self.btnDelete.isEnabled = false
                    self.btnShare.isEnabled = false
                }
            }
            self.btnDEleteAll.isEnabled = true
        }else{
            self.btnDelete.isEnabled = false
            self.btnShare.isEnabled = false
            self.btnDEleteAll.isEnabled = false
        }
    }
    
    @IBAction func delete(){
        FileViewModel.deleteSelectedFiles()// Delete Selected files
        self.collectionView?.reloadData()
        self.isSelectionModeOn = false
        self.toggleSelectButton()
        self.enableActionButtons()
    }
    
    @IBAction func share(){
        var itemsToShare:[Any] = [Any]()
        var shareData:Data?
        for anItem in FileViewModel.shared.selectedFiles! {
            if (anItem.isDownloaded?.boolValue)! {
                do{
                    shareData = try Data.init(contentsOf: Utility.url(mimeType: anItem.mimeType!, name: anItem.name!))
                    
                    itemsToShare.append(shareData ?? Data.init())
                    shareData = nil
                    
                }catch{
                    print(error)
                }
            }
        }
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        weak var weakSelf = self
        self.present(activityVC, animated: true) {
            FileViewModel.cancelSelection()
            weakSelf?.isSelectionModeOn = false
            weakSelf?.collectionView?.reloadData()
            weakSelf?.toggleSelectButton()
            weakSelf?.enableActionButtons()
        }

    }
    
    
    @IBAction func deleteAll(){
        let alertController = UIAlertController.init(title: "", message: "Are you sure, you want to delete?", preferredStyle: .alert)
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive) { (action) in
            FileViewModel.deleteAll()// delete All files// This is a temporary deletion from the list of array
            self.collectionView?.reloadData()
            self.toggleSelectButton()
            self.isSelectionModeOn = false
            self.enableActionButtons()

        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
        self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}


//MARK:- Prepare for Segue
extension FileListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let previewViewCOntroller = segue.destination as! FilepreviewController
        previewViewCOntroller.fileModel = FilePreviewModel.init(with: FileViewModel.item(at: self.selectedIndexPath))
    }    
}

