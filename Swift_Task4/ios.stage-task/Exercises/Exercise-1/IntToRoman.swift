import Foundation

public extension Int {
    
    

    var roman: String? {
           
        var integerValue = self
        if self < 1 || self > 3999
                {return nil }
        var numeralString = ""
        let mappingList: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        for i in mappingList {
            while (integerValue >= i.0) {
                integerValue -= i.0
                numeralString += i.1
                if  integerValue == 0 {
                                break
                            }
            }
           
        }
        return numeralString
        
       
        
       }
}
