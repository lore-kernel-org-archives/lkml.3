Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaIELtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:49:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44127 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaIELtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:49:01 -0400
X-AuditID: cbfee68f-f797f6d000001173-a6-5409a32b08c0
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v3 0/4] Add max77693 haptic driver
Date: Fri, 05 Sep 2014 20:48:18 +0900
Message-id: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWyRsSkWFd7MWeIwcX/hhbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAldG4+LPrAWzuCvav55mamDczdHFyMkhIWAi8bH1BBOELSZx4d56ti5G
	Lg4hgaWMEtub3rHBFM1rXQyVmM4osevwQiinjUli8YFdYFVsAtoS39cvZgWxRQQqJfq7X7CC
	FDEL9DBKfG9fzQySEBYwkph36ykjiM0ioCqxbsdOsAZeAQ+JGQueAtVwAK1TkJgzyQakV0Lg
	N5vEziMTmCDqBSS+TT7EAlEjK7HpADPEdZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJu
	cWleul5yfu4mRmDQnv73rH8H490D1ocYBTgYlXh4F3zmCBFiTSwrrsw9xGgKtGEis5Rocj4w
	NvJK4g2NzYwsTE1MjY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBofc7C
	9v13rv5LVl531mQ9q3Hf430xITRE/u+s+FdqjoZ3j2wLZHb/WBxX9+JO6v9VYVvrH38UXPrF
	b/MUtrc5gvot7B9jxS/nqvaaiCQeN4zo0GK7UR6+ik/l3x/elRI/0vbaqV+/PClEP7qrk2fJ
	23V3KzhefK8y7Tz3IWe7QrFiZsPzzk4lluKMREMt5qLiRAC/SbcyVQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoK72Ys4Qg7PvtSyuf3nOanF40QtG
	ix0NR1gt7n89ymhx89M3VovLu+awWZzuZnVg99g56y67x51re9g85p0M9OjbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGY2LP7MWzOKuaP96mqmBcTdH
	FyMnh4SAicS81sVsELaYxIV764FsLg4hgemMErsOL4Ry2pgkFh/YBVbFJqAt8X39YlYQW0Sg
	UqK/+wUrSBGzQA+jxPf21cwgCWEBI4l5t54ygtgsAqoS63bsBGvgFfCQmLHgKVANB9A6BYk5
	k2wmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcE8+kdjCubLA4xCjAwajEw7vg
	M0eIEGtiWXFl7iFGCQ5mJRFe9ymcIUK8KYmVValF+fFFpTmpxYcYTYGWT2SWEk3OB8ZrXkm8
	obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGxp0Fbguit1twxR28077q
	c+yUX9+lFL2/THxRzfvgrrvd5cjXvyX9ZXwio6Vzy7/zfDUyjysIeqK9giVIacmP1ldhP64t
	1GOc8W/xYR7mrnfvHKzaGhlnKG3g9dgm/MJZLHen2qmoTfUGiofWbk5paYk/Y264aFbshWeX
	F/Xfyb92euvGujb2Q0osxRmJhlrMRcWJAM7ch6KfAgAA
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

Changes in v3:
 - driver : remove mutex in workqueue
 - driver : mv max77693_haptic_set_duty_cyle() to workqueue.
 - driver : remove max77693_haptic_remove[]
 - driver : add suspend() function to turn-off entering suspend.

Changes in v2:
 - split to documentation and mfd patchs.
 - Documentation : change explanation of haptic 
 - Documentation : remove pwm-names propertie in example

Jaewon Kim (4):
  mfd: max77693: Initialize haptic register map
  Input: misc: Add haptic driver on max77693
  mfd: max77693: add haptic of_compatible in mfd_cell
  mfd: max77693: Update DT binding to support haptic

 Documentation/devicetree/bindings/mfd/max77693.txt |   18 ++
 drivers/input/misc/Kconfig                         |   12 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/max77693-haptic.c               |  321 ++++++++++++++++++++
 drivers/mfd/max77693.c                             |   26 +-
 include/linux/mfd/max77693-private.h               |    9 +
 6 files changed, 383 insertions(+), 4 deletions(-)
 create mode 100644 drivers/input/misc/max77693-haptic.c

-- 
1.7.9.5

