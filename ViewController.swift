/************************************************************************************************************************************/
/** @file       ViewController.swift
 *  @project    0_0 - UIPickerView
 *  @brief      x
 *  @details    x
 *
 *  @author     Justin Reina, Firmware Engineer, Jaostech
 *  @created    11/6/16
 *  @last rev   1/3/18
 *
 *  @section    Reference
 *      https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDatePicker_Class/index.html#//apple_ref/occ/cl/UIDatePicker
 *      http://sourcefreeze.com/ios-datepicker-tutorial-uidatepicker-using-swift/
 *      http://www.brianjcoleman.com/tutorial-nsdate-in-swift/
 *
 *  @section    Opens
 *      switch to UIPickerView <in prog>
 *      custom UIPickerView creation example
 *      confirm, edit & reset buttons with resp
 *      tap response
 *      UIDatePicker example
 *      DateFormatter example
 *
 *  @section    Reference
 *      https://codewithchris.com/uipickerview-example/
 *
 * @section    Legal Disclaimer
 *     All contents of this source file and/or any other Jaostech related source files are the explicit property of Jaostech
 *     Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //UI
    var picker : UIPickerView!;

    //Init Data
    var pickerData: [String];
    
    
    /********************************************************************************************************************************/
    /**    @fcn        init()
     *  @brief        x
     *  @details    x
     */
    /********************************************************************************************************************************/
    init() {
        
        //Init UI
        picker = UIPickerView();
        
        //Init Data
        pickerData = [String]();
        
        super.init(nibName: nil, bundle: nil);
        
        print("My Custom Init");
        
        return;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        override func viewDidLoad()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        view.backgroundColor = UIColor.white;
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        //addDatePicker(self.view);
        //addCustPicker(self.view);
        addNewPicker(self.view);
        
        
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    /********************************************************************************************************************************/
    /** @fcn        x
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addNewPicker(_ view:UIView) {
        
        //Set size
        picker.frame = CGRect(x: 50, y: 30, width: 200, height: 100);
        
        //Set data
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"];
        
        // Connect data
        picker.delegate = self;
        picker.dataSource = self;
        
        //Add to view
        view.addSubview(picker);
        
        print("picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        numberOfComponents(in pickerView: UIPickerView) -> Int
     *  @brief      The number of columns of data
     *  @details    x
     */
    /********************************************************************************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
  
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     *  @brief      The number of rows of data
     *  @details    x
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     *  @brief      The data to return for the row and component (column) that's being passed in
     *  @details    x
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row];
    }
    
    

    
    
//<PREV>
    
    /********************************************************************************************************************************/
    /** @fcn        func addDatePicker(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func depr_addDatePicker(_ view:UIView) {

        let datePicker:UIDatePicker = UIDatePicker(frame: CGRect(x: 20, y: 50, width: UIScreen.main.bounds.width-40, height: 100));
        
        let currDate:Date = datePicker.date;
        
        datePicker.backgroundColor = UIColor.red;
        datePicker.translatesAutoresizingMaskIntoConstraints = true;
        
        print("ViewController.addDatePicker():     added date picker for \(currDate), of \(hour(currDate)) and \(minute(currDate))");
        
        view.addSubview(datePicker);

        return;
    }

    
    
    /********************************************************************************************************************************/
    /** @fcn        func addCustPicker(_ view:UIView)
     *  @brief      x
     *  @details    x
     *
     *  @section    Reference
     *      https://developer.apple.com/documentation/uikit/uidatepicker
     */
    /********************************************************************************************************************************/
    func depr_addCustPicker(_ view:UIView) {
        let textField = UITextField();
        var picker_prev = UIDatePicker();

        print("A");
        
        picker_prev = UIDatePicker(frame: CGRect(x: 20, y: 225, width: UIScreen.main.bounds.width-40, height: 100));
        textField.inputView = picker_prev;
        picker_prev.addTarget(self, action: #selector(ViewController.handleDatePicker), for: UIControlEvents.valueChanged);
        picker_prev.datePickerMode = .date;
        
        picker_prev.backgroundColor = UIColor.blue;
        
        view.addSubview(picker_prev)
        
        return;
    }
        
    
    enum Foo : CustomStringConvertible {
        case dmy;
        case ymd;
        case Boom;
        
        var description : String {
            switch self {
            case .dmy: return "dd-MM-yyyy";                             /* November 2 2018                                          */
            case .ymd: return "YYYY-MM-dd HH:mm";                       /* */
            case .Boom: return "Boom";
            }
        }
    }

    /********************************************************************************************************************************/
    /** @fcn        func handleDatePicker()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    @objc func handleDatePicker() {
        let textField = UITextField();
        let picker_prev = UIDatePicker();
        
        print("B");
        print(Foo.ymd);
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = Foo.ymd.description;
        textField.text = dateFormatter.string(from: picker_prev.date);
        textField.resignFirstResponder();
        
        return;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        func hour(_ date:Date) -> Int
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func hour(_ date:Date) -> Int {
        
        //Get Hour
        let calendar = Calendar.current;
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.hour, from: date);
        let hour = components.hour;
        
        //Return Hour
        return hour!;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        func minute(_ date:Date) -> Int
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func minute(_ date:Date) -> Int {
        
        //Get Minute
        let calendar = Calendar.current;
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.minute, from: date);
        let minute = components.minute;
        
        //Return Minute
        return minute!;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        func toShortTimeString(_ date:Date) -> String
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func toShortTimeString(_ date:Date) -> String {
        
        //Get Short Time String
        let formatter = DateFormatter();
        formatter.timeStyle = .short;
        let timeString = formatter.string(from: date);
        
        //Return Short Time String
        return timeString;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        override func didReceiveMemoryWarning()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();

        return;
    }
}

