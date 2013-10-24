Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3JXJTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:19:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20009 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3JXJTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:19:19 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-58-5268e616f457
From: "hyunhee.kim" <hyunhee.kim@samsung.com>
To: "'Oliver Neukum'" <oneukum@suse.de>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        broonie@opensource.wolfsonmicro.com, peter.ujfalusi@ti.com,
        wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kyungmin.park@samsung.com,
        "'Aristeu Sergio Rozanski Filho'" <aris@ruivo.org>
References: <000a01cec629$3cf34de0$b6d9e9a0$%kim@samsung.com>
 <20131021155558.GA4255@core.coreip.homeip.net>
 <025101ced083$35f2a270$a1d7e750$%kim@samsung.com>
 <1382603886.1559.11.camel@linux-fkkt.site>
In-reply-to: <1382603886.1559.11.camel@linux-fkkt.site>
Subject: [PATCH v3] Input: add regulator haptic driver
Date: Thu, 24 Oct 2013 18:19:17 +0900
Message-id: <028301ced09a$1d5fed50$581fc7f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7QlGzVSRYl8tohR/yeQB2ZNfsEyAABSsxg
Content-language: ko
X-OriginalArrivalTime: 24 Oct 2013 09:19:17.0192 (UTC)
 FILETIME=[1D172480:01CED09A]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zPV2xZxlBBpeesFvc/PSN1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVM+/qHvWCZRUXP8Q+sDYzz9bsYOTkkBEwkNi+ZxgRh
	i0lcuLeeDcQWEljGKHF/ow1MTf+Le+xdjFxA8UWMEps+bWaDcOYxSfQ/72KEcFYwSlzccogd
	pIVNQFfi+O+/jCC2iICqxK9HN5lAipgF1jBJNK9fzwTRcZ5RYu3b6WDLOQXMJe6tvccKYgsL
	mEmsO9EHNokFqHvrvOssXYwcHLwCthJd+yJAwrwCghI/Jt9jAbGZBdQlJs1bxAxha0s8eXeB
	FaRcAij+6K8uxA1GEt9eLYMqF5HY9+IdI8SbahIfnn5kgXgzVOLnmu8sIKdJCFxil7jw9Qor
	xAkCEt8mH2KBmCkrsekAM0S9pMTBFTdYJjBKz0Jy0SwkF81CctEsJKsXMLKsYhRNLUguKE5K
	LzLRK07MLS7NS9dLzs/dxAiJ1wk7GO8dsD7EmAy0fiKzlGhyPjDe80riDY3NjCxMTUyNjcwt
	zUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0WR1qk6F+4Otz54fz3dLedjP
	WD35qL8dq96nPZ++9yxw6D9UutPxPo9jfrnF1LnPHcwmfbnuYZKiUPOuSInLNP6ux5pN0rU7
	VVQLAvZsq3wYHsBiorTV1GP1z3IRr9RXCjySew48OeX+6Nv+fcyTbIrOelzbXZf3/Y7cxeVX
	GHfbnOVKfXM+QImlOCPRUIu5qDgRAG+/kvHtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAV2xZxlBBpP2M1vc/PSN1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTPv6h71gmUVF
	z/EPrA2M8/W7GDk5JARMJPpf3GOHsMUkLtxbz9bFyMUhJLCIUWLTp81Qzjwmif7nXYwQzgpG
	iYtbDoG1sAnoShz//ZcRxBYRUJX49egmE0gRs8AaJonm9euZIDrOM0qsfTudCaSKU8Bc4t7a
	e6wgtrCAmcS6E31gk1iAurfOu87SxcjBwStgK9G1LwIkzCsgKPFj8j0WEJtZQF1i0rxFzBC2
	tsSTdxdYQcolgOKP/upC3GAk8e3VMqhyEYl9L96B3SYkoCbx4elHFog3QyV+rvnOMoFRdBaS
	DbOQbJiFZMMsJKMWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOB8+kdzCuarA4xCjA
	wajEw6vxIT1IiDWxrLgy9xCjBAezkgivZ0VGkBBvSmJlVWpRfnxRaU5q8SHGZKD/JzJLiSbn
	A1NVXkm8obGJmZGlkZmxibmxMWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwOtTtDjwY
	maGQkSqnUR8ds02bMbRnUvfbotsC/q8rprR053875sdnH7LCwVH1ulNO2cHt3zQ1FR5xGezb
	4rtOPss8OfP2/p2HmWbd5GR8vtlM4fT19u+BUptO7dD6vyjLR+FJ68vVvXN/N66Y/VhOJLir
	9mvNXuuWtAlfPZWSRZi2mgbxBwcosRRnJBpqMRcVJwIA4f10z0sDAAA=
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
 drivers/input/misc/regulator-haptic.c |  184 +++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)
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
index 0000000..882c8b9
--- /dev/null
+++ b/drivers/input/misc/regulator-haptic.c
@@ -0,0 +1,184 @@
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
+static void regulator_haptic_toggle(struct regulator_haptic *haptic, bool enable)
+{
+	int ret;
+
+	mutex_lock(&haptic->mutex);
+	if (enable && !haptic->enabled) {
+		haptic->enabled = true;
+		ret = regulator_enable(haptic->regulator);
+		if (ret)
+			dev_err(haptic->dev, "failed to enable regulator\n");
+	} else if (!enable && haptic->enabled) {
+		haptic->enabled = false;
+		ret = regulator_disable(haptic->regulator);
+		if (ret)
+			dev_err(haptic->dev, "failed to disable regulator\n");
+	}
+	mutex_unlock(&haptic->mutex);
+}
+
+static void regulator_haptic_work(struct work_struct *work)
+{
+	struct regulator_haptic *haptic = container_of(work,
+						       struct regulator_haptic,
+						       work);
+	if (haptic->level)
+		regulator_haptic_toggle(haptic, true);
+	else
+		regulator_haptic_toggle(haptic, false);
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
+	regulator_haptic_toggle(haptic, false);
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


