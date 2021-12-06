#!/usr/bin/env python3
nums = None
lines = []
boards = []

def win(board, calls):
    for i in range(5):
        if all(board[i][j] in calls for j in range(5)) or all(board[j][i] in calls for j in range(5)):
            return sum([sum([x for x in y if not x in calls]) for y in board])
    return False

with open('input4.txt') as f:
    for i, line in enumerate(f):
        if i == 0:
            nums = list(map(int, line.strip().split(',')))
        else:
            lines.append(list(map(int,line.strip().split())))

for i in range(1, len(lines), 6):
    boards.append(lines[i:i+5])

def find_win(idx, boards, nums):
    for i in range(idx, len(nums)):
        cur = set(nums[:i])
        for b in boards:
            sum_ = win(b, cur)
            if bool(sum_):
                boards.remove(b)
                return sum_ * nums[i-1], boards
    return 0

def find_both_wins(boards, nums):
    first, _ = find_win(5, boards, nums)
    while boards:
        last, boards = find_win(5, boards, nums)
    return first, last


print(find_both_wins(boards, nums))
