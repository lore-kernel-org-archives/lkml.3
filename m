Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaIALOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:14:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19414 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIALOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:14:43 -0400
X-AuditID: cbfee68d-f79c46d000000b84-0f-5404552195fd
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 0/3] Add max77693 haptic driver
Date: Mon, 01 Sep 2014 20:14:28 +0900
Message-id: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkQFcxlCXE4ONRPYvrX56zWhxe9ILR
	YkfDEVaL+1+PMlrc/PSN1eLyrjlsFqe7WR3YPXbOusvucefaHjaPeScDPfq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugSvj0skmtoJr7BXrJk5gb2A8z9rFyMkhIWAiMX/vZBYIW0ziwr31bCC2
	kMBSRontc8phas7cXwkVn84oMeO2UxcjF5DdxiSx8tFcdpAEm4C2xPf1i8GGighUSvR3v2AF
	KWIW6GGU+N6+mhkkISygL7Hu3wywIhYBVYmtnQvBpvIKeEj8OLyOsYuRA2ibgsScSTYgvRIC
	/9kktnecYYKoF5D4NvkQC0SNrMSmA8wQx0lKHFxxg2UCo+ACRoZVjKKpBckFxUnpRYZ6xYm5
	xaV56XrJ+bmbGIEBe/rfs94djLcPWB9iFOBgVOLhfTCLOUSINbGsuDL3EKMp0IaJzFKiyfnA
	uMgriTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRsOTu
	yeRHshzlL5bmLtRf5tL8KNG+ttyphI+r4tnfK5uOvUvNTLZQNnqU+W32lVgmY578Lqub34Tf
	GvxWeRwRnLBXKeF32Ip7W1bO/v/atfK3pFGW78Smv50L10nqJu6VipU0y4v9an8rZONR8b6T
	mjJ6hcF1P1r8wu9yrwtTdatzvRG70FqJpTgj0VCLuag4EQB+4pEiUwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoK5iKEuIwZnd6hbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjEsnm9gKrrFXrJs4gb2B8Txr
	FyMnh4SAicSZ+yvZIGwxiQv31oPZQgLTGSVm3HbqYuQCstuYJFY+mssOkmAT0Jb4vn4xWLOI
	QKVEf/cLVpAiZoEeRonv7auZQRLCAvoS6/7NACtiEVCV2Nq5EGwqr4CHxI/D6xi7GDmAtilI
	zJlkM4GRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ih4Jr2DcVWDxSFGAQ5GJR7e
	B7OYQ4RYE8uKK3MPMUpwMCuJ8BY6soQI8aYkVlalFuXHF5XmpBYfYjQFWj6RWUo0OR8YrXkl
	8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhjXVuQ9Na/YcuCIi39X
	0y5t0chdDox6qp8z1uybv3qqhqzoUpNJrv9N61V3edysCZM+m9p19cOOnOpWhoh5GRe2Pe2t
	383VuT289LVordlDjmx97pOXWN/23kvYI5HzoPfyCpYZMgKGqeue+jPns+QF67r/3JGv63l/
	zqQDj+pCY5arltTnzFRiKc5INNRiLipOBABZus41ngIAAA==
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

Jaewon Kim (3):
  mfd: max77693: Initialize haptic register map
  Input: misc: Add haptic driver on max77693
  mfd: max77693: add haptic of_compatible in mfd_cell

 Documentation/devicetree/bindings/mfd/max77693.txt |   19 ++
 drivers/input/misc/Kconfig                         |   13 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/max77693-haptic.c               |  333 ++++++++++++++++++++
 drivers/mfd/max77693.c                             |   23 +-
 include/linux/mfd/max77693-private.h               |    9 +
 6 files changed, 394 insertions(+), 4 deletions(-)
 create mode 100644 drivers/input/misc/max77693-haptic.c

-- 
1.7.9.5

