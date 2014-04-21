Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaDUMCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:02:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaDUMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:18 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-56-535508c87c8e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/9] extcon: Support devm_extcon_dev_allocate/free()
Date: Mon, 21 Apr 2014 21:02:13 +0900
Message-id: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkQPcER2iwwf5DBhYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2By6PTas62TxeTvzN5tG3
	ZRWjx9Qpfxk9jt/YzuTxeZNcAFsUl01Kak5mWWqRvl0CV0bj7LtsBe3cFRPnXWJtYOzj7GLk
	5JAQMJFYvnEyC4QtJnHh3nq2LkYuDiGBpYwSC381sMAUHdu6mxUisYhRonndNyiniUni5uwH
	bCBVbAJaEvtf3ACzRQQUJDb3PgMrYhZ4xihx4uoJZpCEsICbxJPDr5lAbBYBVYl7c3aAreAV
	cJWYc6yNDWKdnMSHPY/YQZolBOaxS/z4dJwZokFA4tvkQ0ANHEAJWYlNB5gh6iUlDq64wTKB
	UXABI8MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMDgPv3vWf8OxrsHrA8xJgONm8gsJZqc
	D4yOvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	KH7g36XvV5fI8nyImzvDrcFyztuM0iXpLszGGRseMa1wzyye6il968LrsPq1q/9LXjM4w2Zy
	9Mbj1pn7FrsWMBadN9npf2zOnh2HD781sjnkM+dBWsrb/H7t3UGtORNW6c46nM6QKHfR5H7o
	HKsbOgqnJZdsPH785WOPR43fPwVXbdO8JPhAwUWJpTgj0VCLuag4EQB+9ChFhAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAd0THKHBBiu2aVocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzGmffZSto566YOO8SawNjH2cXIyeHhICJxLGtu1khbDGJC/fWs3UxcnEICSxilGhe940V
	wmlikrg5+wEbSBWbgJbE/hc3wGwRAQWJzb3PwIqYBZ4xSpy4eoIZJCEs4Cbx5PBrJhCbRUBV
	4t6cHSwgNq+Aq8ScY21sEOvkJD7secQ+gZF7ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95Pzc
	TYzg2HkmtYNxZYPFIUYBDkYlHt4ZJSHBQqyJZcWVuYcYJTiYlUR4I9YDhXhTEiurUovy44tK
	c1KLDzEmA22fyCwlmpwPjOu8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQW
	wWxh4uCUamB03Z76ZqHMZTbFy80rjzuVivxq8GFQX6Ld0P51yk8llWORHk6lS31Yf8584l8V
	WbHhpmXv4R8HQ+sOb2OZ7Llj8bndOxpjkte/W/XaIvn24vTEhK/qzauzrAq87bgrc0+WZWod
	mhj44qri59r3/Ps6m4ueLZVutFtzoDXv69pnq2tymzJn67YqsRRnJBpqMRcVJwIAK1tl0+EC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thi patchset add devm_extcon_dev_allocate/free() for the resource management
of extcon device. And devm_extcon_dev_allocate() handles all of supported cables.

Changes from v1:
- Rebase it on latest extcon-next branch

Chanwoo Choi (9):
  extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
  extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
  extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max77693: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
  extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev
  extcon: arizona: Use devm_extcon_dev_allocate for extcon_dev
  extcon: adc-jack: Use devm_extcon_dev_allocate for extcon_dev
  extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev

 drivers/extcon/extcon-adc-jack.c |  21 +--
 drivers/extcon/extcon-arizona.c  |  31 ++--
 drivers/extcon/extcon-class.c    | 341 ++++++++++++++++++++++++---------------
 drivers/extcon/extcon-gpio.c     |  23 ++-
 drivers/extcon/extcon-max14577.c |   5 +-
 drivers/extcon/extcon-max77693.c |   7 +-
 drivers/extcon/extcon-max8997.c  |   5 +-
 drivers/extcon/extcon-palmas.c   |  35 ++--
 include/linux/extcon.h           |  26 +++
 include/linux/mfd/palmas.h       |   2 +-
 10 files changed, 308 insertions(+), 188 deletions(-)

-- 
1.8.0

