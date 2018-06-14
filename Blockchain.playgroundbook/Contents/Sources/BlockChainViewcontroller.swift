import UIKit
import QuartzCore
import SceneKit
import PlaygroundSupport

public class BlockChainViewController : UIViewController, PlaygroundLiveViewMessageHandler {
    
    let scene = SCNScene()
    let defaultProxyBlockChain: ProxyBlock
    
    public init(defaultProxyBlockChain: ProxyBlock) {
        self.defaultProxyBlockChain = defaultProxyBlockChain
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.defaultProxyBlockChain = ProxyBlock(value: "This is the value of the block.", previousBlock: nil, previousHash: nil, isChainValid: true)
        super.init(coder: aDecoder)
    }
    
    public func setBlockChain(blockchain: ProxyBlock) {
        scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        var numberOfBlocks = 0
        var currentBlock:ProxyBlock? = blockchain
        while currentBlock != nil {
            numberOfBlocks+=1
            currentBlock = currentBlock?.previousBlock
        }

        var defaultZoomLevel = 4.0
        if numberOfBlocks == 1 {
            defaultZoomLevel = 1.75
        }
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(defaultZoomLevel))
        
        var index = 0
        currentBlock = blockchain
        while currentBlock != nil {
            addBlock(block: currentBlock!, position: positionForIndex(index: index, numberOfBlocks: numberOfBlocks), index: numberOfBlocks-index)
            if currentBlock?.previousBlock != nil {
                var color = UIColor.red
                if currentBlock!.isChainValid {
                    color = UIColor.green
                }
                addLine(position1: positionForIndex(index: index, numberOfBlocks: numberOfBlocks), position2: positionForIndex(index: index+1, numberOfBlocks: numberOfBlocks), color: color)
            }
            index += 1
            currentBlock = currentBlock?.previousBlock
        }
        
    }
    
    func positionForIndex(index: Int, numberOfBlocks: Int) -> SCNVector3 {
        let size = Int(sqrt(Double(numberOfBlocks)))
        
        let x = index % size
        let y = Int(index / size)
        return SCNVector3(x - size/2, y - size/2, 0)
    }
    
    func addBlock(block: ProxyBlock, position: SCNVector3, index: Int) {
        let layer = CATextLayer()
        layer.string = "\n#\(index)\n\n\(block.value)"
        layer.isWrapped = true
        layer.foregroundColor = UIColor.white.cgColor
        layer.backgroundColor = UIColor.orange.cgColor
        layer.alignmentMode = kCAAlignmentCenter
        layer.fontSize = 50
        layer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        let frontMaterial = SCNMaterial()
        frontMaterial.locksAmbientWithDiffuse = true
        frontMaterial.diffuse.contents = layer
        
        let sideMaterial = SCNMaterial()
        sideMaterial.diffuse.contents = UIColor.orange
        
        let box1 = SCNBox(width: 0.4, height: 0.4, length: 0.1, chamferRadius: 0.025)
        box1.materials = [frontMaterial,sideMaterial,sideMaterial,sideMaterial,sideMaterial,sideMaterial]
        let node1 = SCNNode(geometry: box1)
        node1.position = position
        
        scene.rootNode.addChildNode(node1)
    }
    
    func addLine(position1: SCNVector3, position2: SCNVector3, color: UIColor) {
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(position1), SCNVector3ToGLKVector3(position2)))
        let startNode = SCNNode()
        let endNode = SCNNode()
        
        startNode.position = position1
        endNode.position = position2
        
        let zAxisNode = SCNNode()
        zAxisNode.eulerAngles.x = Float(Double.pi / 2)
        
        let lineGeometry = SCNCylinder(radius: 0.01, height: height)
        lineGeometry.firstMaterial?.diffuse.contents = color
        let cylinder = SCNNode(geometry: lineGeometry)
        
        cylinder.position.y = Float(-height/2.0)
        zAxisNode.addChildNode(cylinder)
        
        let lineNode = SCNNode()
        
        if (position1.x > 0.0 && position1.y < 0.0 && position1.z < 0.0 && position2.x > 0.0 && position2.y < 0.0 && position2.z > 0.0) {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            lineNode.addChildNode(endNode)
        } else if (position1.x < 0.0 && position1.y < 0.0 && position1.z < 0.0 && position2.x < 0.0 && position2.y < 0.0 && position2.z > 0.0) {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            lineNode.addChildNode(endNode)
        } else if (position1.x < 0.0 && position1.y > 0.0 && position1.z < 0.0 && position2.x < 0.0 && position2.y > 0.0 && position2.z > 0.0) {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            lineNode.addChildNode(endNode)
        } else if (position1.x > 0.0 && position1.y > 0.0 && position1.z < 0.0 && position2.x > 0.0 && position2.y > 0.0 && position2.z > 0.0) {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            lineNode.addChildNode(endNode)
        } else {
            startNode.addChildNode(zAxisNode)
            startNode.constraints = [ SCNLookAtConstraint(target: endNode) ]
            lineNode.addChildNode(startNode)
        }
        
        scene.rootNode.addChildNode(lineNode)
    }
    
    let cameraNode = SCNNode()
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        // create and add a camera to the scene
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        self.view = SCNView()
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = scene
        
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = false
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        
        setBlockChain(blockchain: defaultProxyBlockChain)
    }
    
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    public func receive(_ message: PlaygroundValue) {
        var blockArray = Array<ProxyBlock>()
        guard case let .array(array) = message else {return}
        
        for dict in array {
            guard case let .dictionary(blockDict) = dict else {return}
            if case let .string(value)? = blockDict["value"] {
                if case let .integer(proofOfWork)? = blockDict["proofOfWork"] {
                    if case let .string(previousHash)? = blockDict["previousHash"] {
                        if case let .boolean(isChainValid)? = blockDict["isChainValid"] {
                            let block = ProxyBlock(value: value, previousBlock: blockArray.last, previousHash: previousHash, isChainValid: isChainValid)
                            block.proofOfWork = proofOfWork
                            blockArray.append(block)
                        }
                    }
                }
            }
        }
        setBlockChain(blockchain: blockArray.last!)
    }
}
