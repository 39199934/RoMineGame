//
//  GirdsView.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/14.
//

import SwiftUI

struct GirdsView: View {
    @ObservedObject var viewModel: GirdsViewModel //= GirdsViewModel()
    var body: some View {
        VStack{
//            HStack{
//                Text("\(viewModel.gameIsRunning ? "游戏进行中" :"游戏已结束")")
//                Text("剩余地雷数：\(viewModel.lastMines),已标志：\(viewModel.flags)")
//                if(!viewModel.gameIsRunning){
//                    Button("restart"){
//                        viewModel.restartGame()
//                    }
//                }
//            }
            HStack{
                LazyVGrid(columns: viewModel.girdItms) {
                    ForEach(viewModel.models,id:\.id){model in
                        GirdItemView(girdItem: $viewModel.models[viewModel.getModelIndex(by: model.id)])
                        
                        
                    }
                    
                }
//                ScrollView{
//                    ForEach(viewModel.models,id:\.id){model in
//                        Text("\(model.x):\(model.y),index = \(viewModel.getModelIndex(by:model.x,by:model.y)),\(model.isHaveMine.description)")
//                    }
//                }
            }
        }.environmentObject(viewModel)
    }
}

struct GirdsView_Previews: PreviewProvider {
    static var previews: some View {
        GirdsView(viewModel: GirdsViewModel())
    }
}
