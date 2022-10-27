//
//  ViewController+Rx.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 26/10/22.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit


extension ViewController{
    
    
    func bindDataToTableView(){
        
        coreDataManager.jadwal.asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: "cell", cellType: TakeMedTableViewCell.self))
        {
            [weak self] index, element, cell in
                cell.idx = index
                cell.identity = element
                if(element.type == "MED"){
                    self!.setupCellMed(cell: cell, element: element)
                }else{
                    self!.setupCellBG(cell: cell, element: element)
                }
            cell.takeBtn.rx.tap
                .subscribe(onNext: { [weak self] in
                    print("take btn on click rx \(cell.medLbl!.text) index: \(cell.idx)")
                    let realIdx = cell.identity.idx
                    
                    if(cell.identity.type == "BG"){
                        
                        self!.makeSheet(index: realIdx)
                    }else{
                        print("click rx medicineName \(self!.coreDataManager.items![cell.identity.idx].medicine?.name) with index \(cell.identity.idx)")
//                        self!.makeSheet(index: realIdx)
                        self!.makeSheetMed(index: realIdx)
                    }
                    
                    
                    
                }).disposed(by: cell.disposeBag)
            
            
        }.disposed(by: disposeBag)
        
        
    }
    
    func setupCellBG(cell: TakeMedTableViewCell, element: JadwalVars){
        let bg = self.coreDataManager.bg?[element.idx]

        if(bg?.bg_type == 0){
            cell.freqLbl.text = "Gula Darah Puasa"
        }else if(bg?.bg_type == 1){
            cell.freqLbl.text = "Gula Darah Sesaat"
        }else{
            cell.freqLbl.text = "HBA1C"
        }

        cell.medLbl.text = "Cek Gula Darah"

        cell.timeLbl.text = bg?.bg_time

        for (i, log) in self.coreDataManager.logs!.enumerated() {
            if(log.bg_check_result != nil){
                self.coreDataManager.undoIdx[element.idx] = i
//                        self!.coreDataManager.keTake[element.idx] = 1
                if(log.action == "Skip"){
                    cell.tintColor = UIColor.red
                    cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
                    //                        cell.cellImgView.layer.opacity = 0.3
                    //                        cell.indicatorImgView.image = UIImage(named: "Subtract")
                }else{
                    cell.tintColor = UIColor.green
                    cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)
                }
            }
        }
    }
    
    
    func setupCellMed(cell: TakeMedTableViewCell, element: JadwalVars){
        let medicine_time = self.coreDataManager.items![element.idx]
        cell.medLbl.text = medicine_time.medicine?.name
        if(medicine_time.medicine?.eat_time == 2){
            cell.freqLbl.text = "Sesudah makan"
        }
        else if(medicine_time.medicine?.eat_time == 1){
            cell.freqLbl.text = "Sebelum makan"
        }
        else if(medicine_time.medicine?.eat_time == 3){
            cell.freqLbl.text = "Bersamaan dengan makan"
        }else{
            cell.freqLbl.text = "Waktu Spesifik"
        }
        cell.timeLbl.text = medicine_time.time
        cell.tintColor = UIColor.blue
        cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)

        for (index, log) in self.coreDataManager.logs!.enumerated() {
            if(log.time == cell.timeLbl.text && log.medicine_name == cell.medLbl.text){

                self.coreDataManager.undoIdx[element.idx] = index
                self.coreDataManager.keTake[element.idx] = 1

                if(log.action == "Skip"){
                    cell.tintColor = UIColor.red
                    cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
                    //                        cell.cellImgView.layer.opacity = 0.3
                    //                        cell.indicatorImgView.image = UIImage(named: "Subtract")
                }else{
                    // Create Date Formatter
                    let dateFormatter = DateFormatter()

                    // Set Date/Time Style
                    dateFormatter.dateStyle = .long
                    dateFormatter.timeStyle = .short
                    dateFormatter.dateFormat = "HH:mm"

                    // Convert Date to String
                    var date = dateFormatter.string(from: log.dateTake!)

                    cell.tintColor = UIColor.green
                    cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)

                    cell.freqLbl.text = "Diminum pada \(date)"
                }
                break
            }

        }
    }
    
    
}
