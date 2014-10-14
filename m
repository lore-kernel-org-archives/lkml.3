Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaJNID1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:03:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35071 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaJNIDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:03:19 -0400
X-AuditID: cbfee68e-f79b46d000002b74-04-543cd8c3c3c3
From: Thomas Abraham <thomas.ab@samsung.com>
To: lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: sec: Add support for S2MPS15 PMIC
Date: Tue, 14 Oct 2014 13:44:28 +0530
Message-id: <1413274468-8765-3-git-send-email-thomas.ab@samsung.com>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
References: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkSvfwDZsQg0krLS0OzH7IatG74Cqb
	xf2vRxktLu+aw+bA4nHn2h42j/MzFjJ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8asb7uZ
	CzaZV+yfcISlgbFbr4uRk0NCwESi9cgpdghbTOLCvfVsILaQwFJGiSuby2Bq3t57xNTFyAUU
	n84oseXhQTYIp41Jon/eEbBuNgEdiRtvfjOC2CICthLTLkPYzALmEv9n9LGA2MIC1hIbr0wD
	q2cRUJXYv2ILK4jNK+AicXlOOyPENiWJDb1HmUBsTgFXic0rYS5ykWh4/psVZLGEwHc2iZb5
	99ggBglIfJt8CGgBB1BCVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kZFecWJucWle
	ul5yfu4mRmD4nv73rG8H480D1ocYBTgYlXh4JcJtQoRYE8uKK3MPMZoCbZjILCWanA+MkryS
	eENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhFNJa1rNvB
	nrim8uc57uVf8tmn/J/gaVHn37j103GHzsnTLsa1nF7f5Maz44RFu4rdArntDZo7Ll3rO+Wk
	/TWNe/emtb9L5xQVPIk3/L3zgPOF745H1KM7jphuufa9hm9HN48UR4VIoBsDa0TBkZQHS9R1
	5+0yqrF3rir2aC9Yt6uXPbHw1TwlluKMREMt5qLiRAAkbjUZWgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQd3DN2xCDFae07c4MPshq0Xvgqts
	Fve/HmW0uLxrDpsDi8eda3vYPM7PWMjo0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZs77tZi7YZF6xf8IRlgbGbr0uRk4OCQETibf3HjFB2GISF+6t
	Z+ti5OIQEpjOKLHl4UEop41Jon/eEXaQKjYBHYkbb34zgtgiArYS0y5D2MwC5hL/Z/SxgNjC
	AtYSG69MA6tnEVCV2L9iCyuIzSvgInF5TjsjxDYliQ29R8E2cwq4SmxeCbKZE2iZi0TD89+s
	Exh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjo9nUjsYVzZYHGIU4GBU4uGVCLcJ
	EWJNLCuuzD3EKMHBrCTCa7wQKMSbklhZlVqUH19UmpNafIjRFOiqicxSosn5wNjNK4k3NDYx
	NzU2tTSxMDGzVBLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAaBbdlS7NX/bh5LPagoUqKzvu
	aOkprNx37sid2kSNfKnJ36PaZlnzzdNepVzSlSLtvfbG3Xo1jz8ust+2isyL+Omgde/Zr0sJ
	Sur8OUEKlR+fyP4Ii2GexLr398TCBWfa7xy0nbJSnvXhlXcFb7mC4zhuNPpJ7+XctuOsdaGT
	wowXV15e+NHkrsRSnJFoqMVcVJwIAHjMg1KlAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for S2MPS15 PMIC which is similar to S2MPS11 PMIC. The S2MPS15
PMIC supports 27 LDO regulators, 10 buck regulators, RTC, three 32.768KHz
clock outputs and battery charger. This patch adds initial support for
LDO and buck regulators of S2MPS15 device.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
---
 drivers/mfd/sec-core.c              |   26 ++++++
 include/linux/mfd/samsung/core.h    |    1 +
 include/linux/mfd/samsung/s2mps15.h |  161 +++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps15.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index dba7e2b..6f33c2b 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/samsung/s2mpa01.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
+#include <linux/mfd/samsung/s2mps15.h>
 #include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
@@ -85,6 +86,12 @@ static const struct mfd_cell s2mps14_devs[] = {
 	}
 };
 
+static const struct mfd_cell s2mps15_devs[] = {
+	{
+		.name = "s2mps15-pmic",
+	},
+};
+
 static const struct mfd_cell s2mpa01_devs[] = {
 	{
 		.name = "s2mpa01-pmic",
@@ -111,6 +118,9 @@ static const struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mps14-pmic",
 		.data = (void *)S2MPS14X,
 	}, {
+		.compatible = "samsung,s2mps15-pmic",
+		.data = (void *)S2MPS15X,
+	}, {
 		.compatible = "samsung,s2mpa01-pmic",
 		.data = (void *)S2MPA01,
 	}, {
@@ -203,6 +213,15 @@ static const struct regmap_config s2mps14_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
+static const struct regmap_config s2mps15_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPS15_REG_LDODSCH4,
+	.volatile_reg = s2mps11_volatile,
+	.cache_type = REGCACHE_FLAT,
+};
+
 static const struct regmap_config s2mpu02_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -328,6 +347,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	case S2MPS14X:
 		regmap = &s2mps14_regmap_config;
 		break;
+	case S2MPS15X:
+		regmap = &s2mps15_regmap_config;
+		break;
 	case S5M8763X:
 		regmap = &s5m8763_regmap_config;
 		break;
@@ -382,6 +404,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		sec_devs = s2mps14_devs;
 		num_sec_devs = ARRAY_SIZE(s2mps14_devs);
 		break;
+	case S2MPS15X:
+		sec_devs = s2mps15_devs;
+		num_sec_devs = ARRAY_SIZE(s2mps15_devs);
+		break;
 	case S2MPU02:
 		sec_devs = s2mpu02_devs;
 		num_sec_devs = ARRAY_SIZE(s2mpu02_devs);
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 1825eda..49ef612 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -42,6 +42,7 @@ enum sec_device_type {
 	S2MPA01,
 	S2MPS11X,
 	S2MPS14X,
+	S2MPS15X,
 	S2MPU02,
 };
 
diff --git a/include/linux/mfd/samsung/s2mps15.h b/include/linux/mfd/samsung/s2mps15.h
new file mode 100644
index 0000000..e82549a
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mps15.h
@@ -0,0 +1,161 @@
+/*
+ * s2mps15.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPS15_H
+#define __LINUX_MFD_S2MPS15_H
+
+/* S2MPS15 registers */
+enum s2mps15_reg {
+	S2MPS15_REG_ID,
+	S2MPS15_REG_INT1,
+	S2MPS15_REG_INT2,
+	S2MPS15_REG_INT3,
+	S2MPS15_REG_INT1M,
+	S2MPS15_REG_INT2M,
+	S2MPS15_REG_INT3M,
+	S2MPS15_REG_ST1,
+	S2MPS15_REG_ST2,
+	S2MPS15_REG_PWRONSRC,
+	S2MPS15_REG_OFFSRC,
+	S2MPS15_REG_BU_CHG,
+	S2MPS15_REG_RTCCTRL,
+	S2MPS15_REG_CTRL1,
+	S2MPS15_REG_CTRL2,
+	S2MPS15_REG_RSVD1,
+	S2MPS15_REG_RSVD2,
+	S2MPS15_REG_RSVD3,
+	S2MPS15_REG_RSVD4,
+	S2MPS15_REG_RSVD5,
+	S2MPS15_REG_RSVD6,
+	S2MPS15_REG_CTRL3,
+	S2MPS15_REG_RSVD7,
+	S2MPS15_REG_RSVD8,
+	S2MPS15_REG_WRSTBI,
+	S2MPS15_REG_B1CTRL1,
+	S2MPS15_REG_B1CTRL2,
+	S2MPS15_REG_B2CTRL1,
+	S2MPS15_REG_B2CTRL2,
+	S2MPS15_REG_B3CTRL1,
+	S2MPS15_REG_B3CTRL2,
+	S2MPS15_REG_B4CTRL1,
+	S2MPS15_REG_B4CTRL2,
+	S2MPS15_REG_B5CTRL1,
+	S2MPS15_REG_B5CTRL2,
+	S2MPS15_REG_B6CTRL1,
+	S2MPS15_REG_B6CTRL2,
+	S2MPS15_REG_B7CTRL1,
+	S2MPS15_REG_B7CTRL2,
+	S2MPS15_REG_B8CTRL1,
+	S2MPS15_REG_B8CTRL2,
+	S2MPS15_REG_B9CTRL1,
+	S2MPS15_REG_B9CTRL2,
+	S2MPS15_REG_B10CTRL1,
+	S2MPS15_REG_B10CTRL2,
+	S2MPS15_REG_BBCTRL1,
+	S2MPS15_REG_BBCTRL2,
+	S2MPS15_REG_BRAMP,
+	S2MPS15_REG_LDODVS1,
+	S2MPS15_REG_LDODVS2,
+	S2MPS15_REG_LDODVS3,
+	S2MPS15_REG_LDODVS4,
+	S2MPS15_REG_L1CTRL,
+	S2MPS15_REG_L2CTRL,
+	S2MPS15_REG_L3CTRL,
+	S2MPS15_REG_L4CTRL,
+	S2MPS15_REG_L5CTRL,
+	S2MPS15_REG_L6CTRL,
+	S2MPS15_REG_L7CTRL,
+	S2MPS15_REG_L8CTRL,
+	S2MPS15_REG_L9CTRL,
+	S2MPS15_REG_L10CTRL,
+	S2MPS15_REG_L11CTRL,
+	S2MPS15_REG_L12CTRL,
+	S2MPS15_REG_L13CTRL,
+	S2MPS15_REG_L14CTRL,
+	S2MPS15_REG_L15CTRL,
+	S2MPS15_REG_L16CTRL,
+	S2MPS15_REG_L17CTRL,
+	S2MPS15_REG_L18CTRL,
+	S2MPS15_REG_L19CTRL,
+	S2MPS15_REG_L20CTRL,
+	S2MPS15_REG_L21CTRL,
+	S2MPS15_REG_L22CTRL,
+	S2MPS15_REG_L23CTRL,
+	S2MPS15_REG_L24CTRL,
+	S2MPS15_REG_L25CTRL,
+	S2MPS15_REG_L26CTRL,
+	S2MPS15_REG_L27CTRL,
+	S2MPS15_REG_LDODSCH1,
+	S2MPS15_REG_LDODSCH2,
+	S2MPS15_REG_LDODSCH3,
+	S2MPS15_REG_LDODSCH4,
+};
+
+/* S2MPS15 regulator ids */
+enum s2mps15_regulators {
+	S2MPS15_LDO1,
+	S2MPS15_LDO2,
+	S2MPS15_LDO3,
+	S2MPS15_LDO4,
+	S2MPS15_LDO5,
+	S2MPS15_LDO6,
+	S2MPS15_LDO7,
+	S2MPS15_LDO8,
+	S2MPS15_LDO9,
+	S2MPS15_LDO10,
+	S2MPS15_LDO11,
+	S2MPS15_LDO12,
+	S2MPS15_LDO13,
+	S2MPS15_LDO14,
+	S2MPS15_LDO15,
+	S2MPS15_LDO16,
+	S2MPS15_LDO17,
+	S2MPS15_LDO18,
+	S2MPS15_LDO19,
+	S2MPS15_LDO20,
+	S2MPS15_LDO21,
+	S2MPS15_LDO22,
+	S2MPS15_LDO23,
+	S2MPS15_LDO24,
+	S2MPS15_LDO25,
+	S2MPS15_LDO26,
+	S2MPS15_LDO27,
+	S2MPS15_BUCK1,
+	S2MPS15_BUCK2,
+	S2MPS15_BUCK3,
+	S2MPS15_BUCK4,
+	S2MPS15_BUCK5,
+	S2MPS15_BUCK6,
+	S2MPS15_BUCK7,
+	S2MPS15_BUCK8,
+	S2MPS15_BUCK9,
+	S2MPS15_BUCK10,
+	S2MPS15_BUCK11,
+	S2MPS15_REGULATOR_MAX,
+};
+
+#define S2MPS15_LDO_VSEL_MASK		(0x3F)
+#define S2MPS15_BUCK_VSEL_MASK		(0xFF)
+
+#define S2MPS15_ENABLE_SHIFT		(0x06)
+#define S2MPS15_ENABLE_MASK		(0x03 << S2MPS15_ENABLE_SHIFT)
+
+#define S2MPS15_LDO_N_VOLTAGES		(S2MPS15_LDO_VSEL_MASK + 1)
+#define S2MPS15_BUCK_N_VOLTAGES	(S2MPS15_BUCK_VSEL_MASK + 1)
+
+#endif /*  __LINUX_MFD_S2MPS15_H */
-- 
1.6.6.rc2

