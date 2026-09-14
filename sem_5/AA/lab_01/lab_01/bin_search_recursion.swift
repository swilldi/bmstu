func bin_search_recursion(_ array: [Int], target: Int) -> Int {
    var m: Int
    if array.count == 0 {
        return -1
    } else {
        m = array.count / 2
    }


    if array[m] == target {
        return m
    } else if array[m] < target {
        return bin_search_recursion(Array(array[(m + 1)...]), target: target)
    } else {
        return bin_search_recursion(Array(array[...(m - 1)]), target: target)
    }
}

// c 14
// 15 мес
