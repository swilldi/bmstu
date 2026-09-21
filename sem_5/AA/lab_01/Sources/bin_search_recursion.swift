func bin_search_recursion(_ array: [Int], _ target: Int) -> Int {
    bin_search_recursion(array, target, 0, array.count - 1)
}

private func bin_search_recursion(_ array: [Int], _ target: Int, _ l: Int, _ r: Int) -> Int {
    if l > r {
        return -1
    }

    let m = l + (r - l) / 2

    if array[m] == target {
        return m
    } else if array[m] < target {
        return bin_search_recursion(array, target, m + 1, r)
    } else {
        return bin_search_recursion(array, target, l, m - 1)
    }
}
