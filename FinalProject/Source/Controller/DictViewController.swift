//
//  DictViewController.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/28/16.
//
//

import UIKit

class DictViewController: UIViewController, UISearchBarDelegate {
    
    var displayDefinition: Bool = true
    var word: String? = nil
    var definition:String? = ""
    var sentence:String? = ""
    var autoAdd = true
    var wordFound = false

    @IBOutlet var autoAddButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var definitionLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var searchButtonClicked:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        definitionLabel.isHidden = true
        //searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //popup keyboard as soon as main view is loaded
        if SettingService.sharedSettingService.getAutoPopUPKeyboard() == true{
            searchBar.becomeFirstResponder()
        }
        if SettingService.sharedSettingService.getAutoAdd() == true{
            autoAdd = true
            autoAddButton.isHidden = true
        }else{
            autoAdd = false
            autoAddButton.isHidden = false
        }
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addToHistory(_ sender: AnyObject) {
        guard word != nil else{
            return
        }
        
        guard wordFound == true else{
            //print("no such a word")
            return
        }
        
        
        let vocabualry = self.word!
        if DataService.sharedDataService.saveWordToHistory(self.word!){
            //print("saved \(self.word) to History")
            let alertController = UIAlertController(title: "Add Word", message: "Saved \(vocabualry) to History", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            //print("\(self.word) is already in History")
            let alertController = UIAlertController(title: "Add Word", message: "\(vocabualry) is already in History", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0{
            displayDefinition = true
        }else{
            displayDefinition = false
        }
        displayLabel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonClicked = true
        word = searchBar.text!
        sendStringtoWebView(word!)
        displayLabel()
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func displayLabel(){
        guard word != nil else{
            return
        }
        
        activityIndicator.startAnimating()
        definitionLabel.isHidden = true
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
        
        globalQueue.async(execute: {
            
            let definitionString = DataService.sharedDataService.getDefination(self.word!)
            let exampleString = DataService.sharedDataService.getScentence(self.word!)
            
            if definitionString == "No such vocabulary found\nplease check your spelling or\nTry Wikipidea tab for English Definition"{
                self.wordFound = false
            }else{
                self.wordFound = true
            }
            
            //only execute when search is clicked
            if self.searchButtonClicked == true && self.autoAdd == true{
                DataService.sharedDataService.saveWordToHistory(self.word!)
                self.searchButtonClicked = false
            }
            
            
            mainQueue.async(execute: {
                if self.displayDefinition == true{
                    self.definitionLabel.text = definitionString
                }else{
                    self.definitionLabel.text = exampleString
                }
                self.activityIndicator.stopAnimating()
                self.definitionLabel.isHidden = false
            })
        })
    }
    
    func sendStringtoWebView(_ word:String){
        let webViewController = self.tabBarController?.viewControllers![1] as! WebViewController
        webViewController.setString(word.lowercased())
    }

}
