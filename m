Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaFRXwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:52:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18757 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaFRXwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:52:31 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-23-53a2263c7213
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 1/4] mfd: sec-core: Add support for S2MPU02 device
Date: Thu, 19 Jun 2014 08:52:22 +0900
Message-id: <1403135545-7451-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
References: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkQNdGbVGwQetJXYupD5+wWVz/8pzV
	4mzTG3aL+1+PMlpc3jWHzeJ24wo2i9PdrBYXV3xhcuDw2LSqk83jzrU9bB7zTgZ69G1Zxejx
	eZNcAGsUl01Kak5mWWqRvl0CV8b9HWuZCtYXVyxatIyxgfFTXBcjJ4eEgInEmUUv2CFsMYkL
	99azdTFycQgJLGWUWDnjDwtM0efLu5lAbCGBRYwSj98qQxQ1MUkcn3iHFSTBJqAlsf/FDTYQ
	W0QgSmLuwu9gNrNArcS+a01gNcICLhKXfv0Ei7MIqEqsOTiBGcTmBYq/ftvGCLFMTuLDnkdg
	F3EKuEq8+vOYBWKxi8SvRw2sIIslBOaxS/S/XMUEMUhA4tvkQ0BFHEAJWYlNB5gh5khKHFxx
	g2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIHBfvrfs4k7GO8fsD7EmAw0biKz
	lGhyPjBa8kriDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qB0b6Kf9LyPVY1k6oVQ5+06jP+vPi0ZM8Xk6LJBW8tJy3reCD46Vu5Y3m4gSH7OUaT3NSz
	x5jevS5iyQs/NaHsl6K4q4mjjqORgqxi7YOQAPVOiyDlhPbzjBV2AqEFNZovYx3kntlyMxYx
	Tqree6PpVb3tWyPjN+s6Fbcn3vkYz/rET7fjv7gSS3FGoqEWc1FxIgAr3to/jAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAV0btUXBBhMOqlpMffiEzeL6l+es
	Fmeb3rBb3P96lNHi8q45bBa3G1ewWZzuZrW4uOILkwOHx6ZVnWwed67tYfOYdzLQo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3N+xlqlgfXHFokXL
	GBsYP8V1MXJySAiYSHy+vJsJwhaTuHBvPRuILSSwiFHi8VvlLkYuILuJSeL4xDusIAk2AS2J
	/S9ugBWJCERJzF34HcxmFqiV2HetCaxGWMBF4tKvn2BxFgFViTUHJzCD2LxA8ddv2xghlslJ
	fNjziB3E5hRwlXj15zELxGIXiV+PGlgnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcS8+kdjCubLA4xCjAwajEw+txcWGwEGtiWXFl7iFGCQ5mJRFe+V9AId6UxMqq1KL8+KLS
	nNTiQ4zJQFdNZJYSTc4HxnleSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTA2ZQaX7OUJDF1f9er3oz8LdxTV3/yyV6X+1s95qpwP24XUjrB2TvjKu9NDJ+pW
	2KFfps3BtkpedWH+L0rq7y/tb66YlTKl4ea+o5Ifyo89TtE6sd/2ymO5Rz9VWRhWGq1qDSyr
	vuZX4DX7dMrvReE/Xic0HGCKCLIsM10644j9678rzFb+/dOlxFKckWioxVxUnAgAEnCd1OkC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
The S2MPU02 device includes PMIC/RTC/Clock devices.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c              |  46 ++++++---
 drivers/mfd/sec-irq.c               | 110 +++++++++++++++++---
 include/linux/mfd/samsung/core.h    |   1 +
 include/linux/mfd/samsung/irq.h     |  24 +++++
 include/linux/mfd/samsung/s2mpu02.h | 201 ++++++++++++++++++++++++++++++++++++
 5 files changed, 352 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index be06d0a..15ba847 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -89,6 +89,15 @@ static const struct mfd_cell s2mpa01_devs[] = {
 	},
 };
 
+static const struct mfd_cell s2mpu02_devs[] = {
+	{ .name = "s2mpu02-pmic", },
+	{ .name = "s2mpu02-rtc", },
+	{
+		.name = "s2mpu02-clk",
+		.of_compatible = "samsung,s2mpu02-clk",
+	}
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
@@ -103,6 +112,9 @@ static const struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mpa01-pmic",
 		.data = (void *)S2MPA01,
 	}, {
+		.compatible = "samsung,s2mpu02-pmic",
+		.data = (void *)S2MPU02,
+	}, {
 		/* Sentinel */
 	},
 };
@@ -250,9 +262,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 {
 	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	const struct regmap_config *regmap;
+	const struct mfd_cell *sec_devs;
 	struct sec_pmic_dev *sec_pmic;
 	unsigned long device_type;
-	int ret;
+	int ret, num_sec_devs;
 
 	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
 				GFP_KERNEL);
@@ -319,34 +332,39 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 
 	switch (sec_pmic->device_type) {
 	case S5M8751X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8751_devs,
-				      ARRAY_SIZE(s5m8751_devs), NULL, 0, NULL);
+		sec_devs = s5m8751_devs;
+		num_sec_devs = ARRAY_SIZE(s5m8751_devs);
 		break;
 	case S5M8763X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8763_devs,
-				      ARRAY_SIZE(s5m8763_devs), NULL, 0, NULL);
+		sec_devs = s5m8763_devs;
+		num_sec_devs = ARRAY_SIZE(s5m8763_devs);
 		break;
 	case S5M8767X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
-				      ARRAY_SIZE(s5m8767_devs), NULL, 0, NULL);
+		sec_devs = s5m8767_devs;
+		num_sec_devs = ARRAY_SIZE(s5m8767_devs);
 		break;
 	case S2MPA01:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpa01_devs,
-				      ARRAY_SIZE(s2mpa01_devs), NULL, 0, NULL);
+		sec_devs = s2mpa01_devs;
+		num_sec_devs = ARRAY_SIZE(s2mpa01_devs);
 		break;
 	case S2MPS11X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
-				      ARRAY_SIZE(s2mps11_devs), NULL, 0, NULL);
+		sec_devs = s2mps11_devs;
+		num_sec_devs = ARRAY_SIZE(s2mps11_devs);
 		break;
 	case S2MPS14X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
-				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
+		sec_devs = s2mps14_devs;
+		num_sec_devs = ARRAY_SIZE(s2mps14_devs);
+		break;
+	case S2MPU02:
+		sec_devs = s2mpu02_devs;
+		num_sec_devs = ARRAY_SIZE(s2mpu02_devs);
 		break;
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
 	}
-
+	ret = mfd_add_devices(sec_pmic->dev, -1, sec_devs, num_sec_devs, NULL,
+			      0, NULL);
 	if (ret)
 		goto err_mfd;
 
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 654e2c1..f9a5786 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -20,6 +20,7 @@
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
+#include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
@@ -161,6 +162,77 @@ static const struct regmap_irq s2mps14_irqs[] = {
 	},
 };
 
+static const struct regmap_irq s2mpu02_irqs[] = {
+	[S2MPU02_IRQ_PWRONF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRONF_MASK,
+	},
+	[S2MPU02_IRQ_PWRONR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRONR_MASK,
+	},
+	[S2MPU02_IRQ_JIGONBF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_JIGONBF_MASK,
+	},
+	[S2MPU02_IRQ_JIGONBR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_JIGONBR_MASK,
+	},
+	[S2MPU02_IRQ_ACOKBF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_ACOKBF_MASK,
+	},
+	[S2MPU02_IRQ_ACOKBR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_ACOKBR_MASK,
+	},
+	[S2MPU02_IRQ_PWRON1S] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRON1S_MASK,
+	},
+	[S2MPU02_IRQ_MRB] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_MRB_MASK,
+	},
+	[S2MPU02_IRQ_RTC60S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTC60S_MASK,
+	},
+	[S2MPU02_IRQ_RTCA1] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTCA1_MASK,
+	},
+	[S2MPU02_IRQ_RTCA0] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTCA0_MASK,
+	},
+	[S2MPU02_IRQ_SMPL] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_SMPL_MASK,
+	},
+	[S2MPU02_IRQ_RTC1S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTC1S_MASK,
+	},
+	[S2MPU02_IRQ_WTSR] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_WTSR_MASK,
+	},
+	[S2MPU02_IRQ_INT120C] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_INT120C_MASK,
+	},
+	[S2MPU02_IRQ_INT140C] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_INT140C_MASK,
+	},
+	[S2MPU02_IRQ_TSD] = {
+		.reg_offset = 2,
+		.mask = S2MPS14_IRQ_TSD_MASK,
+	},
+};
+
 static const struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
 		.reg_offset = 0,
@@ -327,6 +399,16 @@ static const struct regmap_irq_chip s2mps14_irq_chip = {
 	.ack_base = S2MPS14_REG_INT1,
 };
 
+static const struct regmap_irq_chip s2mpu02_irq_chip = {
+	.name = "s2mpu02",
+	.irqs = s2mpu02_irqs,
+	.num_irqs = ARRAY_SIZE(s2mpu02_irqs),
+	.num_regs = 3,
+	.status_base = S2MPU02_REG_INT1,
+	.mask_base = S2MPU02_REG_INT1M,
+	.ack_base = S2MPU02_REG_INT1,
+};
+
 static const struct regmap_irq_chip s5m8767_irq_chip = {
 	.name = "s5m8767",
 	.irqs = s5m8767_irqs,
@@ -351,6 +433,7 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 {
 	int ret = 0;
 	int type = sec_pmic->device_type;
+	const struct regmap_irq_chip *sec_irq_chip;
 
 	if (!sec_pmic->irq) {
 		dev_warn(sec_pmic->dev,
@@ -361,28 +444,19 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 
 	switch (type) {
 	case S5M8763X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s5m8763_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s5m8763_irq_chip;
 		break;
 	case S5M8767X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s5m8767_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s5m8767_irq_chip;
 		break;
 	case S2MPS11X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s2mps11_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s2mps11_irq_chip;
 		break;
 	case S2MPS14X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s2mps14_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s2mps14_irq_chip;
+		break;
+	case S2MPU02:
+		sec_irq_chip = &s2mpu02_irq_chip;
 		break;
 	default:
 		dev_err(sec_pmic->dev, "Unknown device type %lu\n",
@@ -390,6 +464,10 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 		return -EINVAL;
 	}
 
+	ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
+			  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+			  sec_pmic->irq_base, sec_irq_chip,
+			  &sec_pmic->irq_data);
 	if (ret != 0) {
 		dev_err(sec_pmic->dev, "Failed to register IRQ chip: %d\n", ret);
 		return ret;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 47d8424..b5f73de 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -21,6 +21,7 @@ enum sec_device_type {
 	S2MPA01,
 	S2MPS11X,
 	S2MPS14X,
+	S2MPU02,
 };
 
 /**
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index 1224f44..f35af73 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -129,6 +129,30 @@ enum s2mps14_irq {
 	S2MPS14_IRQ_NR,
 };
 
+enum s2mpu02_irq {
+	S2MPU02_IRQ_PWRONF,
+	S2MPU02_IRQ_PWRONR,
+	S2MPU02_IRQ_JIGONBF,
+	S2MPU02_IRQ_JIGONBR,
+	S2MPU02_IRQ_ACOKBF,
+	S2MPU02_IRQ_ACOKBR,
+	S2MPU02_IRQ_PWRON1S,
+	S2MPU02_IRQ_MRB,
+
+	S2MPU02_IRQ_RTC60S,
+	S2MPU02_IRQ_RTCA1,
+	S2MPU02_IRQ_RTCA0,
+	S2MPU02_IRQ_SMPL,
+	S2MPU02_IRQ_RTC1S,
+	S2MPU02_IRQ_WTSR,
+
+	S2MPU02_IRQ_INT120C,
+	S2MPU02_IRQ_INT140C,
+	S2MPU02_IRQ_TSD,
+
+	S2MPU02_IRQ_NR,
+};
+
 /* Masks for interrupts are the same as in s2mps11 */
 #define S2MPS14_IRQ_TSD_MASK		(1 << 2)
 
diff --git a/include/linux/mfd/samsung/s2mpu02.h b/include/linux/mfd/samsung/s2mpu02.h
new file mode 100644
index 0000000..47ae9bc
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mpu02.h
@@ -0,0 +1,201 @@
+/*
+ * s2mpu02.h
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
+#ifndef __LINUX_MFD_S2MPU02_H
+#define __LINUX_MFD_S2MPU02_H
+
+/* S2MPU02 registers */
+enum S2MPU02_reg {
+	S2MPU02_REG_ID,
+	S2MPU02_REG_INT1,
+	S2MPU02_REG_INT2,
+	S2MPU02_REG_INT3,
+	S2MPU02_REG_INT1M,
+	S2MPU02_REG_INT2M,
+	S2MPU02_REG_INT3M,
+	S2MPU02_REG_ST1,
+	S2MPU02_REG_ST2,
+	S2MPU02_REG_PWRONSRC,
+	S2MPU02_REG_OFFSRC,
+	S2MPU02_REG_BU_CHG,
+	S2MPU02_REG_RTCCTRL,
+	S2MPU02_REG_PMCTRL1,
+	S2MPU02_REG_RSVD1,
+	S2MPU02_REG_RSVD2,
+	S2MPU02_REG_RSVD3,
+	S2MPU02_REG_RSVD4,
+	S2MPU02_REG_RSVD5,
+	S2MPU02_REG_RSVD6,
+	S2MPU02_REG_RSVD7,
+	S2MPU02_REG_WRSTEN,
+	S2MPU02_REG_RSVD8,
+	S2MPU02_REG_RSVD9,
+	S2MPU02_REG_RSVD10,
+	S2MPU02_REG_B1CTRL1,
+	S2MPU02_REG_B1CTRL2,
+	S2MPU02_REG_B2CTRL1,
+	S2MPU02_REG_B2CTRL2,
+	S2MPU02_REG_B3CTRL1,
+	S2MPU02_REG_B3CTRL2,
+	S2MPU02_REG_B4CTRL1,
+	S2MPU02_REG_B4CTRL2,
+	S2MPU02_REG_B5CTRL1,
+	S2MPU02_REG_B5CTRL2,
+	S2MPU02_REG_B5CTRL3,
+	S2MPU02_REG_B5CTRL4,
+	S2MPU02_REG_B5CTRL5,
+	S2MPU02_REG_B6CTRL1,
+	S2MPU02_REG_B6CTRL2,
+	S2MPU02_REG_B7CTRL1,
+	S2MPU02_REG_B7CTRL2,
+	S2MPU02_REG_RAMP1,
+	S2MPU02_REG_RAMP2,
+	S2MPU02_REG_L1CTRL,
+	S2MPU02_REG_L2CTRL1,
+	S2MPU02_REG_L2CTRL2,
+	S2MPU02_REG_L2CTRL3,
+	S2MPU02_REG_L2CTRL4,
+	S2MPU02_REG_L3CTRL,
+	S2MPU02_REG_L4CTRL,
+	S2MPU02_REG_L5CTRL,
+	S2MPU02_REG_L6CTRL,
+	S2MPU02_REG_L7CTRL,
+	S2MPU02_REG_L8CTRL,
+	S2MPU02_REG_L9CTRL,
+	S2MPU02_REG_L10CTRL,
+	S2MPU02_REG_L11CTRL,
+	S2MPU02_REG_L12CTRL,
+	S2MPU02_REG_L13CTRL,
+	S2MPU02_REG_L14CTRL,
+	S2MPU02_REG_L15CTRL,
+	S2MPU02_REG_L16CTRL,
+	S2MPU02_REG_L17CTRL,
+	S2MPU02_REG_L18CTRL,
+	S2MPU02_REG_L19CTRL,
+	S2MPU02_REG_L20CTRL,
+	S2MPU02_REG_L21CTRL,
+	S2MPU02_REG_L22CTRL,
+	S2MPU02_REG_L23CTRL,
+	S2MPU02_REG_L24CTRL,
+	S2MPU02_REG_L25CTRL,
+	S2MPU02_REG_L26CTRL,
+	S2MPU02_REG_L27CTRL,
+	S2MPU02_REG_L28CTRL,
+	S2MPU02_REG_LDODSCH1,
+	S2MPU02_REG_LDODSCH2,
+	S2MPU02_REG_LDODSCH3,
+	S2MPU02_REG_LDODSCH4,
+	S2MPU02_REG_SELMIF,
+	S2MPU02_REG_RSVD11,
+	S2MPU02_REG_RSVD12,
+	S2MPU02_REG_RSVD13,
+	S2MPU02_REG_DVSSEL,
+	S2MPU02_REG_DVSPTR,
+	S2MPU02_REG_DVSDATA,
+};
+
+/* S2MPU02 regulator ids */
+enum S2MPU02_regulators {
+	S2MPU02_LDO1,
+	S2MPU02_LDO2,
+	S2MPU02_LDO3,
+	S2MPU02_LDO4,
+	S2MPU02_LDO5,
+	S2MPU02_LDO6,
+	S2MPU02_LDO7,
+	S2MPU02_LDO8,
+	S2MPU02_LDO9,
+	S2MPU02_LDO10,
+	S2MPU02_LDO11,
+	S2MPU02_LDO12,
+	S2MPU02_LDO13,
+	S2MPU02_LDO14,
+	S2MPU02_LDO15,
+	S2MPU02_LDO16,
+	S2MPU02_LDO17,
+	S2MPU02_LDO18,
+	S2MPU02_LDO19,
+	S2MPU02_LDO20,
+	S2MPU02_LDO21,
+	S2MPU02_LDO22,
+	S2MPU02_LDO23,
+	S2MPU02_LDO24,
+	S2MPU02_LDO25,
+	S2MPU02_LDO26,
+	S2MPU02_LDO27,
+	S2MPU02_LDO28,
+	S2MPU02_BUCK1,
+	S2MPU02_BUCK2,
+	S2MPU02_BUCK3,
+	S2MPU02_BUCK4,
+	S2MPU02_BUCK5,
+	S2MPU02_BUCK6,
+	S2MPU02_BUCK7,
+
+	S2MPU02_REGULATOR_MAX,
+};
+
+/* Regulator constraints for BUCKx */
+#define S2MPU02_BUCK1234_MIN_600MV	600000
+#define S2MPU02_BUCK5_MIN_1081_25MV	1081250
+#define S2MPU02_BUCK6_MIN_1700MV	1700000
+#define S2MPU02_BUCK7_MIN_900MV		900000
+
+#define S2MPU02_BUCK1234_STEP_6_25MV	6250
+#define S2MPU02_BUCK5_STEP_6_25MV	6250
+#define S2MPU02_BUCK6_STEP_2_50MV	2500
+#define S2MPU02_BUCK7_STEP_6_25MV	6250
+
+#define S2MPU02_BUCK1234_START_SEL	0x00
+#define S2MPU02_BUCK5_START_SEL		0x4D
+#define S2MPU02_BUCK6_START_SEL		0x28
+#define S2MPU02_BUCK7_START_SEL		0x30
+
+#define S2MPU02_BUCK_RAMP_DELAY		12500
+
+/* Regulator constraints for different types of LDOx */
+#define S2MPU02_LDO_MIN_900MV		900000
+#define S2MPU02_LDO_MIN_1050MV		1050000
+#define S2MPU02_LDO_MIN_1600MV		1600000
+#define S2MPU02_LDO_STEP_12_5MV		12500
+#define S2MPU02_LDO_STEP_25MV		25000
+#define S2MPU02_LDO_STEP_50MV		50000
+
+#define S2MPU02_LDO_GROUP1_START_SEL	0x8
+#define S2MPU02_LDO_GROUP2_START_SEL	0xA
+#define S2MPU02_LDO_GROUP3_START_SEL	0x10
+
+#define S2MPU02_LDO_VSEL_MASK		0x3F
+#define S2MPU02_BUCK_VSEL_MASK		0xFF
+#define S2MPU02_ENABLE_MASK		(0x03 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_ENABLE_SHIFT		6
+
+/* On/Off controlled by PWREN */
+#define S2MPU02_ENABLE_SUSPEND		(0x01 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_DISABLE_SUSPEND		(0x11 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_LDO_N_VOLTAGES		(S2MPU02_LDO_VSEL_MASK + 1)
+#define S2MPU02_BUCK_N_VOLTAGES		(S2MPU02_BUCK_VSEL_MASK + 1)
+
+/* RAMP delay for BUCK1234*/
+#define S2MPU02_BUCK1_RAMP_SHIFT	6
+#define S2MPU02_BUCK2_RAMP_SHIFT	4
+#define S2MPU02_BUCK3_RAMP_SHIFT	2
+#define S2MPU02_BUCK4_RAMP_SHIFT	0
+#define S2MPU02_BUCK1234_RAMP_MASK	0x3
+
+#endif /*  __LINUX_MFD_S2MPU02_H */
-- 
1.8.0

