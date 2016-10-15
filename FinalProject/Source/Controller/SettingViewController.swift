//
//  SettingViewController.swift
//  FinalProject
//
//  Created by Zhexin Jia on 7/28/16.
//
//

import UIKit
import MessageUI

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var autoAddingSwitch:UISwitch!
    @IBOutlet var setQuestionNumSwitch:UISwitch!
    @IBOutlet var keyboardPopUpSwitch:UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSwitch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let about = "The TFHpple html parser was Created by Geoffrey Grosenbach\n\n The DLRadioButton was created by Davyd Liu\n\nNote:\nBecause of the xcode bug, the email feature only works in real device, not simulator"
        if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 1{
            let alertController = UIAlertController(title: "Resources Reference", message: about, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func autoAddingButton(_ sender: AnyObject) {
        
        if autoAddingSwitch.isOn{
            SettingService.sharedSettingService.setAutoAdd(true)
        }else{
            SettingService.sharedSettingService.setAutoAdd(false)
        }
        //print(SettingService.sharedSettingService.getAutoAdd())
        
    }
    
    
    @IBAction func setQuestionNum(_ sender: AnyObject) {
        if setQuestionNumSwitch.isOn{
            SettingService.sharedSettingService.setQuestionNum(20)
        }else{
            SettingService.sharedSettingService.setQuestionNum(10)
        }
        //print(SettingService.sharedSettingService.getQuestionNum())
    }
    
    
    @IBAction func keyboardPopUp(_ sender: AnyObject) {
        if keyboardPopUpSwitch.isOn{
            SettingService.sharedSettingService.setAutoPopUpKeyboard(true)
        }else{
            SettingService.sharedSettingService.setAutoPopUpKeyboard(false)
        }
        //print(SettingService.sharedSettingService.getAutoPopUPKeyboard())
    }
    
    @IBAction func sendEmail(_ sender: AnyObject) {
        let toRecipients = ["zhexinj@uoregon.edu"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject("App FeedBack")
        mc.setMessageBody("bug or feedback report", isHTML: false)
        mc.setToRecipients(toRecipients)
        if MFMailComposeViewController.canSendMail(){
            self.present(mc, animated: true, completion: nil)
        }else{
            print("can't send email")
        }
    }
    
    func updateSwitch(){
        if SettingService.sharedSettingService.getAutoAdd() == true{
            autoAddingSwitch.isOn = true
        }else{
            autoAddingSwitch.isOn = false
        }
        
        if SettingService.sharedSettingService.getQuestionNum() == 10{
            setQuestionNumSwitch.isOn  = false
        }else{
            autoAddingSwitch.isOn = true
        }
        
        if SettingService.sharedSettingService.getAutoPopUPKeyboard() == true{
            keyboardPopUpSwitch.isOn = true
        }else{
            keyboardPopUpSwitch.isOn = false
        }
    }
    
    
    //email functions
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue{
            
        case MFMailComposeResult.cancelled.rawValue:
            NSLog("Mail Canceled")
            break;
        case MFMailComposeResult.saved.rawValue:
            NSLog("Mail Saved")
            break
        case MFMailComposeResult.sent.rawValue:
            NSLog("Mail sent")
            break
        case MFMailComposeResult.failed.rawValue:
            NSLog("Mail sent failed: %@", [error!.localizedDescription])
            break
        default:
            break
     
        }
        self.dismiss(animated: true, completion: nil)
    }
}
