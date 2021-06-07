import Foundation

final class CallStation {
    var usersStorage: Set <User> = []
    var callsStorage: [CallID : Call] = [:]
    var currentCallsStorage: [UUID : Call] = [:]
    
}
extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension CallStation: Station {
    func users() -> [User] {
       Array(usersStorage)
    }
    
    func add(user: User) {
        usersStorage.insert(user)
    }
    
    func remove(user: User) {
        usersStorage.remove(user)
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
                
                case let .start(from: from, to: to):
                    
                    let callID = CallID()
                    if !usersStorage.contains(from){
                        return nil
                    }
                    if !usersStorage.contains(to){
                        let call = Call(id: callID, incomingUser: from, outgoingUser: to, status: .ended(reason: .error))
                        callsStorage[callID] = call
                        currentCallsStorage[from.id] = nil
                        currentCallsStorage[to.id] = nil
                        return callID
                    }
                    if currentCall(user: to) != nil{
                        let call = Call(id: callID, incomingUser: from, outgoingUser: to, status: .ended(reason: .userBusy))
                        callsStorage[callID] = call
                        return callID
                    }
                    let call = Call(id: callID, incomingUser: from, outgoingUser: to, status: .calling)
                    callsStorage[callID] = call
                    currentCallsStorage[from.id] = call
                    currentCallsStorage[to.id] = call
                    return callID
                
                case .answer(from: let to):
                    guard let call = currentCall(user: to) else {
                        return nil
                    }
                    
                    let from = call.incomingUser
                    if !usersStorage.contains(to) || !usersStorage.contains(from){
                        let badCall = Call(id: call.id, incomingUser: from, outgoingUser: to, status: .ended(reason: .error))
                        callsStorage[badCall.id] = badCall
                        currentCallsStorage[to.id] = nil
                        currentCallsStorage[from.id] = nil
                        return nil
                    }
                    
                    if let toCall = currentCall(user: to) {
                        if (toCall.status != .calling || toCall.id != call.id) {
                            let badCall = Call(id: call.id, incomingUser: from, outgoingUser: to, status: .ended(reason: .error))
                            callsStorage[badCall.id] = badCall
                            currentCallsStorage[to.id] = nil
                            currentCallsStorage[from.id] = nil
                            return nil
                        }
                        let goodCall = Call(id: call.id, incomingUser: from, outgoingUser: to, status: .talk)
                        callsStorage[goodCall.id] = goodCall
                        currentCallsStorage[to.id] = goodCall
                        currentCallsStorage[from.id] = goodCall
                        return goodCall.id
                    }
                    
                case .end(from: let from):
                    guard let call = currentCall(user: from) else {
                        return nil
                    }
                    let to = call.outgoingUser.id == from.id ? call.incomingUser : call.outgoingUser
                    
                    if !usersStorage.contains(from) || !usersStorage.contains(to){
                        let badCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
                        callsStorage[badCall.id] = badCall
                        currentCallsStorage[from.id] = nil
                        currentCallsStorage[to.id] = nil
                        return nil
                    }
                    if (currentCall(user: to)?.status != .talk) {
                        let badCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .cancel))
                        callsStorage[badCall.id] = badCall
                        currentCallsStorage[from.id] = nil
                        currentCallsStorage[to.id] = nil
                        return badCall.id
                    }
                    let goodCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .end))
                    callsStorage[goodCall.id] = goodCall
                    currentCallsStorage[from.id] = nil
                    currentCallsStorage[to.id] = nil
                    return goodCall.id
                    
                }
                return nil
    }
    
    func calls() -> [Call] {
        Array(callsStorage.values)
    }
    
    func calls(user: User) -> [Call] {
        Array(callsStorage.values.filter { $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id})
            
    }
    
    func call(id: CallID) -> Call? {
        callsStorage[id]
    }
    
    func currentCall(user: User) -> Call? {
        currentCallsStorage[user.id]
    }
}
