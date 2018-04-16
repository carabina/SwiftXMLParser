
import Foundation

class Stack <T>:NSObject{
    var stackArray = [T]()
    //create push function
    //create pop function
    
    func push(stringToPush: T){
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> T? {
        if self.stackArray.last != nil {
            let stringToReturn = self.stackArray.last
            self.stackArray.removeLast()
            return stringToReturn!
        } else {
            return nil
        }
    }
    func peek() -> T? {
        if !self.stackArray.isEmpty {
            return self.stackArray.last
        } else {
            return nil
        }
    }
}



