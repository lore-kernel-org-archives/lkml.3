Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaIQQks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:40:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36239 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaIQQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:40:43 -0400
X-AuditID: cbfee68e-f79536d000000fd1-91-5419b9898860
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v5 0/3] Add max77693 haptic driver
Date: Thu, 18 Sep 2014 01:40:23 +0900
Message-id: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWyRsSkWLdzp2SIwZ0uNYvrX56zWuxoOMJq
	cf/rUUaLy7vmsDmweNy5tofNo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDJ6HzxjL1jJVTFz
	/TXGBsbJHF2MnBwSAiYSp+8fYIGwxSQu3FvP1sXIxSEksJRRom3FPCaYoo87tzBCJBYxSiz/
	tB2qqo1JYub9bawgVWwC2hLf1y8Gsjk4RARUJM69MQcxmQXyJf5vMgOpEBYwkrgzZSM7iM0i
	oCqxbvU5sPm8Ah4S3dt/MIGUSwgoSMyZZAMyXULgNptE3/EjzBD1AhLfJh9igaiRldh0gBni
	NEmJgytusExgFFzAyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzAAT/971reD8eYB60OM
	AhyMSjy8Gy5LhAixJpYVV+YeYjQF2jCRWUo0OR8Y5nkl8YbGZkYWpiamxkbmlmZK4rwJUj+D
	hQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBq90eIn2J8/arilxSz5t0wTnm7S37Z/dvjrkut
	vHHBJP5SzQ5F8/o73ZPkD9ycsmNudUzeLRWdbfnf2VgOZZ003Kqwel3hdJHMunwLlk1K+1JX
	aif87/1wk5Ft4/X77nH/XnnHb286U3667V2rWtnVfwy/mI6ZSvn+nCyy9Z9jXPG7+oigFe+V
	WIozEg21mIuKEwEf4V3+OwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jAd3OnZIhBi1b5Cyuf3nOarGj4Qir
	xf2vRxktLu+aw+bA4nHn2h42j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHM6H3wjL1gJVfFzPXXGBsYJ3N0MXJySAiYSHzcuYURwhaTuHBvPVsXIxeH
	kMAiRonln7ZDOW1MEjPvb2MFqWIT0Jb4vn4xkM3BISKgInHujTmIySyQL/F/kxlIhbCAkcSd
	KRvZQWwWAVWJdavPMYHYvAIeEt3bfzCBlEsIKEjMmWQzgZF7ASPDKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzg8H4mtYNxZYPFIUYBDkYlHt4NlyVChFgTy4orcw8xSnAwK4nwWm+UDBHi
	TUmsrEotyo8vKs1JLT7EaAq0fCKzlGhyPjD28kriDY1NzIwsjcwNLYyMzZXEeQ+0WgcKCaQn
	lqRmp6YWpBbB9DFxcEo1MG6umXZ5XVhmYoP2pMUHGTZeO9MeN/+C00ebT7Oute0+xCeZ/C7J
	/aPR1NfypaKbS5pUrf+4O6vyXCv0dzTsdOCMrr6ycqqiwkHNRQfFN+Z8/vJF+HSgbv9076f7
	o7yXm2RWLpQ5vy/33A1xnzTV1OYc7X9aRhlnK+waJqzdF/Gozse57mPEYSWW4oxEQy3mouJE
	AFuGuaOFAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds max77693 haptic driver.
The max77693 is a Multifunction device with PMIC, CHARGER, LED,
MUIC, HAPTIC and this series is haptic device driver in MAX77693.
The haptic driver use regmap method for i2c communication and
support force feedback framework in input device.

Changes in v5:
 - Documentation : change explanation of haptic and pwm

Changes in v4:
 - mfd : fix tabbing in mfd_cell
 - driver : move regulator enable/disable to input open()/close()
 - driver : add resume function

Changes in v3:
 - driver : remove mutex in workqueue
 - driver : mv max77693_haptic_set_duty_cyle() to workqueue.
 - driver : remove max77693_haptic_remove[]
 - driver : add suspend() function to turn-off entering suspend.

Changes in v2:
 - split to documentation and mfd patchs.
 - Documentation : change explanation of haptic 
 - Documentation : remove pwm-names propertie in example

Jaewon Kim (3):
  mfd: max77693: Initialize haptic register map
  mfd: max77693: add haptic of_compatible in mfd_cell
  mfd: max77693: Update DT binding to support haptic

 Documentation/devicetree/bindings/mfd/max77693.txt |   21 ++++++++++++++++
 drivers/mfd/max77693.c                             |   26 +++++++++++++++++---
 2 files changed, 43 insertions(+), 4 deletions(-)

-- 
1.7.9.5

