//
//  MacGridsView.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/14.
//
#if os(macOS)
import SwiftUI

struct MacGridsView: View {
    @ObservedObject var viewModel = GirdsViewModel()
    @State var columns = ""
    @State var rows = ""
    @State var mines = ""
    
    var body: some View {
        NavigationSplitView {
            VStack{
                
               
                RoundedRectangle(cornerRadius: 18)
                    .fill(.green.opacity(0.3))
                    .frame(width: 100,height: 100)
                    
                    .overlay {
                        Text("\(viewModel.gameIsRunning ? "游戏进行中" :"游戏已结束")")
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
                if(!viewModel.gameIsRunning){
                    Group{
                        HStack{
                            Text("列数")
                            TextField("列数", text: $columns)
                        }
                        HStack{
                            Text("行数")
                            TextField("行数", text: $rows)
                        }
                        HStack{
                            Text("地雷数")
                            TextField("地雷数", text: $mines)
                        }
                        Button("restart"){
                            viewModel.columns = Int(columns) ?? 10
                            viewModel.rows = Int(rows) ?? 10
                            viewModel.minesNumber = Int(mines) ?? 10
                            viewModel.restartGame()
                           
                        }
                    }
                    .onAppear{
                        self.columns = "\(viewModel.columns)"
                        self.rows = "\(viewModel.rows)"
                        self.mines   = "\(viewModel.minesNumber)"
                    }
                    
                }
                Spacer()
               
            }.padding()
        } detail: {
            GirdsView(viewModel: viewModel)
        }

    }
}

struct MacGridsView_Previews: PreviewProvider {
    static var previews: some View {
        MacGridsView()
    }
}
#endif
