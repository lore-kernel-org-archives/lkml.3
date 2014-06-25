Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaFYHQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:16:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44749 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaFYHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:14:52 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-2f-53aa76eab842
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 4/4] mfd: sec-core: Prepare regulators for suspend state to
 reduce power-consumption
Date: Wed, 25 Jun 2014 16:14:47 +0900
Message-id: <1403680487-12141-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
References: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkSPd12apgg3UrWSymPnzCZnH9y3NW
	i7NNb9gt7n89ymhxedccNovbjSvYLE53s1pcXPGFyYHDY9OqTjaPO9f2sHnMOxno0bdlFaPH
	501yAaxRXDYpqTmZZalF+nYJXBkPr+1lL1jCXdG0dxtLA+Nqzi5GTg4JAROJq0/mMUHYYhIX
	7q1n62Lk4hASWMooMfPdJUaYork/W1kgEtMZJdoOXoaqamKS2HrxBytIFZuAlsT+FzfYQGwR
	gSiJuQu/g9nMArUS+641gdUIC2RIfL41gx3EZhFQlTh2fD/YBl4BV4lti18xQ2yTk/iw5xFY
	DaeAm0TP+pNgc4SAaq4fOQd10Tx2ibPnaiDmCEh8m3wI6DoOoLisxKYDUGMkJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAYD/979nEHYz3D1gfYkwGGjeRWUo0OR8Y
	LXkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwHhk
	tULeEzmNdZFqb/cz+Fm8/8doFtiRJanWuseFs4irvTtDTL415Yd7L/O3gnVa+2Zxce/5vGr6
	qcUJy7uXKr3Ib337zvba9N4d5V8urDZyXKsblH3uf9i9yC02jBK9Mx0tuE9fe/pIrK+HZ6Fe
	0KabU6av905V01Wpnntul5fKJZ5lKR9MHyuxFGckGmoxFxUnAgCePJWXjAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jQd1XZauCDf59sbSY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CxuN65gszjdzWpxccUXJgcOj02rOtk87lzbw+Yx72SgR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMeHhtL3vBEu6Kpr3b
	WBoYV3N2MXJySAiYSMz92coCYYtJXLi3nq2LkYtDSGA6o0TbwctQThOTxNaLP1hBqtgEtCT2
	v7jBBmKLCERJzF34HcxmFqiV2HetCaxGWCBD4vOtGewgNouAqsSx4/sZQWxeAVeJbYtfMUNs
	k5P4sOcRWA2ngJtEz/qTYHOEgGquHznHOIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4Gh6JrWDcWWDxSFGAQ5GJR7eC7NXBguxJpYVV+YeYpTgYFYS4b3ktSpYiDclsbIqtSg/
	vqg0J7X4EKMp0FUTmaVEk/OBkZ5XEm9obGJmZGlkbmhhZGyuJM57oNU6UEggPbEkNTs1tSC1
	CKaPiYNTqoHRtceRx+3AbLm1URuU8sSF1s7J/nmt4VsV17tK42ztpC1GvrelO5+/+3/s9rbf
	dTc8uG4+tF+uGZgyo8KUQYZ1QbGGdk4AZ8ll54+bk5L+mFzcecO4VCVtss8/W4/Pv1anB1W+
	WSPP/uTVvbszFIpONmYGsx06KHvjo1+axcs2ewODHi6boNlKLMUZiYZazEXFiQB4BqS6vAIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use regulator_suspend_prepare() function to prepare the proper state
of regulators for suspend state to remove un-necessary leakage power-consumption.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/Kconfig    |  1 +
 drivers/mfd/sec-core.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index af0e83f..b5898dc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -586,6 +586,7 @@ config MFD_SEC_CORE
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
+	select REGULATOR
 	help
 	 Support for the Samsung Electronics MFD series.
 	 This driver provides common support for accessing the device,
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 2621328..fb8ba64 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
+#include <linux/regulator/machine.h>
 #include <linux/regmap.h>
 
 static const struct mfd_cell s5m8751_devs[] = {
@@ -430,6 +431,15 @@ static int sec_pmic_suspend(struct device *dev)
 	 */
 	disable_irq(sec_pmic->irq);
 
+	switch (sec_pmic->device_type) {
+	case S2MPS14X:
+	case S2MPU02:
+		regulator_suspend_prepare(PM_SUSPEND_MEM);
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-- 
1.8.0

