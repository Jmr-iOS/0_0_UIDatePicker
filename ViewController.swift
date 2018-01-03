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
 *      https://codewithchris.com/uipickerview-example/
 *      https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDatePicker_Class/index.html#//apple_ref/occ/cl/UIDatePicker
 *      http://sourcefreeze.com/ios-datepicker-tutorial-uidatepicker-using-swift/
 *      http://www.brianjcoleman.com/tutorial-nsdate-in-swift/
 *
 *  @section    Opens
 *  [X] switch to UIPickerView
 *      Layout written implementation steps in header
 *      custom UIPickerView creation example (aNote ref)
 *      grab & reset buttons with resp (buttons & text view)
 *      tap response
 *      UIDatePicker example
 *      DateFormatter example
 *
 *  @section    Components
 *      [1] UIPickerView        (picker)
 *      [2] [[Data]]            (pickerData)
 *
 *
 *  @section    Procedure
 *
 * @section    Legal Disclaimer
 *     All contents of this source file and/or any other Jaostech related source files are the explicit property of Jaostech
 *     Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //UI
    var picker_1col : UIPickerView!;
    var picker_3col : UIPickerView!;
    
    //Init Data
    var pickerData_1col  : [String]!;
    var pickerData_3col  : [[String]]!;
    let picker_1col_hash : Int;
    let picker_3col_hash : Int;
    
    
    /********************************************************************************************************************************/
    /** @fcn        init()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    init() {
        
        //Init UI
        picker_1col = UIPickerView();
        picker_3col = UIPickerView();
        
        print(picker_1col.hashValue)
        print(picker_3col.hashValue)
        
        picker_1col_hash = picker_1col.hashValue;
        picker_3col_hash = picker_3col.hashValue;
        
        super.init(nibName: nil, bundle: nil);
        
        print("My Custom Init");
        
        return;
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

        //Add Pickers
        addPicker_1col(self.view);
        addPicker_3col(self.view);
        
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_1col(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addPicker_1col(_ view : UIView) {
        
        //Set size
        picker_1col.frame = CGRect(x: 50, y: 75,  width: 200, height: 100);
        
        //Set data
        pickerData_1col = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"];
        print(pickerData_1col.count);
        
        // Connect data
        picker_1col.delegate   = self;
        picker_1col.dataSource = self;
        
        //Add to view
        view.addSubview(picker_1col);
        
        print("ViewController.addPicker_1col():   picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_3col(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addPicker_3col(_ view:UIView) {
        
        //Set size
        picker_3col.frame = CGRect(x: 50, y: 110, width: 200, height: 400);
        
        //Set data
        pickerData_3col = gen3ColData(true);
        
        print(pickerData_3col.count);
        print(pickerData_3col[0].count);

        print(pickerData_3col[0][0]);       											/* cols go horiz, rows go vert [R][C]		*/
        //!print(pickerData_3col[4][0]);
        
        // Connect data
        picker_3col.delegate   = self;
        picker_3col.dataSource = self;
        
        //Add to view
        view.addSubview(picker_3col);
        
        print("ViewController.addPicker_3col():   picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        gen3ColData(_ isGenerated : Bool) -> [[String]]
     *  @brief      return a 2D array either manually or programmatically
     *  @details    show the difference
     */
    /********************************************************************************************************************************/
    func gen3ColData(_ isGenerated : Bool) -> [[String]] {
        
        var data : [[String]];
        
        let colNames : [String] = ["A", "B", "C", "D", "E"];
        
        if(isGenerated) {
            //Code Gen
            data = [[String]]();
            
            for i in 0...4 {                                                /* [Cols]                                               */
                var newArr : [String] = [String]();
                for j in 0...3 {                                            /* [Rows]    [C][R] <-> [X][Y] <-> <X,Y>                */
                    newArr.append("\(colNames[i])\(j)");
                }
                data.append(newArr);
            }
        } else {
            //Manual Gen
            data = [["1", "2", "3", "4", "5"],                              /* 5 columns(X), 4 rows(Y),                             */
                    ["a", "b", "c", "d", "e"],                              /* visual disp is transposed from access                */
                    ["!", "#", "$", "%", "?"],
                    ["v", "w", "x", "y", "z"]];
        }
        
        return data;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        numberOfComponents(in pickerView: UIPickerView) -> Int
     *  @brief      The number of columns of data
     *  @details    called in picker initialization
     */
    /********************************************************************************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        let hash = pickerView.hashValue;
        let val  : Int;
        
        switch(hash) {
        case picker_1col_hash:
            val = 1;
            break;
        case picker_3col_hash:
            val = pickerData_3col[0].count;
            print("nC:\(val)");
            break;
        default:
            fatalError();
        }
        
        return val;
    }
  
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     *  @brief      The number of rows of data
     *  @details    called on picker generation
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let hash = pickerView.hashValue;
        let val  : Int;
        
        switch(hash) {
        case picker_1col_hash:
            val = pickerData_1col.count;
            break;
        case picker_3col_hash:
            val = pickerData_3col.count;
            print("R:\(val)");
            break;
        default:
            fatalError();
        }
        
        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     *  @brief      The data to return for the row and component (column) that's being passed in
     *  @details    called on picker scroll
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let hash = pickerView.hashValue;
        let val  : String;
        
        //Disp selection value
        //print("C:\(component), R:\(row)");
        
        switch(hash) {
        case picker_1col_hash:
            val = pickerData_1col[row];
            break;
        case picker_3col_hash:
            if((row<5)&&(component<4)) {
                val = pickerData_3col[row][component];
            } else {
                fatalError("Unexpected array access requested of R:\(row), C:\(component), aborting");
            }
            break;
        default:
            fatalError();
        }
        
        return val;
    }

//<PREV>
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
    
    
    /********************************************************************************************************************************/
    /** @fcn        getHash(picker : NSObject) -> Int
     *  @brief      get hash of object
     *  @details    x
     */
    /********************************************************************************************************************************/
    func getHash(object : NSObject) -> Int {
        return object.hashValue;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        init?(coder aDecoder: NSCoder)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
}

