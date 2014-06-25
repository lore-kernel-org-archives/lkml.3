Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaFYHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:14:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaFYHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:14:51 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-08-53aa76e9b781
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 0/4] mfd: sec-core: Add support S2MPU02 PMIC device
Date: Wed, 25 Jun 2014 16:14:43 +0900
Message-id: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkSPdl2apgg67H/BZTHz5hs7j+5Tmr
	xdmmN+wW978eZbS4vGsOm8XtxhVsFqe7WS0urvjC5MDhsWlVJ5vHnWt72DzmnQz06NuyitHj
	8ya5ANYoLpuU1JzMstQifbsErow/6z4zFnQLVry9tYe1gbGHt4uRk0NCwERi1Z8nLBC2mMSF
	e+vZuhi5OIQEljJKTOvcwAJT9Lx/CVRiOqPEx5+fWSCcJiaJzqlnGUGq2AS0JPa/uMEGYosI
	REnMXfgdzGYWqJXYd62JFcQWFnCVOPH2HpjNIqAq0Tb/OjuIzQsUn/X/DzvENjmJD3sesYMs
	kBD4zybx6uN6NogGAYlvkw8BbeYASshKbDrADFEvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ
	6hUn5haX5qXrJefnbmIEhu/pf896dzDePmB9iDEZaNxEZinR5Hxg+OeVxBsamxlZmJqYGhuZ
	W5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OkVXqzDfhOxuobF1X/npHj
	3vgu5vzPhmn/dj7Kkjac9O/g03QDK5Wa+OV210W9WA43TH5ZsPRdwtptBT3L9oTULrgQdeKp
	Mt9K0eRXmV+1ll27/2Sm85dv7m/6Am8zyx79vnOS/o7mkl0vhM7b/q39q3H/id+Co3dY3k7g
	2h8e6BgZp+TmpCijxFKckWioxVxUnAgA6UXZvHUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQd2XZauCDXaeZ7eY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CxuN65gszjdzWpxccUXJgcOj02rOtk87lzbw+Yx72SgR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+LPuM2NBt2DF21t7
	WBsYe3i7GDk5JARMJJ73L2GDsMUkLtxbD2RzcQgJTGeU+PjzMwuE08Qk0Tn1LCNIFZuAlsT+
	FzfAOkQEoiTmLvwOZjML1Ersu9bECmILC7hKnHh7D8xmEVCVaJt/nR3E5gWKz/r/hx1im5zE
	hz2P2Ccwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwdz6R3MK5qsDjEKMDBqMTD
	e2H2ymAh1sSy4srcQ4wSHMxKIryXvFYFC/GmJFZWpRblxxeV5qQWH2I0Bdo+kVlKNDkfGLl5
	JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYmUQ/utrum9h0Ns+0
	LsxEJKIs+efmipzq0ppn4X1afbLOf14vX3fiu4PrEumQInGTr/e1hQ7Zmjc7pprzCfW8mnX7
	nabMI2WhV4uNnn7W0LicaqI7YZrgRwn3dq+ih6/+dzUrnBRPEpysamFocPrPi1zF12febujP
	k61fotn01r2rMkzMxlqJpTgj0VCLuag4EQDnlYvCpAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

Changes from v7:
- Add 'REGULATOR' dependency to MFD_SEC_CORE in drivers/mfd/Kconfig
- Remove unneeded simicolon

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
 drivers/mfd/Kconfig                               |   1 +
 drivers/mfd/sec-core.c                            |  81 +++++-
 drivers/mfd/sec-irq.c                             | 110 ++++++--
 drivers/regulator/s2mps11.c                       | 321 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 201 ++++++++++++++
 8 files changed, 693 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

