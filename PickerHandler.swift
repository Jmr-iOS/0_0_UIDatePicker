/************************************************************************************************************************************/
/** @file       PickerHandler.swift
 *  @project    x
 *  @brief      x
 *  @details    x
 *
 *  @author     Justin Reina, Firmware Engineer, Jaostech
 *  @created    1/21/18
 *  @last rev   1/21/18
 *
 *
 *  @notes      x
 *
 *  @section    Opens
 *      1&3 col support
 *      print statements to all
 *      working full
 *      research addtnl components
 *
 *
 *  @section    Legal Disclaimer
 *      All contents of this source file and/or any other Jaostech related source files are the explicit property on Jaostech
 *      Corporation. Do not distribute. Do not copy.
 */
/************************************************************************************************************************************/
import UIKit


class PickerHandler : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    var verbose : Bool = false;                                 /* local version of verbose to clamp on noisy boot                  */
    
    
    /********************************************************************************************************************************/
    /** @fcn        init()
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    override init() {

        //@note     initialization of vars
        
        //Super
        super.init();
        
        //@note     finalization of initialization

        delayedVerbosity(2.0);                                              /* speak after picker load complete (very verbose!)     */
        
        if(verbose) { print("PickerHandler.init():               initialization complete"); }

        return;
    }

    
    /********************************************************************************************************************************/
    /** @fcn        delayedVerbosity(_ sec : Double)
     *  @brief      enable verbosity after specified delay
     *  @details    x
     */
    /********************************************************************************************************************************/
    func delayedVerbosity(_ sec : Double) {
        
        //Launch delayed verbosity
        DispatchQueue.main.asyncAfter(deadline: (.now() + sec), execute: {
            self.verbose = true;
            if(self.verbose) { print("DispatchQueue.asyncAfter():         execution complete"); }
        })

        if(self.verbose) { print("PickerHandler.delayedVerbosity():               launch complete for \(sec) seconds"); }
        
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
        
        if(verbose) { print("PickerHandler.numberOfComponents(): number of comps is '\(val)'"); }
        
        return val;
    }
    
    
    //@todo     consider a copy with prefix declaration as well
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
        
        if(verbose) { print("PickerHandler.pickerView(NRS):      number of rows is '\(val)'"); }
        
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
        let val  : String;
        
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
        
        if(verbose) { print("PickerHandler.pickerView(TFR):      title is '\(val)'"); }
        
        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
     *  @brief      return the columns width
     *  @details    x
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        let val : CGFloat;
        
        switch(pickerView.hashValue) {
            case picker_1col_hash:
                val = 150;
            case picker_3col_hash:
                val = 50;
            default:
                fatalError("unexpected hash value, aborting");
        }
        
        if(verbose) { print("PickerHandler.pickerView(WFR):      width for component is '\(val)'"); }

        return val;
    }
    
    
    /********************************************************************************************************************************/
    /** @fcn        pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
     *  @brief      x
     *  @details    x
     */
    /********************************************************************************************************************************/
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(verbose) { print("ViewController.pickerView(DSR):     C(\(component)):R(\(row))"); }
        
        return;
    }
}

