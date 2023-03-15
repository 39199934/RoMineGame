//
//  StatusView.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/15.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var viewModel: GirdsViewModel
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 18)
                .fill(.green.opacity(0.3))
                .frame(width: 100,height: 100)
                
                .overlay {
                    if(!viewModel.gameIsRunning){
                        Button("快速重启"){
                            viewModel.restartGame()
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }else{
                        Text("\(viewModel.gameIsRunning ? "游戏进行中" :"游戏已结束")")
                    }
                }
                .sheet(isPresented: $viewModel.gameIsOK) {
                    VStack{
                        Text("恭喜，已完成")
                        Button("ok"){
                            viewModel.gameIsOK.toggle()
                        }
                    }.padding()
                }
            RoundedRectangle(cornerRadius: 18)
                .fill(.red.opacity(0.3))
                .frame(width: 100,height: 100)
                .overlay {
                    Text("剩余地雷数：\(viewModel.lastMines)")
                }
            RoundedRectangle(cornerRadius: 18)
                .fill(.gray.opacity(0.3))
                .frame(width: 100,height: 100)
                .overlay {
                    Text("已标志：\(viewModel.flags)")
                }
        }
        .padding(.bottom,20)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(viewModel: GirdsViewModel())
    }
}
