Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3JKC0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 22:26:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52695 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3JKC0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 22:26:07 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-a7-525761be106e
From: "hyunhee.kim" <hyunhee.kim@samsung.com>
To: dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        peter.ujfalusi@ti.com, wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "'hyunhee.kim'" <hyunhee.kim@samsung.com>, kyungmin.park@samsung.com
References: 
In-reply-to: 
Subject: [PATCH] Input: add regulator haptic driver
Date: Fri, 11 Oct 2013 11:26:05 +0900
Message-id: <000a01cec629$3cf34de0$b6d9e9a0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7GKKrI57bcuzTzQ/awZVOqlzVd0AAAHYlQ
Content-language: ko
X-OriginalArrivalTime: 11 Oct 2013 02:26:06.0030 (UTC)
 FILETIME=[3D0946E0:01CEC629]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zHd19ieFBBk9fyVjc/PSN1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVMaLnOWNBlXrHk4VyWBsZmvS5GTg4JAROJjbMus0PY
	YhIX7q1n62Lk4hASWMYo8atvNztM0eq3y6ASixglemZvY4Fw5jFJrP58mh3CWcEo8XJxMwtI
	C5uArsTx338ZQRIiAscZJWZv7gXq5+BgFvCQOHo/GcQUEuCWWN0cBFLOKcAjse5PJzOILSxg
	LLHk6UQwm0VAVeLazKlgV/AK2Er0fD/JAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aQ8RIC
	6hKP/uqChEUEjCQurdjBDFEiIrHvxTtGEFtIQE3iw9OPLBBPhkps2bEG7BUJgUvsEpMeTWeC
	uEFA4tvkQywQM2UlNh1ghqiXlDi44gbLBEbpWUgumoXkollILpqFZPUCRpZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGCHROmEH470D1ocYk4HWT2SWEk3OB0Z7Xkm8obGZkYWpiamxkbml
	GWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYl28JPqr3VondgUXXdpu4wRzh
	WUU8E3+/TDde/fSQ7+fFHEtFml5HMdw0X5yibFOv0bH6b6ybkE0HX9Lk3S2iqhllO/olvG5U
	G1qn5Yq+PpjJPu3BtGAfTrX08Lcqjj0PhaY/P1b1vWuBJ0eRWnNfzP1n4lZ/zI3uz/a7kBZ3
	drV3vwD3zlVKLMUZiYZazEXFiQDtq4w67AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd19ieFBBjP2S1jc/PSN1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTGi5zljQZV6x
	5OFclgbGZr0uRk4OCQETidVvl7FB2GISF+6tB7K5OIQEFjFK9MzexgLhzGOSWP35NDuEs4JR
	4uXiZhaQFjYBXYnjv/8ygiREBI4zSsze3AvUz8HBLOAhcfR+MogpJMAtsbo5CKScU4BHYt2f
	TmYQW1jAWGLJ04lgNouAqsS1mVPZQWxeAVuJnu8nWSBsQYkfk++B2cwCWhLrdx5ngrDlJTav
	ecsMMl5CQF3i0V9dkLCIgJHEpRU7mCFKRCT2vXjHCGILCahJfHj6kQXiyVCJLTvWsE9gFJ2F
	ZMMsJBtmIdkwC8moBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCU8Ez6R2MqxosDjEK
	cDAq8fBaMIQHCbEmlhVX5h5ilOBgVhLhtdcDCvGmJFZWpRblxxeV5qQWH2JMBgbARGYp0eR8
	YJrKK4k3NDYxM7I0MjM2MTc2Jk1YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGyY+u200U
	PaP/t6s/xWmxCIeVaAJ36OyoCXGXmLgm73VmMF/5015Izf/B4a/WiZXKx7Z9FL+zSDrH2bZQ
	vKKljIP518JPvJ+0N2W9ynj/ZkrG8Q0v+77cuOtttGbrraps2a3aKxTdFubzbMy72f7QWVFs
	y9HGhk+T9v6Q+qcwYcdZ5eyb7xY3KLEUZyQaajEXFScCABClwrxJAwAA
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


