// отложенный выход, то есть до схождения левой и правой границ

func bin_search_1(_ array: [Int], target: Int) -> Int {
    var l = 0, r = array.count - 1
    while l < r {
        let m = l + (r - l) / 2
        if array[m] < target {
            l = m + 1
        } else {
            r = m
        }
    }
    if array[l] == target {
        return l
    } else {
        return -1
    }
}
