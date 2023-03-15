//
//  GirdsViewModel.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/14.
//

import Foundation
import SwiftUI

class GirdsViewModel: ObservableObject{
    @Published var models: [GirdItemModel]
    @Published var columns: Int
    @Published var rows: Int
    @Published var minesNumber: Int
    @Published var girdItms:[GridItem]
    @Published var gameIsRunning: Bool
    @Published var gameIsOK: Bool
    @Published var flags: Int
    @Published var lastMines: Int
    @Published var path: NavigationPath
    init(){
        #if os(macOS)
        self.columns = 10
        self.rows = 10
        minesNumber = 30
        #else
        self.columns = 7
        self.rows = 10
        minesNumber = 10
        #endif
        models = []
        girdItms = []
        gameIsOK = false
        gameIsRunning = true
        path = NavigationPath()
        
        flags = 0
        lastMines = 0
        lastMines = minesNumber
        restartGame()
    }
    private func generationGridItemSize(){
        girdItms = []
        for _  in 0..<columns{
            girdItms.append(GridItem(.fixed(40)))
        }
    }
    private func generationModels(){
        models = []
        for r in 0..<rows{
            for c in 0..<columns{
                
                let m = GirdItemModel(x: c, y: r,  id: UUID(), isHaveMine: false, girdStatus: .close(closeStatus: .noClicked))
                models.append(m)
            }
        }
    }
    func getModelIndex(by id: UUID) -> Int{
        for index in 0..<models.count{
            if models[index].id == id{
                return index
            }
        }
        return -1
    }
    func getModelIndex(at model: GirdItemModel) -> Int{
        
        return getModelIndex(by: model.id)
    }
    func getModelIndex(by x: Int,by y: Int) -> Int{
        return  y * columns + x
    }
    private func generationMines(){
        var  index = minesNumber
        while(index > 0){
            let x = Int.random(in: 0..<columns)
            let y = Int.random(in: 0..<rows)
            if !models[self.getModelIndex(by: x, by: y)].isHaveMine{
                models[self.getModelIndex(by: x, by: y)].isHaveMine = true
                index -= 1
            }
            else{
                continue
            }
            
        }
    }
    func restartGame(){
        models = []
        girdItms = []
        gameIsRunning = true
        gameIsOK = false
        flags = 0
        lastMines = minesNumber
        generationGridItemSize()
        generationModels()
        generationMines()
    }
    private func countAllNumbers(){
        var flags = 0
//        var markMines = 0
        var lastMines = minesNumber
        var unknows = 0
        var notOpenGird = 0
        for model in models {
            switch model.girdStatus{
                
            case .open(openStatus: let openStatus):
                switch openStatus{
                    
                case .bombed:
                    gameIsRunning = false
                case .noBombed(aroundBombCounts: let aroundBombCounts):
                    break
                }
            case .close(closeStatus: let closeStatus):
                switch closeStatus{
                    
                case .noClicked:
                    notOpenGird += 1
                case .settedFlag:
                    flags += 1
                    lastMines -= 1
                case .settedUnknow:
                    unknows += 1
                }
            }
        }
        self.flags = flags
        self.lastMines = lastMines
        if lastMines == 0{
            let rt = checkIsOK()
            if rt == true{
                gameIsRunning = false
            }
        }
    }
    func checkIsOK() -> Bool{
        
        for model in models {
            
            if model.isHaveMine{
                
                switch model.girdStatus{
                    
                case .open(openStatus: let openStatus):
                    switch openStatus{
                        
                    case .bombed:
                        return false
                    case .noBombed(aroundBombCounts: let aroundBombCounts):
                        continue
                    }
                case .close(closeStatus: let closeStatus):
                    switch closeStatus{
                        
                    case .noClicked:
                        return false
                    case .settedFlag:
                        break
                    case .settedUnknow:
                        return false
                    }
                }
            }
        }
        gameIsOK = true
        return true
    }
    func calAroundMines(model: GirdItemModel) -> Int{
//        let index = getModelIndex(at: model)
        let cx = model.x
        let cy = model.y
        var mineCount: Int = 0
        print("current x,y:\(cx),\(cy) _ \(model.isHaveMine)")
        for sx in cx-1...cx+1{
            for sy in cy-1...cy+1{
                
                if (sx == cx && sy == cy){
                    continue
                }
                if(sx < 0 || sy < 0 || sx >= self.columns || sy >= self.rows){
                    continue
                }
                print("search x,y:\(sx),\(sy)，\(models[self.getModelIndex(by: sx, by: sy)].isHaveMine)")
                let indexS = getModelIndex(by: sx, by: sy)
                //                print("mine have:\(models[index].isHaveMine)")
                if models[indexS].isHaveMine{
                    mineCount += 1
                }
            }
        }
        return mineCount
    }
    func getAroundGirds(at model: GirdItemModel) -> [Int]{
        var indexs : [Int] = []
        let cx = model.x
        let cy = model.y
        for sx in cx-1...cx+1{
            for sy in cy-1...cy+1{
                
                if (sx == cx && sy == cy){
                    continue
                }
                if(sx < 0 || sy < 0 || sx >= self.columns || sy >= self.rows){
                    continue
                }
                let indexS = getModelIndex(by: sx, by: sy)
                indexs.append(indexS)
                
            }
        }
        return indexs
        
    }
    func onLongTag(at model: GirdItemModel){
        if !gameIsRunning{
            return
        }
        let index = getModelIndex(at: model)
        if index == -1 {
            return
        }
        switch(model.girdStatus){
            
        case .open(openStatus: let openStatus):
            switch openStatus{
                
            case .bombed:
                gameIsRunning = false
            case .noBombed(aroundBombCounts: let aroundBombCounts):
                let aroundIndexs = getAroundGirds(at: model)
                var flags = 0
                for indexAround in aroundIndexs{
                    switch models[indexAround].girdStatus{
                        
                    case .open(openStatus: let openStatus):
                        continue
                    case .close(closeStatus: let closeStatus):
                        switch closeStatus{
                            
                        case .noClicked:
                            continue
                        case .settedFlag:
                            flags += 1
                        case .settedUnknow:
                            continue
                        }
                    }
                }
                
                if flags == aroundBombCounts{
                    for indexAround in aroundIndexs{
                        switch models[indexAround].girdStatus{
                            
                        case .open(openStatus: let _):
                            continue
                        case .close(closeStatus: let closeStatus):
                            switch closeStatus{
                                
                            case .noClicked:
                                onClicked(at: models[indexAround])
                            case .settedFlag:
                                continue
                            case .settedUnknow:
                                continue
                            }
                        }
                    }
                }
            }
        case .close(closeStatus: let closeStatus):
            switch(closeStatus){
                
            case .noClicked:
                models[index].girdStatus = .close(closeStatus: .settedFlag)
            case .settedFlag:
                models[index].girdStatus = .close(closeStatus: .settedUnknow)
            case .settedUnknow:
                models[index].girdStatus = .close(closeStatus: .noClicked)
            }
        }
        countAllNumbers()
    }
    func  onClicked(at model: GirdItemModel){
        if !gameIsRunning{
            return
        }
        let index = getModelIndex(at: model)
        if index == -1 {
            return
        }
        switch(model.girdStatus){
            
        case .open(openStatus: let openStatus):
            switch(openStatus){
                
            case .bombed:
                break
            case .noBombed(aroundBombCounts: let aroundBombCounts):
                break
            }
        case .close(closeStatus: let closeStatus):
            switch(closeStatus){
                
            case .noClicked:
                print("model xy:\(model.x):\(model.y)_ \(model.isHaveMine),iinndex model xy:\(models[index].x):\(models[index].y)_ \(models[index].isHaveMine)")
                if model.isHaveMine{
                    models[index].girdStatus = .open(openStatus: .bombed)
                    gameIsRunning = false
                }else{
                    let aroundMines = calAroundMines(model: model)
                    models[index].girdStatus = .open(openStatus: .noBombed(aroundBombCounts: aroundMines))
                    if aroundMines == 0 {
                        zeroClean(at: model)
                    }
                }
            case .settedFlag:
                break
            case .settedUnknow:
                break
            }
        }
        countAllNumbers()
        
    }
    func zeroClean(at model:GirdItemModel){
        if model.isHaveMine {
            return
        }
        switch model.girdStatus{
            
        case .open(openStatus: let openStatus):
            return
        case .close(closeStatus: let closeStatus):
            switch closeStatus{
                
            case .noClicked:
                break
            case .settedFlag:
                return
            case .settedUnknow:
                break
            }
        }
        
        let index = getModelIndex(at: model)
        let aroundMines =  calAroundMines(model: model)
        if calAroundMines(model: model) != 0 {
            models[index].girdStatus = .open(openStatus: .noBombed(aroundBombCounts: aroundMines))
            return
        }
        
        models[index].girdStatus = .open(openStatus: .noBombed(aroundBombCounts: 0))
        let cx = model.x
        let cy = model.y
       
        print("current x,y:\(cx),\(cy) _ \(model.isHaveMine)")
        for sx in cx-1...cx+1{
            for sy in cy-1...cy+1{
                
                if (sx == cx && sy == cy){
                    continue
                }
                if(sx < 0 || sy < 0 || sx >= self.columns || sy >= self.rows){
                    continue
                }
                print("search x,y:\(sx),\(sy)，\(models[self.getModelIndex(by: sx, by: sy)].isHaveMine)")
                let indexS = getModelIndex(by: sx, by: sy)
                //                print("mine have:\(models[index].isHaveMine)")
                zeroClean(at: models[indexS])
                
            }
        }
        
    }
}

