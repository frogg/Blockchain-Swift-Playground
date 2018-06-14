//#-hidden-code
import PlaygroundSupport
//#-end-hidden-code
//: # Attempting to Hack the Blockchain
//: To show you the benefits of the blockchain, we will try to hack it by pretending that someone sent a large amount of bitcoin to ourselves.
//#-hidden-code
class Block {
    var value: String
    var previousBlock: Block?
    var previousHash: String?
    let isFirstBlock: Bool
    
    init(value: String, previousBlock: Block?, previousHash: String?) {
        self.value = value
        self.previousBlock = previousBlock
        self.previousHash = previousHash
        isFirstBlock = (previousBlock == nil && previousHash == nil)
    }
    
    func shaHash() -> String {
        return "\(value)\(previousHash)".shaHash()
    }
    
    func isChainValid() -> Bool {
        if isFirstBlock {
            return true
        }
        return previousHash! == previousBlock!.shaHash() && previousBlock!.isChainValid()
    }
}
//#-end-hidden-code

let block1 =  Block(value: /*#-editable-code*/"Frederik paid 3 Bitcoin to Larissa."/*#-end-editable-code*/, previousBlock: nil, previousHash: nil)
let block2 =  Block(value: /*#-editable-code*/"Larissa paid 1 Bitcoin to Markus."/*#-end-editable-code*/, previousBlock: block1, previousHash: block1.shaHash())
let block3 =  Block(value: /*#-editable-code*/"Markus paid 2 Bitcoin to Robbie."/*#-end-editable-code*/, previousBlock: block2, previousHash: block2.shaHash())

block3.isChainValid()
//: At this point, we're now manipulating the blockchain afterwards. This invalidates the blockchain because the hashes don't match anymore.
block2.value = /*#-editable-code*/"Larissa paid 999999 Bitcoin to Frederik."/*#-end-editable-code*/
block3.isChainValid()
//: To make the chain valid again, we would need to re-calculate all hashes of the following blocks again because the hash of a block is depending on `previousHash`. To prevent re-building the chain, we have to make the hash-calculation computationally expensive. The goal is that it takes long time, computing power and random luck to calculate it. This is called the `proof of work`. We will implement it on the [next page](@next)!
//#-hidden-code
if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
    
    var proxyArray = Array<PlaygroundValue>()
    var currentBlock:Block? = block3
    while currentBlock != nil {
        proxyArray.append(PlaygroundValue.dictionary([
            "value": PlaygroundValue.string(currentBlock!.value),
            "proofOfWork": PlaygroundValue.integer(0),
            "previousHash": PlaygroundValue.string(""),
            "isChainValid": PlaygroundValue.boolean(currentBlock!.isChainValid())
            ]))
        currentBlock = currentBlock!.previousBlock
    }
    
    let array = PlaygroundValue.array(proxyArray.reversed())
    proxy.send(array)
}
//#-end-hidden-code

