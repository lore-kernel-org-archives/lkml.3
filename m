Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaFPEms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:42:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46048 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaFPEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:42:43 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-95-539e75c018be
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com
Cc: k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 0/3] mfd: sec-core: Add support S2MPU02 PMIC device
Date: Mon, 16 Jun 2014 13:42:34 +0900
Message-id: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWPdA6bxgg++PLSyuf3nOavH6haHF
	2aY37Bb3vx5ltLi8aw6bxe3GFWwWp7tZLS6u+MLkwOFx59oeNo95JwM9+rasYvT4vEkugCWK
	yyYlNSezLLVI3y6BK+N54w/Wgjs8FWumOTUwXufsYuTkkBAwkfh9so8VwhaTuHBvPVsXIxeH
	kMBSRonfHW3sMEWPmy+zQCQWMUos3zeHHcJpYpK4+XIbWDubgJbE/hc32EBsEQEXiSXd78BG
	MQvMYJQ4uWolE0hCWMBV4uDvCSwgNouAqsS+lwuYQWxeoHjzuqtMEOvkJD7seQS2QULgN5vE
	9OU7oRoEJL5NPgRkcwAlZCU2HWCGqJeUOLjiBssERsEFjAyrGEVTC5ILipPSi4z0ihNzi0vz
	0vWS83M3MQJD9vS/Z307GG8esD7EmAw0biKzlGhyPjDk80riDY3NjCxMTUyNjcwtzUgTVhLn
	XfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY3HAQp0ZMYsibURkM54frPutIMjez372
	ct0EnUsX+7L8Hn1ev8VG/vFUq8tinrHbZb0ezKrOKnheON/5f7XZNVmzpsXsv56/9Y7qtkhX
	k9Y+4tdt8/zBgw2nt1jf/367py0hZwOf1LNvu03e3y1laRDqlNpdmcd1fe6MrUsVL7A/jNn9
	NdvbTomlOCPRUIu5qDgRAHrE48xvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd0DpfOCDR62GFpc//Kc1eL1C0OL
	s01v2C3ufz3KaHF51xw2i9uNK9gsTnezWlxc8YXJgcPjzrU9bB7zTgZ69G1ZxejxeZNcAEtU
	A6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM540/WAvu8FSsmebUwHids4uR
	k0NCwETicfNlFghbTOLCvfVsXYxcHEICixgllu+bww7hNDFJ3Hy5jRWkik1AS2L/ixtsILaI
	gIvEku53YB3MAjMYJU6uWskEkhAWcJU4+HsC2FgWAVWJfS8XMIPYvEDx5nVXmSDWyUl82POI
	fQIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRHxTHoH46oGi0OMAhyMSjy8Exzn
	BQuxJpYVV+YeYpTgYFYS4bX3AQrxpiRWVqUW5ccXleakFh9iTAbaPpFZSjQ5HxiteSXxhsYm
	ZkaWRuaGFkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWFG8Je3oXRbjFv35R2yf
	XOX2mZ53qviS8jfN/qszeThn3rzxqzS7olW9bcJMV8aslfdSNexnlKftZ66QMZuUmp7kw7Xo
	yqrrrsEvt/J16kpdeO6afUtj/6RyU00dNx527gsRH522Z+bm/Vl/NtXw7q6VvakZ2RtsHK59
	mCmTWFzzwLWdoVBUiaU4I9FQi7moOBEAga7m3cwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

his patchset add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

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

