//#-hidden-code
import PlaygroundSupport
import Darwin
func randomInt() -> Int {
    return Int(arc4random())
}
//#-end-hidden-code
//: # That's it!
//: We now built our own blockchain! It isn't that hard, right? Here's the complete source code, have fun playing around with it.
let proofOfWorkPrefix = "00"

class Block {
    var value: String
    var previousBlock: Block?
    var previousHash: String?
    var proofOfWork: Int?
    let isFirstBlock: Bool
    
    init(value: String, previousBlock: Block?, previousHash: String?) {
        self.value = value
        self.previousBlock = previousBlock
        self.previousHash = previousHash
        isFirstBlock = (previousBlock == nil && previousHash == nil)
        latestBlock = self
    }
    
    func shaHash() -> String {
        return "\(value)\(previousHash)\(proofOfWork)".shaHash()
    }

    func mineProofOfWork() {
        while !shaHash().starts(with: proofOfWorkPrefix) {
            proofOfWork = randomInt()
        }
    }
    
    func isChainValid() -> Bool {
        if !shaHash().starts(with: proofOfWorkPrefix) {
            return false
        }
        if isFirstBlock {
            return true
        }
        return previousHash! == previousBlock!.shaHash() && previousBlock!.isChainValid()
    }
}
var latestBlock: Block?
let block1 =  Block(value: "Frederik paid 3 Bitcoin to Larissa.", previousBlock: nil, previousHash: nil)
block1.mineProofOfWork()
let block2 =  Block(value: "Larissa paid 1 Bitcoin to Markus.", previousBlock: block1, previousHash: block1.shaHash())
block2.mineProofOfWork()
let block3 =  Block(value: "Markus paid 2 Bitcoin to Robbie.", previousBlock: block2, previousHash: block2.shaHash())
block3.mineProofOfWork()

block3.isChainValid()
//#-hidden-code
if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
    
    var proxyArray = Array<PlaygroundValue>()
    var currentBlock:Block? = latestBlock
    while currentBlock != nil {
        var proofOfWork = 0
        if let pof = currentBlock!.proofOfWork {
            proofOfWork = pof
        }
        var previousHash = ""
        if let ph = currentBlock!.previousHash {
            previousHash = ph
        }
        proxyArray.append(PlaygroundValue.dictionary([
            "value": PlaygroundValue.string(currentBlock!.value),
            "proofOfWork": PlaygroundValue.integer(proofOfWork),
            "previousHash": PlaygroundValue.string(previousHash),
            "isChainValid": PlaygroundValue.boolean(currentBlock!.isChainValid())
        ]))
        currentBlock = currentBlock!.previousBlock
    }
    
    let array = PlaygroundValue.array(proxyArray.reversed())
    proxy.send(array)
}
//#-end-hidden-code
