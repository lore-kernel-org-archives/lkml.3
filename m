Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3J1Ib1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:31:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3J1IbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:31:24 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-26-526e20db0c30
From: Hyunhee Kim <hyunhee.kim@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>, dmitry.torokhov@gmail.com,
        peter.ujfalusi@ti.com, wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kyungmin.park@samsung.com
References: <000101cec628$aaff69a0$00fe3ce0$%kim@samsung.com>
 <20131024133836.GG18506@sirena.org.uk>
 <002601ced14b$9c412330$d4c36990$%kim@samsung.com>
 <20131025082944.GK18506@sirena.org.uk>
In-reply-to: <20131025082944.GK18506@sirena.org.uk>
Subject: [PATCH v5] Input: add regulator haptic driver
Date: Mon, 28 Oct 2013 17:31:22 +0900
Message-id: <000901ced3b8$153bb200$3fb31600$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7RXGfcDoWjkhraSxC0LoTtqxomuQCWsbWA
Content-language: ko
X-OriginalArrivalTime: 28 Oct 2013 08:31:22.0141 (UTC)
 FILETIME=[15142CD0:01CED3B8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+Zru5thbwgg5ZXbBY3P31jtbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlnFzoXbDGvmHb2JGMD4za9LkZODgkBE4muLz/YIGwx
	iQv31gPZXBxCAssYJR6fvMUMU9R69DwjiC0kMJ1R4tlBGYiieUwSc/fOYIFwVjBKPHp9lB2k
	ik1AW2LGjxeMIAkRgUeMEi9fzGaGqDrMKHGu/xzQEg4OTgFjia4fSSANwgJmEn/uvWEGCbMI
	qEoc64sCCfMK2EqcnbiRCSQsIaAu8eivLkhYRMBIYsP/H2DHMQuISOx78Q7qODWJD08/skAc
	HSpxY/lUJpCtEgLT2SWWrH7DBJJgERCQ+Db5EAvETFmJTQegnpSUOLjiBssERvFZSMYuYGRc
	xSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRESAxN2MN47YH2IMRlo9ERmKdHkfGAM5ZXEGxqb
	GVmYmpgaG5lbmpEmrCTOq/YoKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9MKuRlZa2R3
	h767xyXnoymxOb/PeKHi1+8iWzhM6jKdPctZvfc7GbvfaWu9rpQsnq0mdDzwlLvlnisrnj3R
	3rr/3BnPn03frN4GP3uh0fd7/67Tx2ujYpmXFut5HdrWvjH11oaezmU3lbT4mrPdvs684Gx8
	1Mf0rmf77ZvMbt0bb1r2HZ72UImlOCPRUIu5qDgRAGBLDL+XAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQd3bCnlBBp92MFnc/PSN1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmnF3oXLDFvGLa
	2ZOMDYzb9LoYOTkkBEwkWo+eZ4SwxSQu3FvPBmILCUxnlHh2UKaLkQvInsckMXfvDBYIZwWj
	xKPXR9lBqtgEtCVm/HjBCJIQEXjEKPHyxWxmiKrDjBLn+s8BzeLg4BQwluj6kQTSICxgJvHn
	3htmkDCLgKrEsb4okDCvgK3E2YkbmUDCEgLqEo/+6oKERQSMJDb8/8EMYjMLiEjse/GOEeI4
	NYkPTz+yQBwdKnFj+VSmCYyCs5CULWBkXMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHGHP
	pHYwrmywOMQowMGoxMO7YW1ukBBrYllxZe4hRgkOZiUR3r5bQCHelMTKqtSi/Pii0pzU4kOM
	yUB3T2SWEk3OB0Z/Xkm8obGJmZGlkZmxibmxMWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUw7uUvMH39wHfaWhs5hZ5Is6VzT25NVVn4tvTOLbNJXQ7MP/eFczu8PKQw+ef+F9LTX16P
	4t6ymS/51UHB7cc+L6lScr6/ZEVV1IqrlcHnF3vbmWS/3Sj69a7ZYfU389oCYizVHvMw1J5c
	svXxptqtfwIzlznM2/STd/saybkTJ/h8XdsmocziUaHEUpyRaKjFXFScCABvwGHu9AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyunhee Kim <hyunhee.kim@samsung.com>
Date: Wed, 9 Oct 2013 16:21:36 +0900
Subject: [PATCH] Input: add regulator haptic driver

Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Aristeu Rozanski <aris@ruivo.org>
---
 drivers/input/misc/Kconfig            |   10 ++
 drivers/input/misc/Makefile           |    1 +
 drivers/input/misc/regulator-haptic.c |  187 +++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+)
 create mode 100644 drivers/input/misc/regulator-haptic.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index bb698e1..21b4d5b 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -82,6 +82,16 @@ config INPUT_ARIZONA_HAPTICS
 	  To compile this driver as a module, choose M here: the
 	  module will be called arizona-haptics.

+config INPUT_REGULATOR_HAPTIC
+	tristate "support haptics on/off using regulator"
+	select INPUT_FF_MEMLESS
+	help
+	  Say Y to enable support for the haptic module. Haptic can be
+	  enabled/disabled by regulator.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called regulator-haptic.
+
 config INPUT_BMA150
 	tristate "BMA150/SMB380 acceleration sensor support"
 	depends on I2C
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index d7fc17f..106f0bc 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_INPUT_ADXL34X_I2C)		+= adxl34x-i2c.o
 obj-$(CONFIG_INPUT_ADXL34X_SPI)		+= adxl34x-spi.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_ARIZONA_HAPTICS)	+= arizona-haptics.o
+obj-$(CONFIG_INPUT_REGULATOR_HAPTIC)	+= regulator-haptic.o
 obj-$(CONFIG_INPUT_ATI_REMOTE2)		+= ati_remote2.o
 obj-$(CONFIG_INPUT_ATLAS_BTNS)		+= atlas_btns.o
 obj-$(CONFIG_INPUT_BFIN_ROTARY)		+= bfin_rotary.o
diff --git a/drivers/input/misc/regulator-haptic.c b/drivers/input/misc/regulator-haptic.c
new file mode 100644
index 0000000..bab2ad9
--- /dev/null
+++ b/drivers/input/misc/regulator-haptic.c
@@ -0,0 +1,187 @@
+/*
+ * Regulator haptic driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/regulator/driver.h>
+
+struct regulator_haptic {
+	struct device *dev;
+	struct input_dev *input_dev;
+	struct work_struct work;
+	bool enabled;
+	struct regulator *regulator;
+	struct mutex mutex;
+	int level;
+};
+
+static void regulator_haptic_enable(struct regulator_haptic *haptic)
+{
+	int ret;
+
+	if (!haptic->enabled) {
+		ret = regulator_enable(haptic->regulator);
+		if (ret)
+			dev_err(haptic->dev, "failed to enable regulator\n");
+		haptic->enabled = true;
+	}
+}
+
+static void regulator_haptic_disable(struct regulator_haptic *haptic)
+{
+	int ret;
+
+	if (haptic->enabled) {
+		ret = regulator_disable(haptic->regulator);
+		if (ret)
+			dev_err(haptic->dev, "failed to disable regulator\n");
+		haptic->enabled = false;
+	}
+}
+
+static void regulator_haptic_work(struct work_struct *work)
+{
+	struct regulator_haptic *haptic = container_of(work,
+						       struct regulator_haptic,
+						       work);
+	mutex_lock(&haptic->mutex);
+	if (haptic->level)
+		regulator_haptic_enable(haptic);
+	else
+		regulator_haptic_disable(haptic);
+	mutex_unlock(&haptic->mutex);
+}
+
+static int regulator_haptic_play(struct input_dev *input, void *data,
+				struct ff_effect *effect)
+{
+	struct regulator_haptic *haptic = input_get_drvdata(input);
+
+	haptic->level = effect->u.rumble.strong_magnitude;
+	if (!haptic->level)
+		haptic->level = effect->u.rumble.weak_magnitude;
+	schedule_work(&haptic->work);
+
+	return 0;
+}
+
+static void regulator_haptic_close(struct input_dev *input)
+{
+	struct regulator_haptic *haptic = input_get_drvdata(input);
+
+	cancel_work_sync(&haptic->work);
+	regulator_haptic_disable(haptic);
+}
+
+static int regulator_haptic_probe(struct platform_device *pdev)
+{
+	struct regulator_haptic *haptic;
+	struct input_dev *input_dev;
+	int error;
+
+	haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
+	if (!haptic) {
+		dev_err(&pdev->dev, "unable to allocate memory for haptic\n");
+		return -ENOMEM;
+	}
+
+	input_dev = input_allocate_device();
+
+	if (!input_dev) {
+		dev_err(&pdev->dev, "unable to allocate memory\n");
+		return  -ENOMEM;
+	}
+
+	INIT_WORK(&haptic->work, regulator_haptic_work);
+	mutex_init(&haptic->mutex);
+	haptic->input_dev = input_dev;
+	haptic->dev = &pdev->dev;
+	haptic->regulator = regulator_get(&pdev->dev, "haptic");
+
+	if (IS_ERR(haptic->regulator)) {
+		error = PTR_ERR(haptic->regulator);
+		dev_err(&pdev->dev, "unable to get regulator, err: %d\n",
+			error);
+		goto err_ifree_mem;
+	}
+
+	haptic->input_dev->name = "regulator:haptic";
+	haptic->input_dev->dev.parent = &pdev->dev;
+	haptic->input_dev->close = regulator_haptic_close;
+	haptic->enabled = false;
+	input_set_drvdata(haptic->input_dev, haptic);
+	input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
+
+	error = input_ff_create_memless(input_dev, NULL,
+				      regulator_haptic_play);
+	if (error) {
+		dev_err(&pdev->dev,
+			"input_ff_create_memless() failed: %d\n",
+			error);
+		goto err_put_regulator;
+	}
+
+	error = input_register_device(haptic->input_dev);
+	if (error) {
+		dev_err(&pdev->dev,
+			"couldn't register input device: %d\n",
+			error);
+		goto err_destroy_ff;
+	}
+
+	platform_set_drvdata(pdev, haptic);
+
+	return 0;
+
+err_destroy_ff:
+	input_ff_destroy(haptic->input_dev);
+err_put_regulator:
+	regulator_put(haptic->regulator);
+err_ifree_mem:
+	input_free_device(haptic->input_dev);
+
+	return error;
+}
+
+static int regulator_haptic_remove(struct platform_device *pdev)
+{
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+
+	input_unregister_device(haptic->input_dev);
+	regulator_put(haptic->regulator);
+
+	return 0;
+}
+
+static struct of_device_id regulator_haptic_dt_match[] = {
+	{ .compatible = "linux,regulator-haptic" },
+	{},
+};
+
+static struct platform_driver regulator_haptic_driver = {
+	.driver		= {
+		.name	= "regulator-haptic",
+		.owner	= THIS_MODULE,
+		.of_match_table = regulator_haptic_dt_match,
+	},
+
+	.probe		= regulator_haptic_probe,
+	.remove		= regulator_haptic_remove,
+};
+module_platform_driver(regulator_haptic_driver);
+
+MODULE_ALIAS("platform:regulator-haptic");
+MODULE_DESCRIPTION("Regulator haptic driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hyunhee Kim <hyunhee.kim@samsung.com>");
--
1.7.9.5



