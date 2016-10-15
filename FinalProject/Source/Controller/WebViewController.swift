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
    var URL:Foundation.URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentString != lastString{
            loadWeb()
            lastString = currentString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func homeButtonClicked(_ sender: AnyObject) {
        webView.loadRequest(URLRequest(url: Foundation.URL(string: urlString)!))
        currentString = nil
        lastString = nil
    }
    
    
    
    func setString(_ word:String){
        currentString = word
    }
    
    func loadWeb(){
        if currentString == nil{
            URL = Foundation.URL(string: urlString)
        }else{
            URL = Foundation.URL(string: urlString + currentString!)
        }
        webView.loadRequest(URLRequest(url: URL!))
    }
    

}
