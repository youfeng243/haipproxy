#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/7/23 18:42
# @Author  : youfeng

from haipproxy.client.py_cli import ProxyFetcher

args = dict(host='192.168.1.90', port=6379, password='haizhi@)', db=15)
# ＃　这里`zhihu`的意思是，去和`zhihu`相关的代理ip校验队列中获取ip
# ＃　这么做的原因是同一个代理IP对不同网站代理效果不同
fetcher = ProxyFetcher('zhihu', strategy='greedy', redis_args=args)
# 获取一个可用代理
print(fetcher.get_proxy())
# 获取可用代理列表
print(fetcher.get_proxies())  # or print(fetcher.pool)
