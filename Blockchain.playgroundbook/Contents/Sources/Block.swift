import Foundation

// The longer this prefix is, the more computanionally expensive is the mining process.
let proofOfWorkPrefix = "000"

public class ProxyBlock {
    var value: String
    var previousBlock: ProxyBlock?
    var previousHash: String?
    var proofOfWork: Int?
    let isChainValid: Bool
    
    public init(value: String, previousBlock: ProxyBlock?, previousHash: String?, isChainValid: Bool) {
        self.value = value
        self.previousBlock = previousBlock
        self.previousHash = previousHash
        self.isChainValid = isChainValid
    }
    
    func shaHash() -> String {
        return "\(value)\(previousHash)\(proofOfWork)".shaHash()
    }
}

