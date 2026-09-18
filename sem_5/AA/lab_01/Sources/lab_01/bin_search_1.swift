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


/*
var l = 0, r = array.count - 1  // 2 + 1 + 1 -> 4
while l < r {
    let m = l + (r - l) / 2     // 3
    if array[m] < target {      // 2
        l = m + 1               // 2
    } else {
        r = m
    }
}                               // заголовок 1; тело: 7 -> 1 + logN * 7
if array[l] == target {
    return l
} else {
    return -1
}                               // заголовок 2, тело 1 -> 3

4 + (1 + logN * 7) + 3 = 8 + 7*logN
ЛС = ХС =
*/
