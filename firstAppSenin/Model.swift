//
//  Model.swift
//  firstAppSenin
//
//  Created by Vadim on 15.09.2021.
//

import UIKit


//http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002

class Currency {
    var numCode: String?
    var charCode: String?
    var nominal: String?
    var nominalDouble: Double?
    var name: String?
    var value: String?
    var valueDouble: Double?
    var imageFlag: UIImage? {
        
        return UIImage(named: charCode!)
    }
    
    class func rouble() -> Currency {
        let r = Currency()
        r.charCode = "RUR"
        r.name = "Российский рубль"
        r.nominal = "1"
        r.nominalDouble = 1
        r.value = "1"
        r.valueDouble = 1
        
        return r
    }

}

class Model: NSObject, XMLParserDelegate {
   
    static let shared = Model()
    
    
    //converting
    var from: Currency = Currency.rouble()
    var to: Currency = Currency.rouble()

    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        let d = ((from.nominalDouble! * from.valueDouble!) / (to.nominalDouble! * to.valueDouble!)) * amount!
        return String(d)
    }
    
    //обновление from to
    
    var fromChar: String? = nil
    var toChar: String? = nil
    
    func updateFromTo() {
        for currency in currencies {
            if currency.charCode == from.charCode {
                from = currency
                print("yes")
            }
            if currency.charCode == to.charCode {
                to = currency
                print("yes")
            }
        } 
    }
    
    
    
    //parsing валют
    
    var currencies: [Currency] = []
    
    var currentDate: String = ""
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
        
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        return Bundle.main.path(forResource: "XML_daily", ofType: "xml")!
        
    
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
    //загрузка xml с cbr.ru и сохранение его в каталоге приложения
    func loadXMLFile(date: Date?) {
        
        
        
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl+dateFormatter.string(from: date!)
            
        }
        
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            
            var errorGlobal: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                
                
                do {
                    try data?.write(to: urlForSave)
                    print("Файл загружен")
                    print(path)
                    self.parseXML()
                } catch {
                    print("Error when save data:\(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
                
            } else {
                print("Error when loadXMLFile:"+error!.localizedDescription)
                errorGlobal = error?.localizedDescription
            }
            
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name( "ErrorWhenXMLLoading"), object: self, userInfo: ["ErrorGlobal" : errorGlobal])
            }
            
            
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("startLoadingXML"), object: self)
        
        task.resume()
    }
    
    //распарсить XML и положить его в currencies: [Currency], отправить уведомление приложению о том что данные обновились
    func parseXML() {
        currencies = [Currency.rouble()]
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        updateFromTo()
        print("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name("dataRefreshed"), object: self)
    }
    
    
    
    
    
    
    
    
    var currentCurrency: Currency?
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        if elementName == "NumCode" {
            currentCurrency?.numCode = currentCharacters
        }
        
        if elementName == "CharCode" {
            currentCurrency?.charCode = currentCharacters
        }
        
        
        if elementName == "Nominal" {
        currentCurrency?.nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters)
        }
        
        if elementName == "Name" {
        currentCurrency?.name = currentCharacters
        }
        
        if elementName == "Value" {
        currentCurrency?.value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
    }

    
    
    
    
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }
    
    
}
