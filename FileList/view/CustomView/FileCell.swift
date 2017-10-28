//
//  FileCell.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 13/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit

class ListFileCell: UICollectionViewCell {
    
    public var isImage:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()// configure views
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imgThumbnail = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "Default")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lblTitle = { () -> UILabel in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        return label
    }()
    
    
    func configureViews () {
        backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        addSubview(self.imgThumbnail)
        addSubview(self.lblTitle)
        self.imgThumbnail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        self.imgThumbnail.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        self.imgThumbnail.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        self.imgThumbnail.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        self.lblTitle.leadingAnchor.constraint(equalTo: self.imgThumbnail.trailingAnchor, constant: 8).isActive = true
        self.lblTitle.topAnchor.constraint(equalTo: self.imgThumbnail.topAnchor, constant: 4).isActive = true
        self.lblTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        self.lblTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
    }
    
}


class GridFileCell: UICollectionViewCell {
    public var isImage:Bool = false
    @IBOutlet weak var btnDownload:UIButton!
    @IBOutlet weak var btnSelect:UIButton!
    @IBOutlet weak var viewProgress:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
