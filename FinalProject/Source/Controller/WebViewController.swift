//
//  WebViewController.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/28/16.
//
//

import UIKit

class WebViewController: UIViewController {
    

    @IBOutlet var webView: UIWebView!
    let urlString = "https://en.m.wiktionary.org/wiki/"
    var currentString:String? = nil
    var lastString:String? = nil
    var URL:NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeb()
    }
    
    override func viewWillAppear(animated: Bool) {
        if currentString != lastString{
            loadWeb()
            lastString = currentString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func homeButtonClicked(sender: AnyObject) {
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        currentString = nil
        lastString = nil
    }
    
    
    
    func setString(word:String){
        currentString = word
    }
    
    func loadWeb(){
        if currentString == nil{
            URL = NSURL(string: urlString)
        }else{
            URL = NSURL(string: urlString + currentString!)
        }
        webView.loadRequest(NSURLRequest(URL: URL!))
    }
    

}
