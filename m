Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaFRXwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:52:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18757 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaFRXwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:52:30 -0400
X-AuditID: cbfee68f-b7fef6d000003970-36-53a2263cd891
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 0/4] mfd: sec-core: Add support S2MPU02 PMIC device
Date: Thu, 19 Jun 2014 08:52:21 +0900
Message-id: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkWNdGbVGwwbNLbBZTHz5hs7j+5Tmr
	xdmmN+wW978eZbS4vGsOm8XtxhVsFqe7WS0urvjC5MDhsWlVJ5vHnWt72DzmnQz06NuyitHj
	8ya5ANYoLpuU1JzMstQifbsEroyHF6azFNzkr+ibe5StgXEKTxcjJ4eEgInE6y87mSBsMYkL
	99azdTFycQgJLGWUuLP3EQtM0b4N69ghEosYJabdO8wI4TQxSUzZ2sAMUsUmoCWx/8UNNhBb
	RCBKYu7C72A2s0CtxL5rTawgtrCAq8S/pyfB6lkEVCXWXF8LZvMKuEj0NE2FOkNO4sOeR2Db
	JATa2SXuXLoE1SAg8W3yIaCTOIASshKbDjBD1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRcZ6
	xYm5xaV56XrJ+bmbGIHhe/rfs/4djHcPWB9iTAYaN5FZSjQ5Hxj+eSXxhsZmRhamJqbGRuaW
	ZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUfBhrSeX4Lx8ybCfa1M/MM1h
	dTeZxmo/Z0bs1X9xctxHfz1Yd3XqIwX+L8tnqEzoCjQ+rcWwW3S9kJ+zjle8fuckvd66ZnXd
	VRGTDG8bGkrKFVZ/5H49UTu3Zd7HdOMjNaLrnrxa865iLy9XzITJe+Xz9E0+O+3W39kwMdfl
	sfbUy2FRVwLnK7EUZyQaajEXFScCAGnS11J1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jAV1rtUXBBi07rS2mPnzCZnH9y3NW
	i7NNb9gt7n89ymhxedccNovbjSvYLE53s1pcXPGFyYHDY9OqTjaPO9f2sHnMOxno0bdlFaPH
	501yAaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzHl6YzlJwk7+ib+5R
	tgbGKTxdjJwcEgImEvs2rGOHsMUkLtxbz9bFyMUhJLCIUWLavcOMEE4Tk8SUrQ3MIFVsAloS
	+1/cYAOxRQSiJOYu/A5mMwvUSuy71sQKYgsLuEr8e3oSrJ5FQFVizfW1YDavgItET9NUJoht
	chIf9jxin8DIvYCRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcHQ8k9rBuLLB4hCjAAej
	Eg+vx8WFwUKsiWXFlbmHGCU4mJVEeOV/AYV4UxIrq1KL8uOLSnNSiw8xJgNtn8gsJZqcD4zc
	vJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpglOWaHcMs8GvJ
	pt/rDRey8uyYMeG33fxjTxSaKrZfzDbS6qr7OL1h37ey+s1T4i+tjmI5eq4wIdM5++HsoAn3
	WT4vrY9ZfzVSYhn3BDODldF3+W/9+SowSd6LyS7mzH2rtay6n5ZPWu7Atyj05a4jJ3atlb3M
	ePqU3Ql3g9I6z0czmd+JV4dOVlViKc5INNRiLipOBABW0+yo0gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

Changes from v6:
- Fix bisectable build error
- This patchset includes separate patch[1]
 [1] https://lkml.org/lkml/2014/6/9/307

Changes from v5:
- Remove the duplicate code about mfd_add_devices() and regmap_add_irq_chip()
- Add acked message by Lee Jones for mfd patch on patch2

Changes from v4:
- This patchset is rebased on 'Linux 3.16-rc1'.

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

Chanwoo Choi (4):
  mfd: sec-core: Add support for S2MPU02 device
  regulator: s2mps11: Add support S2MPU02 regulator device
  dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
  mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
 drivers/mfd/sec-core.c                            |  79 +++++-
 drivers/mfd/sec-irq.c                             | 110 ++++++--
 drivers/regulator/s2mps11.c                       | 321 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 201 ++++++++++++++
 7 files changed, 690 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

