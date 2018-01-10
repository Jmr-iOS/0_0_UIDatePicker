/************************************************************************************************************************************/
/** @file       ViewController.swift
 *  @project    0_0 - UIPickerView
 *  @brief      x
 *  @details    x
 *
 *  @author     Justin Reina, Firmware Engineer, Jaostech
 *  @created    11/6/16
 *  @last rev   1/10/18
 *
 *  @section    Reference
 *      https://codewithchris.com/uipickerview-example/
 *
 *  @section    Opens
 *      implement correct ANotePicker with example
 *          make mode swap supported
 *      make 'CustomPicker' functional & complete
 *      'Get' and  'Reset' functional
 *      respond to pickerview selections (having difficulties in previous attempt)
 *
 *  @section    Components
 *      [1] UIPickerView        (picker)
 *      [2] [[Data]]            (pickerData)
 *      [3] Delegate            (self)
 *      [4] DataSource          (self)
 *
 *  @section    Procedure
 *      init picker (UIPickerView)                          @ref    ViewController.swift:90
 *      set the delegate & source                           @ref    ViewController.swift:195
 *      implement delegate protocol                         @ref    ViewController.swift
 *          pickerView:rowHeightForComponent:                        row height for drawing row
 *          pickerView:widthForComponent:                            row width for drawing row
 *          pickerView:titleForRow:forComponent:                     get title to use for a given row in a given component
 *          pickerView:attributedTitleForRow:forComponent:           get styled title to use for a given row in a given component
 *          pickerView:viewForRow:forComponent:reusingView:          view to use for a given row in a given component
 *          pickerView:didSelectRow:inComponent:                     when the user selects a row in a component
 *      implement source protocol                           @ref    ViewController.swift
 *          numberOfComponents(in: UIPickerView):                    number of components in picker
 *          pickerView(UIPickerView, numRowsInComp: Int):            number of rows for a specified component
 *
 * @section    Legal Disclaimer
 *     All contents of this source file and/or any other Jaostech related source files are the explicit property of Jaostech
 *     Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit

//Display Modes for Slot 3 selection
enum Mode {
    case MODE_CUST;                                         /* display the custom picker                                            */
    case MODE_ANOTE;                                        /* display the aNote picker                                             */
    case MODE_DATE;                                         /* display the UIDatePicker                                             */
}


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //UI
    var picker_1col : UIPickerView;
    var picker_3col : UIPickerView;
    var picker_cust : CustomPickerView!;
    var picker_date : UIDatePicker!;
    var get_button  : UIButton;
    var rst_button  : UIButton;
    
    //Init Data
    var pickerData_1col : [String]!;
    var pickerData_3col : [[String]]!;
    
    let picker_1col_hash  : Int;
    let picker_3col_hash  : Int;
    
    var picker_1col_wraps : Bool!;

    //Constants
    let mode : Mode = .MODE_DATE;
    let picker_1col_vals : [String]  = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"];

    
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
        
        get_button = UIButton();
        rst_button = UIButton();
        
        //Hashes
        picker_1col_hash  = picker_1col.hashValue;
        picker_3col_hash  = picker_3col.hashValue;
        
        super.init(nibName: nil, bundle: nil);

        print("ViewController.init():              init complete");
        
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
        addButtons(self.view);
        addPicker_1col(self.view, true);
        addPicker_3col(self.view);
        
        switch(mode) {
            case .MODE_ANOTE:
                addPicker_aNote(self.view);
                break;
            case .MODE_DATE:
                addPicker_Date(self.view);
                break;
        case .MODE_CUST:
            fatalError("mode not yet supported");
        }
        
        print("ViewController.viewDidLoad():       viewDidLoad() complete");
        
        return;
    }

    
    
    
    /********************************************************************************************************************************/
    /** @fcn        addButtons(_ view:UIView)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func addButtons(_ view:UIView) {
        
        //Get button Init
        get_button = UIButton(type: UIButtonType.roundedRect);
        get_button.translatesAutoresizingMaskIntoConstraints = true;
        get_button.setTitle("Get", for: UIControlState());
        get_button.sizeToFit();
        get_button.center = CGPoint(x: self.view.center.x-50, y: 625);
        get_button.addTarget(self, action: #selector(ViewController.getPressed(_:)), for:  .touchUpInside);

        //Reset button Init
        rst_button = UIButton(type: UIButtonType.roundedRect);
        rst_button.translatesAutoresizingMaskIntoConstraints = true;
        rst_button.setTitle("Reset", for: UIControlState());
        rst_button.sizeToFit();
        rst_button.center = CGPoint(x: self.view.center.x+50, y: 625);
        rst_button.addTarget(self, action: #selector(ViewController.resetPressed(_:)), for:  .touchUpInside);

        //Add to view
        self.view.addSubview(get_button);
        self.view.addSubview(rst_button);
        
        
        print("ViewController.addButtons():        buttons added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_1col(_ view:UIView)
     *  @brief
     *  @details    x
     *
     *  @section    Wrapping Scroll Effect
     *      @goal   make so big you'll never scroll to end and scroll to middle. Then just mod for result!
     *      @extend pickerView(numberOfRowsInComponent) -> 10_000
     *      @access pickerView(row) { val = data[row%data.count] }
     *      @setup  picker.selectRow('middle', inComponent: 0, animated: false);
     */
    /********************************************************************************************************************************/
    func addPicker_1col(_ view : UIView,_ wraps : Bool) {
        
        //Store wrap cfg
        picker_1col_wraps = wraps;
        
        //Set size
        picker_1col.frame = CGRect(x: (UIScreen.main.bounds.width/2-100), y: 30,  width: 200, height: 100);

        //Set color
        picker_1col.backgroundColor = UIColor.gray;
        
        //Set data
        pickerData_1col = picker_1col_vals;
        
        // Connect data
        picker_1col.delegate   = self;
        picker_1col.dataSource = self;
        
        //Scroll to middle (hide edges)
        if(wraps) {
            picker_1col.selectRow((10_000/2), inComponent: 0, animated: false);
        }
        
        //Add to view
        view.addSubview(picker_1col);
        
        print("ViewController.addPicker_1col():    picker added");
        
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
        picker_3col.frame = CGRect(x: (UIScreen.main.bounds.width/2-150), y: 150, width: 300, height: 130);

        //Set color
        picker_3col.backgroundColor = UIColor.gray;
        
        //Set data
        pickerData_3col = gen3ColData(true);
        
        // Connect data
        picker_3col.delegate   = self;
        picker_3col.dataSource = self;
        
        //Add to view
        view.addSubview(picker_3col);
        
        print("ViewController.addPicker_3col():    picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_aNote(_ view:UIView)
     *  @brief      display the ANotePickerView example
     *  @details    called when in MODE_ANOTE,
     */
    /********************************************************************************************************************************/
    func addPicker_aNote(_ view:UIView) {

        picker_cust  = CustomPickerView();
        
        //Set color
        picker_cust .backgroundColor = UIColor.gray;
        
        view.addSubview(picker_cust );
        
        print("ViewController.addPicker_aNote()    picker added");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        addPicker_Date(_ view:UIView)
     *  @brief      display the DatePicker example
     *  @details    called when in MODE_DATE
     *
     *  @section    Modes
     *      Month Day Year
     *      Date Hour Min
     *      Date Hour Min Merid
     *
     *  @section    Options
     *      Min/max dates
     *      User action response
     *
     */
    /********************************************************************************************************************************/
    func addPicker_Date(_ view:UIView) {

        let dateFrame = CGRect(x: (UIScreen.main.bounds.width/2-165), y: 300, width: 330, height: 300);
        let comp = DateComponents(year: 1995, month: 11, day: 10, hour: 1, minute: 2);
        
        picker_date = UIDatePicker(frame: dateFrame);
        picker_date.datePickerMode = UIDatePickerMode.date;
        picker_date.date = Calendar.current.date(from: comp)!;
        picker_date.backgroundColor = UIColor.gray;
        
        view.addSubview(picker_date);
        
        //Print the date
        let dateFormatter1 = DateFormatter();
        dateFormatter1.dateStyle = .medium;
        dateFormatter1.timeStyle = .none;
        print("ViewController.addPicker_Date()     date: \(dateFormatter1.string(from: picker_date.date))");
        
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
                ["a", "b", "c", "d", "e"],                                  /* visual disp is transposed from access                */
                ["!", "#", "$", "%", "?"],
                ["v", "w", "x", "y", "z"]];
        }
        
        return data;
    }


    /********************************************************************************************************************************/
    /** @fcn        getPressed(_ sender: UIButton!)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    @objc func getPressed(_ sender: UIButton!) {
        
        //Print picker 1
        let x = picker_1col.selectedRow(inComponent: 0)%picker_1col_vals.count;
        
        print("ViewController.getPressed():        Picker 1 - '\(picker_1col_vals[x])'");
        
        
        //Print picker 3
        var s : String = "[" + Utils.selectedRowValue(handler: self, picker: picker_3col, ic: 0);
        for ic in 1...3 {
            s = s + ", " + Utils.selectedRowValue(handler: self, picker: picker_3col, ic: ic);
        }
        s = s + "]";
        
        print("ViewController.getPressed():        Picker 3 - '\(s)'");
        
        
        //Print aNote picker
        s = picker_cust .getAsString();
        
        print("ViewController.getPressed():        aNote Picker - '\(s)'");
        
        
        print("ViewController.getPressed():        \(sender.titleLabel!.text!) response complete");
        
        return;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        resetPressed(_ sender: UIButton!)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    @objc func resetPressed(_ sender: UIButton!) {
        
        //Picker 1
        let p1_middle = picker_1col.numberOfRows(inComponent: 0)/2;
        picker_1col.selectRow(p1_middle, inComponent: 0, animated: true);
        
        //Picker 3
        for i in 0...3 {
            picker_3col.selectRow(0, inComponent: i, animated: true);
        }
        
        //ANoterPicker
        picker_cust .resetPressed();
        
        
        print("ViewController.resetPressed():      \(sender.titleLabel!.text!) response complete");
        
        return;
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
            val = (picker_1col_wraps) ? 10_000 : pickerData_1col.count;                 /* apply large val if wraps                 */
            break;
        case picker_3col_hash:
            val = pickerData_3col.count;
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
     *  @hazard     a bug calls this multiple times per single scroll for large row counts (ex. 10_000)
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let hash = pickerView.hashValue;
        let val  : String?;
        
        switch(hash) {
        case picker_1col_hash:

            if(picker_1col_wraps) {
                val = pickerData_1col[row%pickerData_1col.count];
            } else {
                val = pickerData_1col[row];
            }
            break;
        case picker_3col_hash:
            val = pickerData_3col[row][component];
            break;
        default:
            fatalError();
        }
        
        return val;
    }
    

    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
     *  @brief      return the columns width
     *  @details    x
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch(pickerView.hashValue) {
            case picker_1col_hash:
                return 150;
            case picker_3col_hash:
                return 50;
            default:
                fatalError("unexpected hash value, aborting");
        }
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
    
    
    /********************************************************************************************************************************/
    /** @fcn        func getMonth(_ today:String)-> Int
     *  @brief      get a field from passed date string
     *  @details    for reference
     */
    /********************************************************************************************************************************/
    class func getMonth(_ today:String)-> Int {
        
        let formatter  = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let todayDate = formatter.date(from: today);
        let myCalendar = Calendar(identifier: .gregorian);
        
        let month : Int = myCalendar.component(.month, from: todayDate!);
        
        return month;
    }
}

