func brute_force_search(_ array: [Int], target: Int) -> Int {
    var index = -1
    for i in 0..<array.count {
        if array[i] == target {
            index = i
            break
        }
    }
    return index
}
