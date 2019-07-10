//
//  MomentCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCellNode: ASCellNode {
    
    private let moment: Moment
    
    private let avatarNode: ASImageNode
    
    private let nameNode: ASButtonNode
    
    private var textNode: ASTextNode?
    
    private var bodyNode: ASDisplayNode?
    
    private let timeNode: ASTextNode
    
    private var sourceNode: ASButtonNode?
    
    private let moreNode: ASButtonNode
    
    private var commentNode: ASDisplayNode?
    
    private let bottomSeparator: ASDisplayNode
    
    init(moment: Moment) {
        self.moment = moment
        
        avatarNode = ASImageNode()
        avatarNode.contentMode = .scaleAspectFill
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        avatarNode.cornerRoundingType = .clipping
        avatarNode.cornerRadius = 5
        avatarNode.backgroundColor = Colors.backgroundColor
        
        nameNode = ASButtonNode()
        nameNode.contentHorizontalAlignment = .left
        
        textNode = ASTextNode()
        
        timeNode = ASTextNode()
        
        moreNode = ASButtonNode()
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMore_32x20_"), for: .normal)
        moreNode.setImage(UIImage.as_imageNamed("AlbumOperateMoreHL_32x20_"), for: .highlighted)
        moreNode.style.preferredSize = CGSize(width: 32, height: 20)
        
        bottomSeparator = ASDisplayNode()
        bottomSeparator.backgroundColor = Colors.DEFAULT_BORDER_COLOR
        bottomSeparator.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(LINE_HEIGHT))
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let user = MockFactory.shared.users.first(where: { $0.identifier == moment.userID })
        let avatar = user?.avatar ?? "DefaultHead_48x48_"
        avatarNode.image = UIImage.as_imageNamed(avatar)
        
        let name = user?.name ?? ""
        nameNode.setAttributedTitle(moment.attributedStringForUsername(with: name), for: .normal)
        timeNode.attributedText = moment.timeAttributedText()
        textNode?.attributedText = moment.contentAttributedText()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.spacingBefore = 12
        nameNode.style.flexShrink = 1.0
        bottomSeparator.style.flexGrow = 1.0
        textNode?.style.flexGrow = 1.0
        
        let rightStack = ASStackLayoutSpec.vertical()
        rightStack.spacing = 6
        rightStack.style.flexShrink = 1.0
        rightStack.style.flexGrow = 1.0
        rightStack.style.spacingAfter = 12
        rightStack.style.spacingBefore = 12
        rightStack.children = [nameNode]
        
        if let textNode = textNode {
            rightStack.children?.append(textNode)
        }
        
        let footerStack = ASStackLayoutSpec.horizontal()
        let footerSpacer = ASLayoutSpec()
        footerSpacer.style.flexGrow = 1.0
        var footerElements: [ASLayoutElement] = []
        footerElements.append(timeNode)
        if let node = sourceNode {
            footerElements.append(node)
        }
        footerElements.append(footerSpacer)
        footerElements.append(moreNode)
        footerStack.children = footerElements
        rightStack.children?.append(footerStack)
        
        let layoutSpec = ASStackLayoutSpec.horizontal()
        layoutSpec.justifyContent = .start
        layoutSpec.alignItems = .start
        layoutSpec.children = [avatarNode, rightStack]
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake("100%"), height: ASDimensionMake(1))
        
        let verticalSpec = ASStackLayoutSpec.vertical()
        verticalSpec.spacing = 10
        verticalSpec.children = [topSpacer, layoutSpec, bottomSeparator]
        
        return ASInsetLayoutSpec(insets: .zero, child: verticalSpec)
    }
}

extension MomentCellNode {
    class WebpageContentNode: ASDisplayNode {
        
    }
}
