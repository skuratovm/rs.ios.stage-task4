import Foundation

struct Element: Equatable {
    var row: Int
    var column: Int
}


final class FillWithColor {
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
    
        if image.isEmpty || row < 0 || column < 0 || row >= image.count || column >= image[0].count {
                    return image
                }
        var outImage = image
                var queue = [Element(row: row, column: column)]
                var proceedElements = Array<Element>()
                let elementColor = image[row][column]
        
        while queue.count > 0 {
                    let element = queue.remove(at: 0)
                    proceedElements.append(element)
                    
                    if (image[element.row][element.column] == elementColor) {
                        outImage[element.row][element.column] = newColor
                    } else {
                        continue
                    }
                    
                    if (element.row - 1) >= 0 {
                        let element = Element(row: element.row - 1, column: element.column)
                        if !proceedElements.contains(element) {
                            queue.append(element)
                        }
                    }
                    if (element.row + 1) < image.count {
                        let element = Element(row: element.row + 1, column: element.column)
                        if !proceedElements.contains(element) {
                            queue.append(element)
                        }
                    }
                    if (element.column - 1) >= 0 {
                        let element = Element(row: element.row, column: element.column - 1)
                        if !proceedElements.contains(element) {
                            queue.append(element)
                        }
                    }
                    if (element.column + 1) < image[row].count {
                        let element = Element(row: element.row, column: element.column + 1)
                        if !proceedElements.contains(element) {
                            queue.append(element)
                        }
                    }
                }
                return outImage
        
    
    
    }
    
}

