#/usr/bin/env  python
#coding=utf-8

# 你选 一个， 电脑随机出一个， 看谁赢
# 用法： python shiTou_jianDao_bu_石头-剪刀-布.py

import sys,os
import random

list = ['石头', '剪刀', '布']
win_list = [['石头', '剪刀'], ['剪刀', '布'] , ['布', '石头']]
#win_list = [[a, b], [c, d], [a, b]]


def game_sjb():
	print "\033[1;31m 石头剪刀布游戏开始, Tina 出招吧 :) ！\033[0m"
	x = raw_input('请输入你的选择： 石头/剪刀/布: ')
	rand_num = random.randint(0 ,2)
	y = list[rand_num]

	print "电脑出了： {0}".format(y)


	if x not in list:
		print "你输入不对..."
		exit()
	elif x == y:
		print "你俩出的一样......"
	elif [x, y] in win_list:
		print "\033[1;32m 你赢了！！\033[0m"
	else:
		print "\033[1;33m 电脑赢了！！\033[0m" 

	exit()


game_sjb()
