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

private let __no_of_sections__ = 1
private let __no_content__  = 0

class HeaderView:UICollectionReusableView{
}

class FileListViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var arrFiles:[File] = FileListHelper.shared.getFiles()
    var isListView:Bool = true
    var toggleButton = UIBarButtonItem()
    var slectedItem:File!
    var progressView: UIProgressView!
    
    //MARK: -- custom methods
      func configureNavBar(){
        self.toggleButton = UIBarButtonItem.init(title: "Grid", style: .plain, target: self, action: #selector(sel_toggleListGrid))
        
        let refreshButton = UIBarButtonItem.init(title: "Refresh Content", style: .plain, target: self, action: #selector(refreshContent))
        
        self.navigationItem.setRightBarButtonItems([self.toggleButton], animated: true)
        self.navigationItem.setLeftBarButtonItems([refreshButton], animated: true)
    }
    
    @objc func refreshContent(){
        // clear content and download fresh one.
        FileListHelper.shared.clearAllContent()// Clear all content from the file and down a fresh again
        let docDirPath = Utility.documentDirectoryPath()
        let contentCount = try? FileManager.default.contentsOfDirectory(atPath: docDirPath).count
//        if contentCount!  <= __no_content__ {
//            self.downLoadFiles()
//        }
    }
    
    @objc func sel_toggleListGrid(){
        
        self.isListView = !self.isListView
        if self.isListView {// if list view is slected
            self.toggleButton = UIBarButtonItem.init(title: "Grid", style: .plain, target: self, action: #selector(sel_toggleListGrid))
            
        }else{// if grid view is selected.
            self.toggleButton = UIBarButtonItem.init(title: "List", style: .plain, target: self, action: #selector(sel_toggleListGrid))
        }
        
        self.navigationItem.setRightBarButtonItems([self.toggleButton], animated: true)
        self.collectionView?.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.lightGray
        self.collectionView?.register(ListFileCell.self, forCellWithReuseIdentifier: fileListCellReuseIdentifier)
        self.collectionView?.register(GridFileCell.self, forCellWithReuseIdentifier: fileGridCellReuseIdentifier)
        
        self.collectionView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProgressBarReuseIdentifier")
        
        self.configureNavBar()
        self.navigationItem.title = "FileList"
        
        self.arrFiles = FileListHelper.shared.getFiles()
        // Do any additional setup after loading the view.se
//        if self.arrFiles.count <= 0 {
//            self.downLoadFiles()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weak var weakself = self
//        FileListHelper.shared.onProgress = { (progress) in
////            OperationQueue.main.addOperation {
////                weakself?.progressView.progress = progress
////            }
//        }
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
        self.arrFiles = FileListHelper.shared.getFiles()
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
        return __no_of_sections__
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
           let fileCell = collectionView.dequeueReusableCell(withReuseIdentifier:fileGridCellReuseIdentifier , for: indexPath) as! GridFileCell

        
            return fileCell

//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            let reuseHeaderView:HeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProgressBarReuseIdentifier", for: indexPath) as! HeaderView
            
            
            self.progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: 10, width: collectionView.frame.size.width, height: 10))
            
            self.progressView.trackTintColor = UIColor.red
            
            reuseHeaderView.addSubview(self.progressView)
            
            return reuseHeaderView
        }
        
        return UICollectionReusableView.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height:30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView?.frame.width
        
        if self.isListView {
            return CGSize(width: width!, height: 120)
        }else {
            return CGSize(width: (width! - 15)/2, height: (width! - 15)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.slectedItem = self.arrFiles[indexPath.row]
//        self.performSegue(withIdentifier: documentVCSegueIdentifier, sender: self)
    }
}


extension FileListViewController{
    
    func getThumbnail(mimeType:MimeType, path:String)->UIImage{
        
        switch mimeType.type {
        case .jpg,.png,.gif:
            if let image =  UIImage.init(contentsOfFile: path){
                return Utility.generateThumbnail(for: image, with: CGSize.init(width: 100.0, height: 100.0))
            }
        case .pdf,.rtf:
            break
            // generate thumbnail for PDf
        case .mov,.mp4,.m4v:
            // generate thumbnail for Video
            
            return Utility.generateVideoThumbnail(with: path)
            
        default: break
            
        }
        return UIImage.init(named: "Default")!
    }
}


extension FileListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let filePreviewVC: FilepreviewController = segue.destination as! FilepreviewController
        filePreviewVC.selectedItemType = self.slectedItem.mimeType
        filePreviewVC.documentPath  = self.slectedItem.path
    }
}
