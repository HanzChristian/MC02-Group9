//
//  ViewController+TableViewDataSource.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 24/10/22.
//

import Foundation
import UIKit

extension ViewController:UITableViewDataSource{
    
    func mergeTV(){
        jadwalVars.removeAll()
        self.coreDataManager.fetchMedicine(tableView: tableView)
        self.coreDataManager.fetchBGTime(daySelected: daySelected)
        self.coreDataManager.fetchBG()
        
        var lowest = "24:00"
        var medIdx = 0
        var bgIdx = 0
        
        guard var medCopy = self.coreDataManager.items else{
            print("MASUK SINI med")
            return
        }
        
        guard var bgCopy = self.coreDataManager.bg else{
            print("MASUK SINI")
            return
        }
        
        print("INI MEDCOPY \(medCopy.count)")
        while(medCopy.count != 0){
            
            var idxBg = 0
            var idxLowestBg = -1
            var lowestBg = "24:00"
            
            
            for bg in bgCopy{
                if((bg.bg_time)! < medCopy[0].time! && (bg.bg_time)! < lowestBg){
                    lowestBg = (bg.bg_time)!
                    idxLowestBg = idxBg
                }
                idxBg += 1
               
            }
            
            if(idxLowestBg == -1){ //med lebih kecil
                jadwalVars.append(JadwalVars(type: "MED", idx: medIdx))
                medCopy.remove(at: 0)
                medIdx += 1
            }else{ //bg lebih kecil
                jadwalVars.append(JadwalVars(type: "BG", idx: getBgIdx(bG: bgCopy[idxLowestBg])))
                bgCopy.remove(at: idxLowestBg)
            }
        }
        //cari bg terkecil masuk ke jadwalVar
        for bg in bgCopy{
            jadwalVars.append(JadwalVars(type: "BG", idx: getBgIdx(bG: bg)))
            bgIdx += 1
        }
        
        for bg in coreDataManager.bg!{
            print("BGTIME \(bg.bg_time)")
        }
        print("JADWALVARS \(jadwalVars) \(coreDataManager.bg)")
       
    }
    
    func getBgIdx(bG:BG) -> Int{
        var i = 0
        for bg in coreDataManager.bg!{
            if(bg == bG){
                return i
            }
            i += 1
        }
        return -1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if(dataType == "BG"){
//            return self.coreDataManager.bgTime?.count ?? 0
//        }else{
//            return self.coreDataManager.items?.count ?? 0
//        }
        return jadwalVars.count ?? 0
       
    }
    
    func showToastSkip(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        
        toastLabel.backgroundColor = UIColor(rgb: 0xDE6FB3)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastTake(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        
        toastLabel.backgroundColor = UIColor(rgb: 0x56A3D4)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastUndo(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        toastLabel.backgroundColor = .gray
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TakeMedTableViewCell
        let check = jadwalVars[indexPath.row]
        
        if(check.type == "MED"){
            let medicine_time = self.coreDataManager.items![check.idx]
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
            cell.indexPath = indexPath.row
            
            for (index, log) in coreDataManager.logs!.enumerated() {
                if(log.time == cell.timeLbl.text && log.medicine_name == cell.medLbl.text){
                    
                    coreDataManager.undoIdx[indexPath.row] = index
                    coreDataManager.keTake[indexPath.row] = 1
                    
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
           
        }else{
            let bg = self.coreDataManager.bg?[check.idx]

            if(bg?.bg_type == 0){
                cell.freqLbl.text = "Gula Darah Puasa"
            }else if(bg?.bg_type == 1){
                cell.freqLbl.text = "Gula Darah Sesaat"
            }else{
                cell.freqLbl.text = "HBA1C"
            }
            
            cell.medLbl.text = "Cek Gula Darah"
            
            cell.timeLbl.text = bg?.bg_time
            
            for (index, log) in coreDataManager.logs!.enumerated() {
                if(log.bg_check_result != nil){
                    coreDataManager.undoIdx[indexPath.row] = index
                    coreDataManager.keTake[indexPath.row] = 1
                    
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
        return cell
    }
}