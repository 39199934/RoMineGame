//
//  GirdModel.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/13.
//

import Foundation
import SwiftUI

enum OpenStatus{
    case bombed,noBombed(aroundBombCounts: Int)
}
enum CloseStatus{
    case noClicked,settedFlag,settedUnknow
}
enum GirdStatus{
    case open(openStatus: OpenStatus),close(closeStatus: CloseStatus)
    //    typealias Body = Image
   
}
struct GirdItemModel: View{
    var x: Int
    var y: Int
    var id: UUID
    
    var isHaveMine: Bool
    var girdStatus: GirdStatus
    var body: some View{
        RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.4))
            .frame(width: 40,height: 40)
        
            .overlay(alignment: .center) {
                switch self.girdStatus{
                case .open(let openStatus):
                    switch openStatus {
                    case .bombed:
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(.red)
                        
                    case .noBombed(let bombCounts):
                        //                return RoundedRectangle(cornerRadius: 12)
//                        Image(systemName: "xmark.circle")
//                            .resizable()
                        if bombCounts == 0{
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 12)
//                                    .fill(.green.opacity(0.3))
//                                    .frame(width: 33,height: 33)
////                                Text("\(bombCounts)")
//                            }
                            Text("")
                        }else{
                            Text("\(bombCounts)")
                        }
                        
                    }
                    
                    
                case .close(let closeStatus):
                    switch(closeStatus){
                    case .noClicked:
//                        Text("\(x): \(y)")
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.6))
                            .frame(width: 40,height: 40)
                    case .settedFlag:
                        Image(systemName: "flag.circle")
                        
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(.red)
                    case .settedUnknow:
                        Image(systemName: "camera.metering.unknown")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(.yellow)
                        
                    }
                    
                    
                }
                //    }
                
            }
    }



}
