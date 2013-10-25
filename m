Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab3JYGaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 02:30:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45118 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3JYGaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 02:30:03 -0400
X-AuditID: cbfee68f-b7f836d000001b39-74-526a0fe08d29
From: Hyunhee Kim <hyunhee.kim@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>, dmitry.torokhov@gmail.com,
        peter.ujfalusi@ti.com, wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "'hyunhee.kim'" <hyunhee.kim@samsung.com>, kyungmin.park@samsung.com
References: <000101cec628$aaff69a0$00fe3ce0$%kim@samsung.com>
 <20131024133836.GG18506@sirena.org.uk>
In-reply-to: <20131024133836.GG18506@sirena.org.uk>
Subject: [PATCH v4] Input: add regulator haptic driver
Date: Fri, 25 Oct 2013 15:29:51 +0900
Message-id: <002601ced14b$9c412330$d4c36990$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Qvlw64/SeWoMjRSaGc8cuAMRLKAAjF/xg
Content-language: ko
X-OriginalArrivalTime: 25 Oct 2013 06:29:51.0456 (UTC)
 FILETIME=[9C40AE00:01CED14B]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zPd0H/FlBBreWcFnc/PSN1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW0nPQq2GteMe3sScYGxm16XYycHBICJhLr3t1jhLDF
	JC7cW8/WxcjFISSwjFHiRcMP9i5GDrCi+ZO4QGqEBKYzSnxapQZRM49Jou/LRiYIZwWjxJJF
	N9lAqtgEtCVm/HjBCJIQETjKKLFlxRtWkEnMAh4SR+8nQ0xKk2j7ORNsAaeAscSkT5EgYWEB
	M4lFZ7eyg9gsAqoSnds6wGxeAVuJZ4eWs0DYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZ4mZ1
	iUd/dUHCIgJGEhseLmeHKBGR2PfiHSPEBWoSH55+ZIH4PVTi76mfLCAXSwicYpc4uWk1C8QN
	AhLfJh9igZgpK7HpADNEvaTEwRU3WCYwSs9CctEsJBfNQnLRLCSrFzCyrGIUTS1ILihOSi8y
	1itOzC0uzUvXS87P3cQIidP+HYx3D1gfYkwGWj+RWUo0OR8Y53kl8YbGZkYWpiamxkbmlmak
	CSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVHGx1syX+aOXp/UloOx0a4P7h/c
	vvXaC66IcEuFh26npc9lKdxcsiVbzrAvdZ/Oni8sjifOFpW1n8/ax5ggUPh1TexVhp/bLhVy
	/b+70P6T9kSGfimJdb9WNv59ePHqTctfr/cHzZ6j9vr2tN/23bHTl745rsQmepOj3VGLoT9f
	9sXSKWGsHBuVWIozEg21mIuKEwEh5RqG6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd0H/FlBBkd/sVrc/PSN1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmtJz0KthrXjHt
	7EnGBsZtel2MHBwSAiYS8ydxdTFyApliEhfurWcDsYUEpjNKfFql1sXIBWTPY5Lo+7KRCcJZ
	wSixZNFNsCo2AW2JGT9eMIIkRASOMkpsWfGGFWQqs4CHxNH7yRCT0iTafs5kBwlzChhLTPoU
	CRIWFjCTWHR2KzuIzSKgKtG5rQPM5hWwlXh2aDkLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVv
	mSHuV5d49FcXJCwiYCSx4eFydogSEYl9L94xQlygJvHh6UcWiB9DJf6e+skygVF0FpINs5Bs
	mIVkwywkoxYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Cz6R2MK5ssDjEKMDBqMTD
	mzAjM0iINbGsuDL3EKMEB7OSCG/NaaAQb0piZVVqUX58UWlOavEhxmRgAExklhJNzgcmqLyS
	eENjEzMjSyMzYxNzY2PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFw/y3/rqXPz6znT
	l1qkmykx/PstmnWSeXJ0RU8hl3BSYXvFbpdF3n/XdSuLbrLeFbGkavfN0zkbU4WV/X1vpt36
	+0fil0D+u45q/wVLxU8qR3ewXMtvXDVJR8t0RmKgclfjoq7ZzHGrO+WuTkgOFAk63DL9irBb
	s/+Uf9e+cRibrgmdFdzppsRSnJFoqMVcVJwIABtvLvFGAwAA
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
 drivers/input/misc/regulator-haptic.c |  187
+++++++++++++++++++++++++++++++++
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
+			dev_err(haptic->dev, "failed to enable
regulator\n");
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
+			dev_err(haptic->dev, "failed to disable
regulator\n");
+		haptic->enabled = false;
+	}
+}
+
+static void regulator_haptic_work(struct work_struct *work)
+{
+	struct regulator_haptic *haptic = container_of(work,
+						       struct
regulator_haptic,
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
+		dev_err(&pdev->dev, "unable to allocate memory for
haptic\n");
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


