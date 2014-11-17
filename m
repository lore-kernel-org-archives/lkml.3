Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaKQAnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:43:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27864 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaKQAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:43:04 -0500
X-AuditID: cbfee691-f79b86d000004a5a-bd-546944969f17
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/5] mfd: sec-core: Add support S2MPS13 PMIC device
Date: Mon, 17 Nov 2014 09:42:55 +0900
Message-id: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkSHeaS2aIweHbEhZLLl5lt5j68Amb
	xfUvz1kt5h85x2rxZ0Irm8Wk+xNYLM42vWG3uP/1KKPFtysdTBaXd81hs3g64SKbxeluVouL
	K74wOfB67Jx1l91j06pONo871/awecw7GejRt2UVo8f0eT+ZPD5vkgtgj+KySUnNySxLLdK3
	S+DKuN24h72gj6ti4rkupgbGSexdjJwcEgImEnd+fmOFsMUkLtxbz9bFyMUhJLCUUaJ93h0m
	mKK2rh1QiemMEosatrJAOE1MEnv3tDGDVLEJaEnsf3GDDcQWEYiWOP70OCNIEbPAZ0aJZ5c2
	ge0TFnCWOHJxMlA3BweLgKrExn25IGFeoPDB66vYILYpSCxbPpMVpFdCYBu7xOwn68DOYBEQ
	kPg2+RBYr4SArMSmA8wQ9ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4m
	RmAUnP73bOIOxvsHrA8xCnAwKvHwclhnhAixJpYVV+YeYjQF2jCRWUo0OR8Ya3kl8YbGZkYW
	piamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCqFH79JvUhNYuN5/33
	vwd/fua6vnB7TM0ZeduUdOfteyYfPBd7V2TOw9vHH9eyxPTP4XGdEi3pxx/74a4iR+7xqBNs
	7dX7k68cu1Du4X41desGZp8A1iot1tdfH00p2/N2V2tv9Mx1fTsP3q1+Uu3b5FOwMSq1zF/C
	TfRuo8Pidze7dz/otelXYinOSDTUYi4qTgQAsOPFSX0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd1pLpkhBg8+C1gsuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WS0u
	rvjC5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB7T5/1k8vi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8btxj3sBX1cFRPPdTE1ME5i72Lk5JAQMJFo69rB
	BmGLSVy4tx7I5uIQEpjOKLGoYSsLhNPEJLF3TxszSBWbgJbE/hc3wDpEBKIljj89zghSxCzw
	mVHi2aVNYGOFBZwljlycDNTNwcEioCqxcV8uSJgXKHzw+iqobQoSy5bPZJ3AyL2AkWEVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnCMPZPewbiqweIQowAHoxIP7waLjBAh1sSy4srcQ4wS
	HMxKIrxLdDJDhHhTEiurUovy44tKc1KLDzGaAi2fyCwlmpwPjP+8knhDYxMzI0sjc0MLI2Nz
	JXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MYrvVJ/P/4qnRKGyJtfSSbWHtesHBd9l37tQn
	J28ebLsz9YP18hSNn5KuVjsUhBdNizPcZMo6d4PhBk7959+iw26dc9wpOHuttbz12l+tBScz
	Tu27svNm2ZT4+JrZl3a+cZ8t5/CCdbLN6VNsKakeMv/b6uZ3HzNqvxayboI9I1cv57rg8nsL
	lViKMxINtZiLihMBmOCZ1ccCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds Samsung S2MPS13 PMIC device driver in existing S2MPS11 PMIC
driver. The S2MPS13 has just the differnet number of regulator from existing
S2MPS14 PMIC and RTC/CLOCK IP of S2MPS13 is the same with S2MPS14. S2MPS13
PMIC has LDO[1-40] and BUCK[1-10] regulators.

Chanwoo Choi (5):
  mfd: sec-core: Add support for S2MPS13 device
  regulator: s2mps11: Add support S2MPS13 regulator device
  clk: s2mps11: Add the support for S2MPS13 PMIC clock
  rtc: s5m: Add the support for S2MPS13 RTC
  mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |  22 +--
 drivers/clk/clk-s2mps11.c                         |  24 +++
 drivers/mfd/sec-core.c                            |  31 ++++
 drivers/mfd/sec-irq.c                             |  23 ++-
 drivers/regulator/Kconfig                         |  10 +-
 drivers/regulator/s2mps11.c                       | 102 +++++++++++-
 drivers/rtc/rtc-s5m.c                             |  15 +-
 include/linux/mfd/samsung/core.h                  |   2 +
 include/linux/mfd/samsung/s2mps13.h               | 186 ++++++++++++++++++++++
 9 files changed, 390 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps13.h

-- 
1.8.5.5

