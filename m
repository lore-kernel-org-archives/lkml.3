Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaFIKVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:21:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54001 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaFIKVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:21:43 -0400
X-AuditID: cbfee68f-b7fef6d000003970-35-53958ab50c8a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sbkim73@samsung.com,
        sameo@linux.intel.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/3] mfd: sec-core: Add support S2MPU02 PMIC device
Date: Mon, 09 Jun 2014 19:21:36 +0900
Message-id: <1402309299-7805-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkWHdr19Rgg8/XlCymPnzCZnH9y3NW
	i86zT5gtXr8wtDjb9Ibd4v7Xo4wW3650MFlc3jWHzeJ24wo2i9PdrBYXV3xhcuD22DnrLrvH
	plWdbB53ru1h85h3MtCjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4MrbcXspcsI+vYtbLXUwN
	jMu5uxg5OSQETCRmTVzICmGLSVy4t54NxBYSWMoo0bwhCabm1ZPlQDVcQPFFjBKHDxxjhHCa
	mCS+XlwE1s0moCWx/8UNNpCEiEAvo8Sb/mlMIA6zwBRGiY+dTWBzhQVcJRoO7wRKcHCwCKhK
	rDhsB2LyCrhIbFzqArFNTuLDnkfsIK0SAsvYJTpmLAVbwCIgIPFt8iEWkHoJAVmJTQeYIeol
	JQ6uuMEygVFwASPDKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzAED/971n/Dsa7B6wPMSYD
	jZvILCWanA+MkbySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwGgYw9e/9tmsCJHa4sVuc8USsy2fSXkHiH4ubfjUxWkxi7st9eCru4/nPnH9/Mzk
	gZHe/v0RB4U/2k2bLrLZgf9V5ElZhu9ldjMNxLI8BU6t+6NYMs/IQ6Uq50nU1/bHVXpGi+90
	KEa8U+E0sIj7ne30veFH8BGBc04fJirH/fq41GKK3o93KkosxRmJhlrMRcWJAHsscFeHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd2tXVODDb5uk7KY+vAJm8X1L89Z
	LTrPPmG2eP3C0OJs0xt2i/tfjzJafLvSwWRxedccNovbjSvYLE53s1pcXPGFyYHbY+esu+we
	m1Z1snncubaHzWPeyUCPvi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5ix5fZS5oJ9fBWzXu5iamBczt3FyMkhIWAi8erJclYIW0ziwr31bF2MXBxCAosY
	JQ4fOMYI4TQxSXy9uAisik1AS2L/ixtgVSICvYwSb/qnMYE4zAJTGCU+djaxgVQJC7hKNBze
	CZTg4GARUJVYcdgOxOQVcJHYuNQFYpucxIc9j9gnMHIvYGRYxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREcQ8+kdzCuarA4xCjAwajEwxvxe0qwEGtiWXFl7iFGCQ5mJRFen5ypwUK8KYmV
	ValF+fFFpTmpxYcYk4F2T2SWEk3OB8Z3Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNL
	UrNTUwtSi2C2MHFwSjUwOhvrK2ldePlE8ezhc/M9JwY0rUlnDH9mOWMT25RduxZP2ny5tV7n
	UJPrw+07DA0jCtiXnk03LlgYK8104qL7ZPVLRowMRekfpj1oKtbSuL9a0ZJf1VxVPGjerOXV
	TIcFnue7X1HMddotGp3s65Ta8PrisUnioaI7f8ao+5nKBTy9N3GJtSKHEktxRqKhFnNRcSIA
	HMhuR+UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

This patchset had a dependency on regulator.git (Mark Brown) because following
patchset[1-4] has only applied on regulator.git.
[1] https://lkml.org/lkml/2014/4/14/750
[2] https://lkml.org/lkml/2014/4/14/683
[3] https://lkml.org/lkml/2014/5/1/339
[4] https://lkml.org/lkml/2014/5/17/67

Changes from v3:
- Fix bug of s2mps14_regulator_set_suspend_disable()

Changes from v2:
- Change patchset name
- Remove un-necessary switch statement
- Add acked message by Mark Brown for regulator patch
- Add reviewed message by Krzysztof Kozlowski for all patchs

Changes from v1:
- Fix typo about patch description
- Use existing suspend_state variable instead of defining new variable for S2MPU02
- Remove unnecessary parameter of s2mps11_pmic_dt_parse()
- Remove unfit comment of s2mpu02.h file
- Both patch2 and patch3 should be squashed on patch2

Chanwoo Choi (3):
  mfd: sec-core: Add support for S2MPU02 device
  regulator: s2mps11: Add support S2MPU02 regulator device
  dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
 drivers/mfd/sec-core.c                            |  44 +++
 drivers/mfd/sec-irq.c                             |  88 ++++++
 drivers/regulator/s2mps11.c                       | 321 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 201 ++++++++++++++
 7 files changed, 663 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

