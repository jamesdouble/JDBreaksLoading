//
//  JDBreaksScene.swift
//  JDBreaksLoading
//
//  Created by 郭介騵 on 2016/12/14.
//  Copyright © 2016年 james12345. All rights reserved.
//

import SpriteKit
import GameplayKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4

class JDBreaksScene: SKScene{
    
    var isFingerOnPaddle = false
    var ball:SKShapeNode!
    var gameWon : Bool = false {
        didSet {
            if(gameWon)
            {
                addBlock()
            }

        }
    }
    
    var d_ballwidth:CGFloat = 20.0
    var ballwidth:CGFloat = 0.0
    var ballcolor:UIColor = UIColor.white
    
    var d_paddlewidth:CGFloat = 60
    var paddlewidth:CGFloat = 0.0
    var paddlecolor:UIColor = UIColor.white
    
    var defaultwindowwidth:CGFloat = 200.0
    var windowscale:CGFloat = 1.0
    
    var d_blockwidth:CGFloat = 40.0
    var blockwidth:CGFloat = 0.0
    var blockscolor:UIColor = UIColor.white
    
    var blockscount:Int = 3
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    init(size: CGSize,configuration:JDBreaksGameConfiguration) {
        super.init(size: size)
        ballcolor = configuration.ball_color
        paddlecolor = configuration.paddle_color
        blockscolor = configuration.block_color
        blockscount = configuration.blocks_count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        windowscale = (self.frame.width / defaultwindowwidth)
        ballwidth = d_ballwidth * windowscale
        paddlewidth = d_paddlewidth * windowscale
        blockwidth = d_blockwidth * windowscale
        
        self.backgroundColor = UIColor.clear
        
        //Set Border
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        //Add Ball
        ball = SKShapeNode(circleOfRadius: ballwidth/2)
        ball.fillColor = ballcolor
        ball.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.width * 0.5)
        ball.name = BallCategoryName
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width * 0.5)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.allowsRotation = false
        self.addChild(ball)
        
        //No gravity
        self.physicsWorld.gravity = CGVector(dx: 0.05, dy: -0.5)
        physicsWorld.contactDelegate = self
        ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        
        //Add Paddle
        let paddlesize:CGSize = CGSize(width: paddlewidth, height: 15)
        let paddle:SKShapeNode = SKShapeNode(rectOf: paddlesize, cornerRadius: 5)
        paddle.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.width * 0.2)
        paddle.fillColor = paddlecolor
        paddle.name = PaddleCategoryName
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.allowsRotation = true
        paddle.physicsBody?.angularDamping = 0.1
        paddle.physicsBody?.linearDamping = 0.1
        self.addChild(paddle)
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        addBlock()
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory
        
       
    }
    
    func addBlock()
    {
        // 新增方塊
        let numberOfBlocks = blockscount
        let blockWidth:CGFloat = blockwidth
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
        // 2
        let xOffset = (frame.width - totalBlocksWidth) / 2
        // 3
        for i in 0..<numberOfBlocks {
            let block = SKShapeNode(rectOf: CGSize(width: blockWidth, height: 15))
            block.strokeColor = UIColor.black
            block.fillColor = blockscolor
            block.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) + 0.5) * blockWidth,
                                     y: frame.height * 0.8)
            
            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.affectedByGravity = false
            block.physicsBody!.isDynamic = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            block.zPosition = 2
    
            addChild(block)
        }
        
    }
    
    func breakBlock(node: SKNode) {
        if( SKEmitterNode(fileNamed: "BrokenPlatform") != nil)
        {
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                             SKAction.removeFromParent()]))
        }

        node.removeFromParent()
    }
    
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    /*
     This method checks to see how many bricks are left in the scene by going through all the scene’s children. For each child, it checks whether the child name is equal to BlockCategoryName. If there are no bricks left, the player has won the game and the method returns true.
     */
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        self.enumerateChildNodes(withName: BlockCategoryName) {
            node, stop in
            numberOfBricks = numberOfBricks + 1  //有磚塊存在就＋１
            
        }
        return numberOfBricks == 0
    }
    
}

extension JDBreaksScene
{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == PaddleCategoryName {
                isFingerOnPaddle = true
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 是否壓著Bar
        if isFingerOnPaddle {
            // 2
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            // 3
            let paddle = childNode(withName: PaddleCategoryName) as! SKShapeNode
            // Take the current position and add the difference between the new and the previous touch locations.
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            // Before repositioning the paddle, limit the position so that the paddle will not go off the screen to the left or right.
            paddleX = max(paddleX, paddle.frame.size.width/2)
            paddleX = min(paddleX, size.width - paddle.frame.size.width/2)
            // 6
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
}


extension JDBreaksScene:SKPhysicsContactDelegate
{
    /*
     Delegate
     */
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // 3
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
          
        }
        // 球碰到磚塊
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            breakBlock(node: secondBody.node!)
            gameWon = isGameWon()
        }
    }

    
    
}


