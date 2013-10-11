Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3JKCWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 22:22:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51915 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3JKCWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 22:22:04 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-4a-525760c9f1cb
From: "hyunhee.kim" <hyunhee.kim@samsung.com>
To: dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        peter.ujfalusi@ti.com, wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Input: add regulator haptic driver
Date: Fri, 11 Oct 2013 11:22:00 +0900
Message-id: <000101cec628$aaff69a0$00fe3ce0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7GKKrI57bcuzTzQ/awZVOqlzVd0A==
Content-language: ko
X-OriginalArrivalTime: 11 Oct 2013 02:22:01.0155 (UTC)
 FILETIME=[AB145130:01CEC628]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zPd1TCeFBBpuFLG5++sZqcXnXHDYH
	Jo/Pm+QCGKO4bFJSczLLUov07RK4Mia0XGcs6DKvWPJwLksDY7NeFyMnh4SAicTH3m8sELaY
	xIV769m6GLk4hASWMUrM+7aGCaZo59x3UIlFjBJ/2v4xQTjzmCS2rlwHlVnBKLHw8jSwWWwC
	uhLHf/9lBEmICBxnlJi9uZcNJCEsYCyx5OlEZhCbRUBVYua7z2A2r4CtxLm3HVC2oMSPyffA
	BjELaEms33mcCcKWl9i85i1QDQfQTeoSj/7qgoRFBPQkHvYthSoRkdj34h0jiC0koCbx4elH
	qN9CJebOXQt2qITAMnaJF5O+s0LcICDxbfIhFoiZshKbDjBD1EtKHFxxg2UCo8QsJBfNQnLR
	LCQXzUKyegEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkDibuIPx/gHrQ4zJQOsnMkuJ
	JucD4zSvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYyHnm2I2eb+yUojOL6yWE+pqSbzXdZ3n3azdPEdHe7ORd73X/C0/7bP6jh4JID7o4vUsQw2
	Pu7p25efUcx+WFYfd7FbQpn7T8T/isw7chUsi3R7/1hLmf3RSoiZNFv8w+5pClbXdA+4bMtV
	0Dvo3rWhZiqPftJhmQXuOVnXntoIKJ+8Fbh0tRJLcUaioRZzUXEiABTaIRnJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd2TCeFBBstfWFjc/PSN1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTGi5zljQZV6x
	5OFclgbGZr0uRk4OCQETiZ1z37FB2GISF+6tB7K5OIQEFjFK/Gn7xwThzGOS2LpyHVRmBaPE
	wsvTWEBa2AR0JY7//ssIkhAROM4oMXtzL9gsYQFjiSVPJzKD2CwCqhIz330Gs3kFbCXOve2A
	sgUlfky+BzaIWUBLYv3O40wQtrzE5jVvgWo4gG5Sl3j0VxckLCKgJ/GwbylUiYjEvhfvGEFs
	IQE1iQ9PP7JAvBAqMXfuWrYJjEKzkGyYhWTDLCQbZiEZtYCRZRWjaGpBckFxUnqukV5xYm5x
	aV66XnJ+7iZGcBw/k97BuKrB4hCjAAejEg+vBUN4kBBrYllxZe4hRgkOZiURXns9oBBvSmJl
	VWpRfnxRaU5q8SHGZGAATGSWEk3OB6aYvJJ4Q2MTMyNLIzNjE3NjY9KElcR5D7ZaBwoJpCeW
	pGanphakFsFsYeLglGpgXGShF7/Utrmtk/nPnsy7bYaXqlsD1hn9a/HhW3O9zq72te376Xyr
	iyadvN4Tpsw99dC2HLYz+gb75bxv3Jz/mnHjVo7g3NVHEif/PpF80ODOA/HC2c6zBPxFbSpz
	J9skbRF/EvhoxdaTu85k/jevPL9A3n/6irMKBwqncR3zLH5++FZOVrr2QiWW4oxEQy3mouJE
	ANSJyIUnAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyunhee Kim <hyunhee.kim@samsung.com>
Date: Wed, 9 Oct 2013 16:21:36 +0900
Subject: [PATCH] Input: add regulator haptic driver

The regulator haptic driver function can be used to control motor by on/off
regulator.
User can control the haptic driver by using force feedback framework.

Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/input/misc/Kconfig            |    6 ++
 drivers/input/misc/Makefile           |    1 +
 drivers/input/misc/regulator-haptic.c |  185
+++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 drivers/input/misc/regulator-haptic.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index bb698e1..f391cd7 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -82,6 +82,12 @@ config INPUT_ARIZONA_HAPTICS
 	  To compile this driver as a module, choose M here: the
 	  module will be called arizona-haptics.
 
+config INPUT_REGULATOR_HAPTIC
+	tristate "regulator haptics support"
+	select INPUT_FF_MEMLESS
+	help
+	  Say Y to enable support for the haptics module for regulator.
+
 config INPUT_BMA150
 	tristate "BMA150/SMB380 acceleration sensor support"
 	depends on I2C
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index d7fc17f..106f0bc 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_INPUT_ADXL34X_I2C)		+=
adxl34x-i2c.o
 obj-$(CONFIG_INPUT_ADXL34X_SPI)		+= adxl34x-spi.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_ARIZONA_HAPTICS)	+= arizona-haptics.o
+obj-$(CONFIG_INPUT_REGULATOR_HAPTIC)	+= regulator-haptic.o
 obj-$(CONFIG_INPUT_ATI_REMOTE2)		+= ati_remote2.o
 obj-$(CONFIG_INPUT_ATLAS_BTNS)		+= atlas_btns.o
 obj-$(CONFIG_INPUT_BFIN_ROTARY)		+= bfin_rotary.o
diff --git a/drivers/input/misc/regulator-haptic.c
b/drivers/input/misc/regulator-haptic.c
new file mode 100644
index 0000000..29f57ea
--- /dev/null
+++ b/drivers/input/misc/regulator-haptic.c
@@ -0,0 +1,185 @@
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
+static void regulator_haptic_enable(struct regulator_haptic *haptic, bool
enable)
+{
+	int ret;
+
+	mutex_lock(&haptic->mutex);
+	if (enable && !haptic->enabled) {
+		haptic->enabled = true;
+		ret = regulator_enable(haptic->regulator);
+		if (ret)
+			pr_err("haptic: %s failed to enable regulator\n",
+				__func__);
+	} else if (!enable && haptic->enabled) {
+		haptic->enabled = false;
+		ret = regulator_disable(haptic->regulator);
+		if (ret)
+			pr_err("haptic: %s failed to disable regulator\n",
+				__func__);
+	}
+	mutex_unlock(&haptic->mutex);
+}
+
+static void regulator_haptic_work(struct work_struct *work)
+{
+	struct regulator_haptic *haptic = container_of(work,
+						       struct
regulator_haptic,
+						       work);
+	if (haptic->level)
+		regulator_haptic_enable(haptic, true);
+	else
+		regulator_haptic_enable(haptic, false);
+
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
+	regulator_haptic_enable(haptic, false);
+}
+
+static int regulator_haptic_probe(struct platform_device *pdev)
+{
+	struct regulator_haptic *haptic;
+	struct input_dev *input_dev;
+	int error;
+
+	haptic = kzalloc(sizeof(*haptic), GFP_KERNEL);
+	if (!haptic) {
+		dev_err(&pdev->dev, "unable to allocate memory for
haptic\n");
+		return -ENOMEM;
+	}
+
+	input_dev = input_allocate_device();
+
+	if (!input_dev) {
+		dev_err(&pdev->dev, "unable to allocate memory\n");
+		error =  -ENOMEM;
+		goto err_kfree_mem;
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
+err_kfree_mem:
+	kfree(haptic);
+
+	return error;
+}
+
+static int regulator_haptic_remove(struct platform_device *pdev)
+{
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+
+	input_unregister_device(haptic->input_dev);
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


