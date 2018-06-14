//#-hidden-code
import PlaygroundSupport
import Darwin
//#-end-hidden-code
//: # Finding Consensus in a Decentralized Network: Proof of Work.
//: Now that we built up the blockchain, how do we share it with others and make sure that we can trust it without a central institution? This is where `proof of work` comes into place!
class Block {
    var value: String
    var previousBlock: Block?
    var previousHash: String?
    var proofOfWork: Int?
    //#-hidden-code
    let isFirstBlock: Bool
    
    init(value: String, previousBlock: Block?, previousHash: String?) {
        self.value = value
        self.previousBlock = previousBlock
        self.previousHash = previousHash
        isFirstBlock = (previousBlock == nil && previousHash == nil)
    }
    //#-end-hidden-code
    func shaHash() -> String {
        return "\(value)\(previousHash)\(proofOfWork)".shaHash()
    }
//: This is the point where the proof of work is generated for this block. Because the `.shaHash()` function is not predictable all we can do is guessing the `proofOfWork` and checking. This requires time and computing power. And because everyone can be a miner and contribute to the decentralized network, everyone is competing with each other in finding the `proofOfWork` first. The first who finds it receives a reward (from the transaction fees).
    func mineProofOfWork() {
        while !shaHash().starts(with: proofOfWorkPrefix) {
            proofOfWork = randomInt()
        }
    }
}
//#-hidden-code
func randomInt() -> Int {
    return Int(arc4random())
}
//#-end-hidden-code
let proofOfWorkPrefix = /*#-editable-code*/"000"/*#-end-editable-code*/

let block1 =  Block(value: "Frederik paid 3 Bitcoin to Larissa.", previousBlock: nil, previousHash: nil)
block1.mineProofOfWork()
let block2 =  Block(value: "Larissa paid 1 Bitcoin to Markus.", previousBlock: block1, previousHash: block1.shaHash())
block2.mineProofOfWork()
let block3 =  Block(value: "Markus paid 2 Bitcoin to Robbie.", previousBlock: block2, previousHash: block2.shaHash())
block3.mineProofOfWork()

//: This `proofOfWork` is now added to our `isChainValid()` function:
extension Block {
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

block3.isChainValid()
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
//: If we would now try to manipulate the blockchain as on the [Previous Page](@previous), we would not only need to recalculate all the hashes, we would also need to recalculate the `proofOfWork` for each block. In our example, the chain is short and the `proofOfWorkPrefix` is short as well. Bitcoin requires at least `18` leadning zeros in the hash, which makes it really hard to calculate: The chance to find it in one try is 1/(16^18). For a hacker to sustain control over the consensus in the blockchain would require to have control over more than 50% of the computing power, which is close to impossible.

//: [Next Page](@next)
