//
//  brickBehavior.swift
//  BreakoutGame
//
//  Created by Lee on 2015/5/7.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

import UIKit

class CircumstanceBehavior: UIDynamicBehavior,UICollisionBehaviorDelegate {
	
	lazy var push = UIPushBehavior(items: nil, mode: .Instantaneous)

	lazy var ballBehavior: UIDynamicItemBehavior = {
		let lazilyCreatedBallBehavior = UIDynamicItemBehavior()
		lazilyCreatedBallBehavior.allowsRotation = false
		lazilyCreatedBallBehavior.density = 1
		return lazilyCreatedBallBehavior
		}()
	lazy var brickBehavior: UIDynamicItemBehavior = {
		let lazilyCreatedBrickBehavior = UIDynamicItemBehavior()
		lazilyCreatedBrickBehavior.allowsRotation = false
		lazilyCreatedBrickBehavior.density = 1000.0
		return lazilyCreatedBrickBehavior
	}()
	lazy var boardBehavior: UIDynamicItemBehavior = {
		let lazilyCreatedBoardBehavior = UIDynamicItemBehavior()
		lazilyCreatedBoardBehavior.allowsRotation = false
		lazilyCreatedBoardBehavior.density = 1000.0
		return lazilyCreatedBoardBehavior
	}()
	lazy var collider: UICollisionBehavior = {
		let lazilyCreatedCollider = UICollisionBehavior()
		return lazilyCreatedCollider
		}()
	
	func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
	}
	override init() {
		super.init()
		addChildBehavior(push)
		addChildBehavior(ballBehavior)
		addChildBehavior(brickBehavior)
		addChildBehavior(boardBehavior)
		addChildBehavior(collider)
	}
	func addbrick(itemView: UIView) {
		dynamicAnimator?.referenceView?.addSubview(itemView)
		collider.addItem(itemView)
		brickBehavior.addItem(itemView)
	}
	func addball(itemView: UIView) {
		dynamicAnimator?.referenceView?.addSubview(itemView)
		collider.addItem(itemView)
		push.magnitude = 0.0
		push.pushDirection = CGVectorMake(0.1, -0.1)
		push.active = false
		push.addItem(itemView)
		ballBehavior.elasticity = 1
		ballBehavior.friction = 0
		ballBehavior.resistance = 0
		ballBehavior.addItem(itemView)
		
	}
	func startGame() {
		push.active = true
		push.action = {
			push.dynamicAnimator?.removeBehavior(push)
		}
	}
	func addboard(itemView: UIView) {
		dynamicAnimator?.referenceView?.addSubview(itemView)
		boardBehavior.addItem(itemView)
		collider.addItem(itemView)
	}
	func removeBrick(itemView: UIView) {
		
	}
	
}
