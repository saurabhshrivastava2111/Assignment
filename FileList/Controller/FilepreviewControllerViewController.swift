//
//  FilepreviewControllerViewController.swift
//  FileList
//
//  Created by Saurabh Shrivastava on 14/10/17.
//  Copyright © 2017 Indegene. All rights reserved.
//

import UIKit
import Swime
import WebKit
class FilepreviewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var activity:UIActivityIndicatorView!
    var fileModel:FilePreviewModel!
    
    var documentPath:String!
    var selectedItemType:MimeType!
    var isImage:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.isImage = self.fileModel.isImage
        self.webView.allowsInlineMediaPlayback = true
        self.webView.scrollView.bounces = false
        self.webView.mediaPlaybackRequiresUserAction = false
        
        self.loadContent()
        // Do any additional setup after loading the view.
    }
    
    func configureNavBar(){
        let shareButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(share(sender:)))
        self.navigationItem.rightBarButtonItem = shareButton
    }

    @objc func share(sender:Any) {
        
        let activityViewController = UIActivityViewController.init(activityItems: ["This is a file I want you to have a look at",self.documentPath], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender as? UIBarButtonItem
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func loadContent(){
        if self.fileModel.isDownloaded {
            let fileURL = Utility.url(mimeType: self.fileModel.file.mimeType!, name: self.fileModel.file.name!)
            if self.isImage{
                self.imageView.isHidden = false
                self.webView.isHidden = true
                self.imageView.image = UIImage.init(contentsOfFile: (fileURL.path))
                }else{
                    self.imageView.isHidden = true
                    self.webView.isHidden = false
                let requestURL = URLRequest.init(url: fileURL);
                self.webView.loadRequest(requestURL)
                }
        }else{
            self.imageView.isHidden = true
            self.webView.isHidden = false
            let requestURL = URLRequest.init(url:self.fileModel.url)//URLRequest.init(url: self.fileModel.url);
            self.webView.loadRequest(requestURL)
            
        }
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
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activity.startAnimating()
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
        self.activity.stopAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activity.stopAnimating()
    }
    
}
