Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaFIGQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:16:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53167 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaFIGQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:16:05 -0400
X-AuditID: cbfee68f-b7fef6d000003970-68-539551174152
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sbkim73@samsung.com,
        sameo@linux.intel.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/3] mfd: sec-core: Add support S2MPU02 PMIC device
Date: Mon, 09 Jun 2014 15:15:45 +0900
Message-id: <1402294548-10380-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkSFc8cGqwwYseJYupD5+wWVz/8pzV
	ovPsE2aL1y8MLc42vWG3uP/1KKPFtysdTBaXd81hs7jduILN4nQ3q8XFFV+YHLg9ds66y+6x
	aVUnm8eda3vYPOadDPTo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujCfbd7EXfOSt+LT3M1sD
	4zOuLkYODgkBE4mGa5VdjJxAppjEhXvr2boYuTiEBJYySjxacIENImEiMXn2UqjEdEaJw5Mb
	WSGcJiaJY/2PGUGq2AS0JPa/uAFWJSLQyyjxpn8aE4jDLDCFUeJjZxPYLGEBV4lvK+aAdbAI
	qEpMfjiTFcTmBYrv2vKHGWKfnMSHPY/YIexF7BJtr8Mg6gUkvk0+xAJxt6zEpgNQ5ZISB1fc
	YJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmCQn/73rH8H490D1ocYk4HGTWSW
	Ek3OB0ZJXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgtGWUvte0SXv1bN5nU9NEiy9vNtZU3Hlm6m9Plui2N38Or/eKttsd02X8/GjitKws3T2+
	emxzQ6yXv6vj733rdvqhlvUN3jr5Mm+Jg5PCIlbwX0qQe8zVOFfxoZdp4xm9EoaJUwIC3bU2
	CvzYPXHVf90XQjmrLkjV3d7He4VZP85D/YLv4gJrJZbijERDLeai4kQAigNkTogCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQV3xwKnBBvvnSVlMffiEzeL6l+es
	Fp1nnzBbvH5haHG26Q27xf2vRxktvl3pYLK4vGsOm8XtxhVsFqe7WS0urvjC5MDtsXPWXXaP
	Tas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcx4sn0Xe8FH3opPez+zNTA+4+pi5OSQEDCRmDx7KRuELSZx4d56IJuLQ0hgOqPE
	4cmNrBBOE5PEsf7HjCBVbAJaEvtf3ACrEhHoZZR40z+NCcRhFpjCKPGxswlslrCAq8S3FXPA
	OlgEVCUmP5zJCmLzAsV3bfnDDLFPTuLDnkfsExi5FzAyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQIjqNn0jsYVzVYHGIU4GBU4uGN+D0lWIg1say4MvcQowQHs5IIr4HV1GAh3pTEyqrU
	ovz4otKc1OJDjMlA2ycyS4km5wNjPK8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGJ27P8o1/hA+Gp+w+MsN4TO3HFsStiWKqPjxFt2a1icqvLds4exPuqqr
	V05YUfBQVmOyueZD9ysZP2bGzroZ9UcwcdO+6uKkS30PGBuCzs6q+pI9t89aSWdt1Zea7WoX
	Hcqtjiz70lAT4X/VYse+S8yL4gvT98w72yLrqbrpTH9BYHi15pbkAiWW4oxEQy3mouJEAHNo
	DNnnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

This patchset had a dependency on regulator.git (Mark Brown) because following
patchset[1-4] has only applied on regulator.git.
[1] https://lkml.org/lkml/2014/4/14/750
[2] https://lkml.org/lkml/2014/4/14/683
[3] https://lkml.org/lkml/2014/5/1/339
[4] https://lkml.org/lkml/2014/5/17/67

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
 drivers/regulator/s2mps11.c                       | 311 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 200 ++++++++++++++
 7 files changed, 654 insertions(+), 21 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

