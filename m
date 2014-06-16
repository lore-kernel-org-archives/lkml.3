Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaFPEm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:42:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48519 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaFPEmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:42:53 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-b3-539e75c1f652
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com
Cc: k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 1/3] mfd: sec-core: Add support for S2MPU02 device
Date: Mon, 16 Jun 2014 13:42:35 +0900
Message-id: <1402893757-18957-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
References: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkQPdg6bxgg5kd8hbXvzxntXj9wtDi
	bNMbdov7X48yWlzeNYfN4nbjCjaL092sFhdXfGFy4PC4c20Pm8e8k4EefVtWMXp83iQXwBLF
	ZZOSmpNZllqkb5fAlbG9+y1TwWz9itXfr7I2ME5Q62Lk5JAQMJE4fGMnM4QtJnHh3nq2LkYu
	DiGBpYwSl05/Z4UpmrL8NlRiEaPExDWHoJwmJonXpzcxglSxCWhJ7H9xgw3EFhFwkVjS/Q6s
	iFlgBqPEyVUrmUASwiCJ1lYWEJtFQFVi0vTDQDYHB6+Aq8SB4wYQ2+QkPux5xA5icwq4Sfzt
	2wbWKgRUcutyFwvITAmByewST3dchZojIPFt8iGwORICshKbDkC9IylxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBIb46X/Pencw3j5gfYgxGWjcRGYp0eR8YIzklcQb
	GpsZWZiamBobmVuakSasJM6b9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjXsG7DtLb
	LzacjF9tHfad5ebHd48DXCVikvhWHuYQNgi5XXzzPPfJ7TkfVLO0VObNvfvI8Vvn5Fdbzvrs
	uPF45tXy+JeHg69M2nPPOHDaoXNCvup3arYvCjzpyLZqpoSGWYqvdmzh4/fHuAXkkkXStvSu
	e9i6MuT/+4MvrKTKj+4UXjrbhTGmXImlOCPRUIu5qDgRANZYFfiHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd2DpfOCDc5dkrC4/uU5q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFrcbV7BZnO5mtbi44guTA4fHnWt72DzmnQz06NuyitHj8ya5AJao
	BkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAjlBTK
	EnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ27vfMhXM1q9Y/f0qawPjBLUu
	Rk4OCQETiSnLb7NB2GISF+6tB7K5OIQEFjFKTFxzCMppYpJ4fXoTI0gVm4CWxP4XN8A6RARc
	JJZ0vwMrYhaYwShxctVKJpCEMEiitZUFxGYRUJWYNP0wkM3BwSvgKnHguAHENjmJD3sesYPY
	nAJuEn/7toG1CgGV3LrcxTKBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAIeia9
	g3FVg8UhRgEORiUe3gmO84KFWBPLiitzDzFKcDArifDa+wCFeFMSK6tSi/Lji0pzUosPMSYD
	HTWRWUo0OR8Y3Xkl8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wCi4LWpaksDTZNGNT1KVTvdVX251Xve2tKF5esS3jMlvWzsyHtnO0W1s6H5onncnV3CfiPfH
	96o/xLZtnG6q4Kqx88ErWZYlIjGn5+it3q07y1fRODa+YdnBmOVHpLZZySzcznfx8bPdjtKf
	k5r35X2ftPfjvkWV/x7/k8tn+7jX4tTiLBOmgPtKLMUZiYZazEXFiQCvCE5/5AIAAA==
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
 drivers/mfd/sec-core.c           | 19 +++++++++
 drivers/mfd/sec-irq.c            | 88 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/samsung/core.h |  1 +
 include/linux/mfd/samsung/irq.h  | 24 +++++++++++
 4 files changed, 132 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index be06d0a..5e8784b 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -89,6 +89,17 @@ static const struct mfd_cell s2mpa01_devs[] = {
 	},
 };
 
+static const struct mfd_cell s2mpu02_devs[] = {
+	{
+		.name = "s2mpu02-pmic",
+	}, {
+		.name = "s2mpu02-rtc",
+	}, {
+		.name = "s2mpu02-clk",
+		.of_compatible = "samsung,s2mpu02-clk",
+	}
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
@@ -103,6 +114,9 @@ static const struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mpa01-pmic",
 		.data = (void *)S2MPA01,
 	}, {
+		.compatible = "samsung,s2mpu02-pmic",
+		.data = (void *)S2MPU02,
+	}, {
 		/* Sentinel */
 	},
 };
@@ -342,6 +356,11 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
 				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
 		break;
+	case S2MPU02:
+		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpu02_devs,
+				      ARRAY_SIZE(s2mpu02_devs), NULL, 0, NULL);
+		break;
+
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 654e2c1..0cabd03 100644
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
@@ -384,6 +466,12 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 				  sec_pmic->irq_base, &s2mps14_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
+	case S2MPU02:
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
+				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				  sec_pmic->irq_base, &s2mpu02_irq_chip,
+				  &sec_pmic->irq_data);
+		break;
 	default:
 		dev_err(sec_pmic->dev, "Unknown device type %lu\n",
 			sec_pmic->device_type);
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
 
-- 
1.8.0

