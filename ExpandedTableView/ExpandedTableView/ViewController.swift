//
//  ViewController.swift
//  ExpandedTableView
//
//  Created by vishnu jangid on 16/04/18.
//  Copyright © 2018 brsoftech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let keyIndent = "level"
    let keyTitle = "title"
    let keyChildren = "children"
    
    //TODO: local class resfrence instance
    
    @IBOutlet weak var objTblView: UITableView!
        {
        didSet {
            self.objTblView.delegate = self
            self.objTblView.dataSource = self
        }
    }
    
    fileprivate var arrDataSource = NSMutableArray()
    
    //MARK:-
    //MARK:- super class methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fatchDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Set data source from plist and update table.
    
    func fatchDataSource() {
        if let path = Bundle.main.path(forResource: "DataSource", ofType: "plist") {
            //If your plist contain root as Array
            if let arrTemp = NSArray(contentsOfFile: path) {
                print(arrTemp)
                self.arrDataSource = arrTemp.mutableCopy() as! NSMutableArray
                print(self.arrDataSource)
            }
        }
        self.objTblView.reloadData()
    }
    
    func miniMizeThisRows(ar:NSArray,forTable tableView:UITableView ,withIndexpath indexPath:NSIndexPath)  {
        
        
        for dicChildren in ar {
            
            let indexToRemove:NSInteger = self.arrDataSource.indexOfObjectIdentical(to: dicChildren)
            let arrayChildren:NSArray = (dicChildren as! NSDictionary).value(forKey: keyChildren) as! NSArray
            
            if (arrayChildren.count > 0) {
                self.miniMizeThisRows(ar: arrayChildren, forTable: tableView, withIndexpath: indexPath)
            }
            
            if (self.arrDataSource.indexOfObjectIdentical(to: dicChildren) != NSNotFound) {
                self.arrDataSource.removeObject(identicalTo: dicChildren)
                
                tableView.deleteRows(at: [IndexPath(row: indexToRemove, section: indexPath.section)], with: .automatic)
            }
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: for avoiding nil we check if datasource have valid data to show
        if self.arrDataSource.count > 0 {
            return self.arrDataSource.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let objCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        objCell.indentationLevel = (self.arrDataSource[indexPath.row] as! NSDictionary).value(forKey: keyIndent) as! NSInteger
        
        objCell.lblTitle.text = (self.arrDataSource[indexPath.row] as! NSDictionary).value(forKey: keyTitle) as? String ?? ""
        
        objCell.lblLeadConstriant.constant = CGFloat(8+16*objCell.indentationLevel)
        
        return objCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict:NSDictionary = self.arrDataSource[indexPath.row] as! NSDictionary
        
        let indentLevel:NSInteger = (self.arrDataSource[indexPath.row] as!NSDictionary).value(forKey: keyIndent) as! NSInteger
        
        let indentArray:NSArray = self.arrDataSource.value(forKey: keyIndent) as! NSArray
        
        let indentChek:Bool = indentArray.contains(NSNumber.init(value: indentLevel))
        
        var isChildrenAlreadyInserted:Bool = self.arrDataSource.contains(dict.value(forKey: keyChildren)!)
        
        for dicChildren in dict.value(forKey: keyChildren) as! NSArray {
            
            let index:NSInteger = self.arrDataSource.indexOfObjectIdentical(to: dicChildren)
            isChildrenAlreadyInserted = (index>0 && index != NSIntegerMax)
            
            if (isChildrenAlreadyInserted) {
                break
            }
        }
        
        
        if ( indentChek &&  isChildrenAlreadyInserted) {
            
            let arr = (self.arrDataSource[indexPath.row] as! NSDictionary).value(forKey: keyChildren) as! NSArray
            self.miniMizeThisRows(ar: arr, forTable: tableView, withIndexpath: indexPath as NSIndexPath)
            
        }else if ((dict.value(forKey: keyChildren) as! NSArray).count > 0) {
            
            let ipsArray:NSMutableArray = NSMutableArray()
            let childArray:NSArray = dict.value(forKey: keyChildren) as! NSArray
            
            var count:NSInteger = indexPath.row + 1
            
            var i = 0
            while i < (dict[keyChildren] as! NSArray).count {
                let ip = IndexPath(row: count, section: indexPath.section)
                ipsArray.add(ip)
                self.arrDataSource.insert(childArray[i], at: count)
                i += 1
                count += 1
            }
            
            self.objTblView.beginUpdates()
            self.objTblView.insertRows(at: ipsArray as! [IndexPath], with: .automatic)
            self.objTblView.endUpdates()
        }else {
            // Perform operation related to selecat  depat.
        }
    }
}

