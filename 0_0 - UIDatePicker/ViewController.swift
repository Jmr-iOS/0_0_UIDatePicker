//
//  ViewController.swift
//  0_0 - Empty Template (Swift)
//
//  Created by Justin Reina on 11/12/15.
//  Copyright © 2015 Jaostech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addDatePicker(self.view);
        
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    @objc func addDatePicker(_ view:UIView) {
        
        let datePicker:UIDatePicker = UIDatePicker();
        
        let currDate:Date = datePicker.date;

        datePicker.translatesAutoresizingMaskIntoConstraints = false;
        
        print(currDate);

        print(self.hour(currDate));
 
        print(self.minute(currDate));
        
            
        view.addSubview(datePicker);

        return;
    }

    
    @objc func hour(_ date:Date) -> Int {
        
        //Get Hour
        let calendar = Calendar.current;
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.hour, from: date);
        let hour = components.hour;
        
        //Return Hour
        return hour!;
    }
    
    
    @objc func minute(_ date:Date) -> Int {
        
        //Get Minute
        let calendar = Calendar.current;
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.minute, from: date);
        let minute = components.minute;
        
        //Return Minute
        return minute!;
    }
    
    
    @objc func toShortTimeString(_ date:Date) -> String {
        
        //Get Short Time String
        let formatter = DateFormatter();
        formatter.timeStyle = .short;
        let timeString = formatter.string(from: date);
        
        //Return Short Time String
        return timeString;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();

        return;
    }
}



