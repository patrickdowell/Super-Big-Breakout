//
//  GameScene.swift
//  Super Big Breakout
//
//  Created by Patrick Dowell on 4/1/19.
//  Copyright © 2019 Patrick Dowell. All rights reserved.
//

import SpriteKit
import GameplayKit

var ball = SKShapeNode()
var paddle = SKSpriteNode()
var brick = SKSpriteNode()
var bricks = [SKSpriteNode]()
var loseZone = SKSpriteNode()
var playingGame = false
let startLabel = SKLabelNode(fontNamed: "Arial")
var lives = 3
var livesLabel = SKLabelNode(fontNamed: "Arial")
var hitBricks = 0
var percentageLabel = SKLabelNode(fontNamed: "Arial")

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackground()
        makePaddle()
        makeLoseZone()
        makeStartLabel()
        makeBrickRow1()
        makeBrickRow2()
        makeBrickRow3()
        makeLivesLabel()
        makePercentageLabel()
    }

    func kickBall() {
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        addChild(ball) // add ball object to the view
    }
    
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }

    func makeBrickRow1() {
        var tracker = 0
        for x in 0...6 {
            let temp = CGFloat(x)
            var locationX = frame.minX + 25 + 60 * temp
            var locationY = frame.maxY - 50
            brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: locationX, y: locationY)
            brick.name = "\(tracker)"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            addChild(brick)
            bricks.append(brick)
            tracker += 1
        }
    }

    func makeBrickRow2() {
        var tracker = 8
        for x in 0...6 {
            var temp = CGFloat(x)
            var locationX = frame.minX + 25 + 60 * temp
            var locationY = frame.maxY - 80
            brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: locationX, y: locationY)
            brick.name = "\(tracker)"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            addChild(brick)
            bricks.append(brick)
            tracker += 1
        }
    }
    
    func makeBrickRow3() {
        var tracker = 15
        for x in 0...6 {
            var temp = CGFloat(x)
            var locationX = frame.minX + 25 + 60 * temp
            var locationY = frame.maxY - 110
            brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 20))
            brick.position = CGPoint(x: locationX, y: locationY)
            brick.name = "\(tracker)"
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
            brick.physicsBody?.isDynamic = false
            addChild(brick)
            bricks.append(brick)
            tracker += 1
        }
    }
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func makeStartLabel() {
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        startLabel.alpha = 0.20
        startLabel.fontColor = SKColor.gray
        startLabel.text = "Tap to Start"
        startLabel.fontSize = 60
        startLabel.name = "startLabel"
        addChild(startLabel)
    }

    func makeLivesLabel() {
        livesLabel.text = "Lives Left: \(lives)"
        livesLabel.color = SKColor.white
        livesLabel.position = CGPoint(x: frame.midX - 110, y: frame.minY + 15)
        livesLabel.fontSize = 25
        livesLabel.alpha = 1.0
        addChild(livesLabel)
    }
    
    func makePercentageLabel() {
        percentageLabel.text = "\(hitBricks) Bricks Hit"
        percentageLabel.color = SKColor.white
        percentageLabel.position = CGPoint(x: frame.midX + 110, y: frame.minY + 15)
        percentageLabel.fontSize = 25
        percentageLabel.alpha = 1.0
        addChild(percentageLabel)
    }
    
    func updatePercentage() {
        if hitBricks == 1 {
            percentageLabel.text = "\(hitBricks) Brick Hit"
        }
        else {
            percentageLabel.text = "\(hitBricks) Bricks Hit"
        }
    }
    
    func resetGame() {
        removeAllChildren()
        hitBricks = 0
        lives = 3
        createBackground()
        makePaddle()
        makeLoseZone()
        makeStartLabel()
        makeBrickRow1()
        makeBrickRow2()
        makeBrickRow3()
        makeLivesLabel()
        makePercentageLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if(playingGame){
                let location = touch.location(in: self)
                paddle.position.x = location.x
            }
            else if lives > 0 && hitBricks != 63{
                startLabel.alpha = 0
                makeBall()
                kickBall()
                playingGame = true
                print("zero")
                print(hitBricks)
            }
            else if lives == 0 && hitBricks != 63{
                resetGame()
                playingGame = false
                print("one")
            }
            else if hitBricks == 63 {
                resetGame()
                print("two")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        for identity in 0...21 {
            if contact.bodyA.node?.name == "\(identity)" ||
                contact.bodyB.node?.name == "\(identity)" {
                if let child = self.childNode(withName: "\(identity)") as? SKSpriteNode {
                    if child.color == .blue {
                        child.color = .green
                        hitBricks += 1
                        updatePercentage()
                    }
                    else if child.color == .green {
                        child.color = .orange
                        hitBricks += 1
                        updatePercentage()
                    }
                    else if child.color == .orange {
                        child.removeFromParent()
                        hitBricks += 1
                        updatePercentage()
                    }
                }
            }
        }
        
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "loseZone" {
            ball.removeFromParent()
            lives -= 1
            livesLabel.text = "Lives Left: \(lives)"
            playingGame = false
            if lives > 0 {
                startLabel.alpha = 0.20
                startLabel.fontSize = 45
                startLabel.fontColor = SKColor.red
                startLabel.text = "You Lost! -1 Life"
            }
            else if lives == 0 {
                startLabel.alpha = 1.0
                startLabel.fontSize = 30
                startLabel.fontColor = SKColor.red
                startLabel.text = "Game Over! Try Again?"
            }
        }
        
        if hitBricks == 63 {
            startLabel.alpha = 1.0
            startLabel.fontSize = 30
            startLabel.fontColor = SKColor.green
            startLabel.text = "You Win! Play Again?"
            playingGame = false
            ball.removeFromParent()
        }
    }
}
