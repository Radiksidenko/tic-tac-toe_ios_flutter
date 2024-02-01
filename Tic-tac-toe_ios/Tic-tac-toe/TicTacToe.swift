struct TicTacToe {
    enum Player: String, CustomStringConvertible {
        case x, o
        
        /// Replaces this player with their opponent.
        mutating func switchToOpponent() {
            switch self {
            case .x:
                self = .o
            case .o:
                self = .x
            }
        }
        
        var description: String {
            rawValue.uppercased()
        }
    }
    
    struct Cell {
        /// The player at this cell, if any.
        fileprivate(set) var player: Player?
        
        /// True if this cell is one of the
        /// matching triplets in the grid.
        fileprivate(set) var isMatching: Bool
        
        /// Creates a cell with the given properties.
        private init(player: Player?, isMatching: Bool) {
            self.player = player
            self.isMatching = isMatching
        }
        
        /// An empty cell, with `player` and
        /// `isMatching` set to `nil` and
        /// `false`, respectively.
        static var empty: Cell {
            Cell(player: nil, isMatching: false)
        }
        
        /// True if the player at this cell is `nil`.
        var isEmpty: Bool {
            player == nil
        }
    }
    
    /// The grid cells in row-major order.
    private(set) var cells = Array(repeating: Cell.empty, count: 9)
    
    /// The player of the current turn.
    private(set) var player: Player
    
    /// The winner of this game, if any.
    private(set) var winner: Player? = nil
    
    /// The number of turns that have passed.
    private(set) var turns = 0
    
    /// Creates a tic-tac-toe game,
    /// starting with the given player.
    init(startingPlayer: Player) {
        player = startingPlayer
    }
    
    /// True if this game hasn't ended yet.
    var isOngoing: Bool {
        // Neither player won and it isn't a draw.
        winner == nil && turns != 9
    }
    
    /// Returns the row-major index of the
    /// given position in the grid.
    func index(row: Int, column: Int) -> Int {
        //    0   1   2
        // 0 [0] [1] [2]
        // 1 [3] [4] [5]
        // 2 [6] [7] [8]
        //
        // Row offset is 1 and column offset is 3.
        // grid[row, column] = grid[3 * row + column]
        let range = 0..<3
        precondition(range.contains(row) && range.contains(column))
        return 3 * row + column
    }
}

extension TicTacToe {
    
    private func heuristic(_ index: Int) -> Int {
        assert(cells[index].isEmpty)
        
        var score = 0
        for triplet in indexTriplets(containing: index) {
            switch playerCounts(at: triplet) {
            case (2, 0):
                return Int.max
            case (0, 2):
                score += 10
            case (1, 0):
                score += 1
            default:
                break
            }
        }
        return score
    }
    
    private func playerCounts(at indices: [Int]) -> (player: Int, opponent: Int) {
        indices.reduce(into: (player: 0, opponent: 0)) { count, index in
            guard let player = cells[index].player else { return }
            if (player == self.player) {
                count.player += 1
            } else {
                count.opponent += 1
            }
        }
    }
    
    private mutating func minimax(index: Int, isMax: Bool, score: (max: Int, min: Int)) -> Int {
        
        assert(cells[index].isEmpty)
        cells[index].player = player
        turns += 1
        
        defer {
            cells[index].player = nil
            turns -= 1
        }
        
        if indexTriplets(containing: index).anySatisfy(isMatching) {
            return isMax ? 1 : -1
        }
        
        guard turns != 9 else { return 0 }
        
        player.switchToOpponent()
        let isMax = !isMax
        defer {
            player.switchToOpponent()
        }
        
        var score = score
        for childIndex in cells.indices where cells[childIndex].isEmpty {
            guard score.max < score.min else { break }
            let childScore = minimax(index: childIndex, isMax: isMax, score: score)
            if isMax {
                score.max = max(score.max, childScore)
            } else {
                score.min = min(score.min, childScore)
            }
        }
        return isMax ? score.max : score.min
    }
    
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy
        
        case medium
        
        case hard
        
        var id: Self { self }
    }
    
    mutating func playOne() -> Int? {
        
        guard isOngoing else { return nil }
        let emptyIndices = cells.indices.filter { index in cells[index].isEmpty }
        return emptyIndices.shuffled().max(by: heuristic)
    }
}



extension TicTacToe {
    
    private func indexTriplets(containing index: Int) -> [[Int]] {
        
        let (row, column) = index.quotientAndRemainder(dividingBy: 3)
        let rowStartIndex = 3 * row
        var triplets = [
            [rowStartIndex, rowStartIndex + 1, rowStartIndex + 2],
            [column, column + 3, column + 6]
        ]
        if row == column {
            triplets.append([0, 4, 8])
        }
        if row + column == 2 {
            triplets.append([2, 4, 6])
        }
        return triplets
    }
    
    private func isMatching(triplet: [Int]) -> Bool {
        assert(triplet.count == 3)
        return triplet.allEqual { index in cells[index].player }
    }
    
    mutating func play(at index: Int) {
        precondition(winner == nil && cells[index].isEmpty)
        cells[index].player = player
        for triplet in indexTriplets(containing: index) where isMatching(triplet: triplet) {
            winner = player
            for index in triplet {
                cells[index].isMatching = true
            }
        }
        player.switchToOpponent()
        turns += 1
    }
}

extension Collection {
    
    func anySatisfy(_ predicate: (Element) -> Bool) -> Bool {
        for element in self where predicate(element) {
            return true
        }
        return false
    }
    
    func max<T : Comparable>(by transform: (Element) -> T) -> Element? {
        
        guard let first = first else { return nil }
        var max = (element: first, transformed: transform(first))
        
        for element in dropFirst() {
            let transformed = transform(element)
            if transformed > max.transformed {
                max.element = element
                max.transformed = transformed
            }
        }
        return max.element
    }
    
    func allEqual<T : Equatable>(by transform: (Element) -> T) -> Bool {
        
        guard let first = first else { return true }
        let transformedFirst = transform(first)
        for element in dropFirst() where transformedFirst != transform(element) {
            return false
        }
        return true
    }
}
