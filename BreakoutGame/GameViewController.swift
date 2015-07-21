//
//  GameViewController.swift
//  BreakoutGame
//
//  Created by Lee on 2015/5/5.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {

	@IBOutlet var gameView: UIView!
	var ballSize = CGSize(width: 20, height: 20)
	var brickPerRow = 5
	var brickHightPerRow = 30
	var brickHight = 4
	var padding: CGFloat = 0.0
	var boardWidth: CGFloat = 0.0
	var boardHeight: CGFloat { get { return 0.3 * boardWidth} }
	var ball = UIView()
	var brickSize: CGSize {
		let sizeWithoutPadding = gameView.bounds.size.width / CGFloat(brickPerRow)
		let padding = sizeWithoutPadding / CGFloat(brickPerRow + 1)
		self.padding = CGFloat(padding)
		let size = sizeWithoutPadding - padding
		boardWidth = size * 1.2
		return CGSize(width: size, height: CGFloat(brickHightPerRow))
	}
	var selectedView: UIView?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		circumstanceBehavior.collider.translatesReferenceBoundsIntoBoundary = true
		circumstanceBehavior.collider.collisionDelegate = self
		animator.addBehavior(circumstanceBehavior)
		for var hight = 0; hight < brickHight; hight++ {
			for var row = 0; row < brickPerRow; row++ {
				Brick(row, culomn: hight)
			}
		}
		board()
		addball()
		
	}
	let circumstanceBehavior = CircumstanceBehavior()
	lazy var animator: UIDynamicAnimator = {
		let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
		return lazilyCreatedDynamicAnimator
	}()
	func Brick(row: Int, culomn: Int) {
		var frame = CGRect(origin: CGPointZero, size: brickSize)
		var point = CGPoint(x: CGFloat(row) * (padding + brickSize.width) + padding/2, y: CGFloat(culomn) * (padding + brickSize.height) + padding)
		frame.origin = point
		let brickView = UIView(frame: frame)
		brickView.backgroundColor = UIColor.blueColor()
		brickView.tag = row * 10 + culomn
		circumstanceBehavior.addbrick(brickView)
	}
	func addball() {
		var frame = CGRect(origin: CGPointZero, size: ballSize)
		ball = UIView(frame: frame)
		ball.center = CGPoint(x: selectedView!.center.x, y: selectedView!.center.y - ball.frame.size.height)
		ball.layer.cornerRadius = self.ball.frame.size.height / 2
		ball.backgroundColor = UIColor.redColor()
		var startGame = UITapGestureRecognizer(target: self, action: "startGame:")
		ball.addGestureRecognizer(startGame)
		circumstanceBehavior.addball(self.ball)
	}
	func startGame(sender: UITapGestureRecognizer) {
		println("start game")
		circumstanceBehavior.startGame()
	}
	func board() {
		var point = CGPoint(x:gameView.center.x - boardWidth/2, y: gameView.bounds.height - boardHeight - super.tabBarController!.tabBar.frame.size.height)
		var frame = CGRect(origin: point, size: CGSize(width: boardWidth, height: boardHeight))
		let boardView = UIView(frame: frame)
		boardView.backgroundColor = UIColor.greenColor()
		var dragBoard = UIPanGestureRecognizer(target: self, action: "detectPan:")
		boardView.addGestureRecognizer(dragBoard)
		selectedView = boardView
		circumstanceBehavior.addboard(boardView)
	}
	func detectPan(recognizer: UIPanGestureRecognizer) {
		var p: CGPoint = recognizer.locationInView(gameView)
		var center: CGPoint = CGPointZero
		switch recognizer.state {
		case .Began:
			selectedView = view.hitTest(p, withEvent: nil)
			if selectedView != nil {
				gameView.bringSubviewToFront(selectedView!)
			}
		case .Changed:
			if let subView = selectedView {
				subView.center.x = p.x
				self.animator .updateItemUsingCurrentState(subView)
			}
		case .Ended:
			selectedView!.center.x = p.x
		default: break
		}
	}
	// # delegete
	
	func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
		println("\(item1.center)")
		for subview in gameView.subviews {
			if subview.center == item1.center && subview as? UIView != selectedView  {
				subview.removeFromSuperview()
				circumstanceBehavior.collider.removeItem(item1)
			}
		}
	
	}

}
