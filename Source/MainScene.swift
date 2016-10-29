import Foundation

class MainScene: CCNode {
    
    weak var dpad: CCSprite!
    weak var joystick: CCSprite!
    weak var player: CCSprite!
    
    var stickActive: Bool = false
    var velocity: CGPoint = CGPoint(x: 0, y: 0)
    var angularVelocity: CGFloat = 0
    
    override init!() {
        super.init()
        
        isUserInteractionEnabled = true
    }

    override func touchBegan(_ touch: CCTouch!, with event: CCTouchEvent!) {
        let location = touch.location(in: self)
        
        if (joystick.boundingBox().contains(location)) {
            stickActive = true
        } else {
            stickActive = false
        }
    }
    
    override func touchMoved(_ touch: CCTouch!, with event: CCTouchEvent!) {
        let location = touch.location(in: self)
        
        if (stickActive == true) {
            let vector = CGVector(dx: location.x - dpad.position.x, dy: location.y - dpad.position.y)
            let angle = atan2(vector.dy, vector.dx)
            let degree = angle * CGFloat(180 / M_PI)
            let radians = CGFloat(M_PI / 2)
            let length: CGFloat = dpad.boundingBox().size.height / 2
            let xDist: CGFloat = sin(angle - radians) * length
            let yDist: CGFloat = cos(angle - radians) * length
            
            joystick.position = CGPoint(x: dpad.position.x - xDist, y: dpad.position.y + yDist)
            
            if (dpad.boundingBox().contains(location)) {
                joystick.position = location
                
            } else {
                joystick.position = CGPoint(x: dpad.position.x - xDist, y: dpad.position.y + yDist)
            }
            
            self.velocity = ccp(xDist * -0.1, yDist * 0.1)
            
            self.angularVelocity = -(degree - 90)
        }
    }
    
    override func touchEnded(_ touch: CCTouch!, with event: CCTouchEvent!) {
        if (stickActive == true) {
            let move = CCActionMoveTo(duration: 0.1, position: dpad.position)
            joystick.run(move)
        }
        
        self.resetVelocity()
    }
    
    override func touchCancelled(_ touch: CCTouch!, with event: CCTouchEvent!) {
        self.resetVelocity()
    }
    
    override func update(_ delta: CCTime) {
        if self.velocity.x != 0 || self.velocity.y != 0 {
            player.position = ccpAdd(player.position, self.velocity)
        }
        
        if self.velocity.x != 0 || self.velocity.y != 0 {
            player.rotation = Float(self.angularVelocity)
        }
    }
    
    func resetVelocity() {
        self.velocity = CGPoint.zero
    }
}
