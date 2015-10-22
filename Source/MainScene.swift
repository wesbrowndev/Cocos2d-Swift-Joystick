import Foundation

class MainScene: CCNode {
    
    weak var dpad: CCSprite!
    weak var joystick: CCSprite!
    weak var player: CCSprite!
    
    var stickActive: Bool = false
    var velocity: CGPoint = CGPointMake(0, 0)
    var angularVelocity: CGFloat = 0
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
    }

    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let location = touch.locationInNode(self)
        
        if (CGRectContainsPoint(joystick.boundingBox(), location)) {
            stickActive = true
        } else {
            stickActive = false
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let location = touch.locationInNode(self)
        
        if (stickActive == true) {
            let vector = CGVector(dx: location.x - dpad.position.x, dy: location.y - dpad.position.y)
            let angle = atan2(vector.dy, vector.dx)
            let degree = angle * CGFloat(180 / M_PI)
            let radians = CGFloat(M_PI / 2)
            let length: CGFloat = dpad.boundingBox().size.height / 2
            let xDist: CGFloat = sin(angle - radians) * length
            let yDist: CGFloat = cos(angle - radians) * length
            
            joystick.position = CGPointMake(dpad.position.x - xDist, dpad.position.y + yDist)
            
            if (CGRectContainsPoint(dpad.boundingBox(), location)) {
                joystick.position = location
                
            } else {
                joystick.position = CGPointMake(dpad.position.x - xDist, dpad.position.y + yDist)
            }
            
            self.velocity = ccp(xDist * -0.1, yDist * 0.1)
            
            self.angularVelocity = -(degree - 90)
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (stickActive == true) {
            let move = CCActionMoveTo(duration: 0.1, position: dpad.position)
            joystick.runAction(move)
        }
        
        self.resetVelocity()
    }
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        self.resetVelocity()
    }
    
    override func update(delta: CCTime) {
        if self.velocity.x != 0 || self.velocity.y != 0 {
            player.position = ccpAdd(player.position, self.velocity)
        }
        
        if self.velocity.x != 0 || self.velocity.y != 0 {
            player.rotation = Float(self.angularVelocity)
        }
    }
    
    func resetVelocity() {
        self.velocity = CGPointZero
    }
}
