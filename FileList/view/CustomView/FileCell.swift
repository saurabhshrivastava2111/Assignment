//
//  FileCell.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit

//class ListFileCell: UICollectionViewCell {
//
//    public var isImage:Bool = false
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.configureViews()// configure views
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    let imgThumbnail = { () -> UIImageView in
//        let imageView = UIImageView()
//        imageView.image = UIImage.init(named: "Default")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    let lblTitle = { () -> UILabel in
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 2
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
//        return label
//    }()
//
//
//    func configureViews () {
//        backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
//        addSubview(self.imgThumbnail)
//        addSubview(self.lblTitle)
//        self.imgThumbnail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
//        self.imgThumbnail.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
//        self.imgThumbnail.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
//        self.imgThumbnail.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
//
//        self.lblTitle.leadingAnchor.constraint(equalTo: self.imgThumbnail.trailingAnchor, constant: 8).isActive = true
//        self.lblTitle.topAnchor.constraint(equalTo: self.imgThumbnail.topAnchor, constant: 4).isActive = true
//        self.lblTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
//        self.lblTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
//    }
//
//}



class GridFileCell: UICollectionViewCell {
    
    public var isImage:Bool = false
    @IBOutlet weak var btnDownload:UIButton!
    @IBOutlet weak var btnSelect:UIButton!
    @IBOutlet weak var viewProgress:UIView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var btnPlay:UIButton!
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.btnSelect.isHidden = false
            } else {
                self.btnSelect.isHidden = true
            }
        }
    }
    
    var cellModel:CellModel!{
        didSet(newValue){
            self.updateProgressView()
            self.setDataToUIControls()
        }
    }
    
    override func awakeFromNib() {
    }
    
    func setDataToUIControls(){
        if self.cellModel.isDownloaded() {
            self.imgThumbnail.image = self.cellModel.thumbnail().0!
            if (self.cellModel.thumbnail().1){
                self.btnPlay.isHidden = false
            }else{
                self.btnPlay.isHidden = true
            }
            self.viewProgress.isHidden = true
        }else{
            self.imgThumbnail.image = UIImage()
            self.viewProgress.isHidden = false
        }
    }
    
    func createCircularProgressView(with progress:Float){
        let circle = self.viewProgress
        
        var progressCircle = CAShapeLayer()
        
        let circlePath = UIBezierPath.init(ovalIn: (circle?.bounds)!)
        
        progressCircle = CAShapeLayer ()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.green.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 5.0
        
        circle?.layer.addSublayer(progressCircle)
        
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        progressCircle.add(animation, forKey: "ani")
    }
    
    @IBAction func sel_btnDownLoad(downLoad:UIButton){
        if !downLoad.isSelected {
            downLoad.isSelected = true
            self.downloadFile()
        }else{
            downLoad.isSelected = false
            self.canCelDownload()
            self.viewProgress.isHidden = true
        }
    }
    
    func canCelDownload(){
        self.cellModel.cancelDownload()
    }
    
    func updateProgressView(){
        weak var weakSelf = self
        self.cellModel.onProgress = { (progress) in
            OperationQueue.main.addOperation {
                weakSelf?.update(with: progress)
            }
        }
    }
    
    private func update(with progress:Float){
        createCircularProgressView(with:progress)
    }
    
    
    func downloadFile(){
        weak var weakSelf = self
        self.cellModel.downLoad(){(success,filePath) in
            OperationQueue.main.addOperation {
                
                weakSelf?.btnDownload.isHidden = true
                weakSelf?.viewProgress.isHidden = true

                if (success){
                    weakSelf?.imgThumbnail.image = weakSelf?.cellModel.thumbnail().0
                    if(weakSelf?.cellModel.thumbnail().1)!{
                        weakSelf?.btnPlay.isHidden = false
                    }else{
                        weakSelf?.btnPlay.isHidden = true
                    }
                    CoreData.shared.saveContext()

                }else{
                    weakSelf?.btnDownload.isSelected = false
                    weakSelf?.viewProgress.isHidden = true
                }
            }
        }
    }
    
    func deleteFile(){
        
    }
}




