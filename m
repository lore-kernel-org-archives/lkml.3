Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbaCQMoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:44:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56684 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184AbaCQMn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:43:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-ea-5326ee0a381e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 1/4] power_supply: of: Add an API to get power_supply
 device from dt node
Date: Mon, 17 Mar 2014 21:43:44 +0900
Message-id: <1395060227-23378-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkQJfrnVqwwcf5ChbXvzxntZj05D2z
	xcSVk5ktzja9Ybe4vGsOm8XtxhVsDmweO2fdZffYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDKWLfnDUnBIu+LI59VsDYy/lbsYOTkkBEwkGmZNZYawxSQu3FvP1sXIxSEksJRR4uzJ
	NkaYorfzbjFBJKYzSvy8/poVwmlkklg0bzcbSBWbgJbE/hc3wGwRAV2Jmz2X2UFsZoFaiX3X
	mlhBbGGBeImbXW1gNouAqsTW7V/BangFXCXOrJnFBrFNTuLDnkdgcU4BN4nLO6eBnScEVLP6
	6WJ2kMUSAt3sEotPtzFBDBKQ+Db5EEsXIwdQQlZi0wGodyQlDq64wTKBUXgBI8MqRtHUguSC
	4qT0IhO94sTc4tK8dL3k/NxNjMCQPv3v2YQdjPcOWB9iTAYaN5FZSjQ5HxgTeSXxhsZmRham
	JqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOLnmiXSdjk/rhUgB
	YVmbtlN7M7On3BD/67Zzyvuyp3tnzT2isaft8Nx4n5KP4Y0+VeXSd+w2qxxj5Xt2MrWHR3v9
	ssCPja+nZ1YHvvSVj1cUPW3MvnjW3VSFRcZ8entPeNUEMex58HjHERm2RdmlbJ5Oj+cpcv0T
	sQ7qkElddcf+e7zLW4fJSizFGYmGWsxFxYkAIbh2kH8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQV2ud2rBBvtmi1tc//Kc1WLSk/fM
	FhNXTma2ONv0ht3i8q45bBa3G1ewObB57Jx1l91j8wotj74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWLbkD0vBIe2KI59XszUw/lbuYuTkkBAwkXg7
	7xYThC0mceHeerYuRi4OIYHpjBI/r79mhXAamSQWzdvNBlLFJqAlsf/FDTBbREBX4mbPZXYQ
	m1mgVmLftSZWEFtYIF7iZlcbmM0ioCqxdftXsBpeAVeJM2tmsUFsk5P4sOcRWJxTwE3i8s5p
	zCC2EFDN6qeL2Scw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwxz6R2MK5ssDjE
	KMDBqMTDO0FZLViINbGsuDL3EKMEB7OSCK/WW6AQb0piZVVqUX58UWlOavEhxmSgqyYyS4km
	5wOjOa8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGEtiFqZW
	p5SW7T2yse+X48Xt39atu/Nf78/GpsdrBEWeXFj8+PBbqYv7NfLXlS/MqpSrbrKaqrvMYUOt
	+CHVDtHtXRcWzKrZmy/3mrE25/nn1W7/OysnvPKdHPK1dkrg87p7Qt0rAyOmFExQf6o46Wnj
	7WzN9ucWKkdTFgRHNB84eK5Fh/nZWT0lluKMREMt5qLiRAB4q2m93AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an API of_power_supply_get_dev() to be used by drivers to
get power_supply device in the case of DT(DeviceTree) node
(this can be used instead of power_supply_get_by_name()).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/power/Kconfig                 |  4 ++
 drivers/power/Makefile                |  2 +
 drivers/power/of_power_supply.c       | 82 +++++++++++++++++++++++++++++++++++
 include/linux/power/of_power_supply.h | 46 ++++++++++++++++++++
 4 files changed, 134 insertions(+)
 create mode 100644 drivers/power/of_power_supply.c
 create mode 100644 include/linux/power/of_power_supply.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index ba69751..02240aa 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -8,6 +8,10 @@ menuconfig POWER_SUPPLY
 
 if POWER_SUPPLY
 
+config OF_POWER_SUPPLY
+	def_tristate y
+	depends on OF
+
 config POWER_SUPPLY_DEBUG
 	bool "Power supply debug"
 	help
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee54a3e..27d0c9c 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -4,6 +4,8 @@ power_supply-y				:= power_supply_core.o
 power_supply-$(CONFIG_SYSFS)		+= power_supply_sysfs.o
 power_supply-$(CONFIG_LEDS_TRIGGERS)	+= power_supply_leds.o
 
+obj-$(CONFIG_OF_POWER_SUPPLY)	+= of_power_supply.o
+
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
 
diff --git a/drivers/power/of_power_supply.c b/drivers/power/of_power_supply.c
new file mode 100644
index 0000000..25d93a1
--- /dev/null
+++ b/drivers/power/of_power_supply.c
@@ -0,0 +1,82 @@
+/*
+ * OF helpers for Power supply class
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/power_supply.h>
+#include <linux/power/of_power_supply.h>
+
+/*
+ * of_power_supply_get_dev - Get the power_supply device from devicetree
+ * @dev - instance to the given device
+ * @index - index into list of power_supply
+ *
+ * return the instance of power_supply device
+ */
+struct power_supply *of_power_supply_get_dev(struct device *dev,
+					     enum power_supply_dev_type type,
+					     int index)
+{
+	struct power_supply *power_supply_dev;
+	struct device_node *node;
+	const char *name;
+	union __parent_dev {
+		struct platform_device *platform;
+		struct i2c_client *i2c;
+	} parent_dev;
+
+	if (!dev->of_node) {
+		dev_dbg(dev, "device does not have a device node entry\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (type >= POWER_SUPPLY_DEV_END || type <= POWER_SUPPLY_DEV_UNKNOWN) {
+		dev_dbg(dev, "unknown power_supply device : %d\n", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	node = of_parse_phandle(dev->of_node, power_supply_dev_list[type],
+				index);
+	if (!node) {
+		dev_dbg(dev, "failed to get phandle in %s node\n",
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	parent_dev.platform = of_find_device_by_node(node);
+	if (parent_dev.platform) {
+		name = dev_name(&parent_dev.platform->dev);
+		goto success;
+	}
+
+	parent_dev.i2c = of_find_i2c_device_by_node(node);
+	if (parent_dev.i2c) {
+		name = parent_dev.i2c->name;
+		goto success;
+	}
+
+	return ERR_PTR(-ENODEV);
+
+success:
+	power_supply_dev = power_supply_get_by_name(name);
+	if (!power_supply_dev) {
+		dev_dbg(dev, "unable to get power supply device : %s\n", name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return power_supply_dev;
+}
+EXPORT_SYMBOL_GPL(of_power_supply_get_dev);
diff --git a/include/linux/power/of_power_supply.h b/include/linux/power/of_power_supply.h
new file mode 100644
index 0000000..cfd4874
--- /dev/null
+++ b/include/linux/power/of_power_supply.h
@@ -0,0 +1,46 @@
+/*
+ * OF helpers for Power supply class
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_OF_POWER_SUPPLY_H
+#define __LINUX_OF_POWER_SUPPLY_H
+
+#include <linux/err.h>
+
+enum power_supply_dev_type {
+	POWER_SUPPLY_DEV_UNKNOWN = 0,
+	POWER_SUPPLY_DEV_FUELGAUGE,
+	POWER_SUPPLY_DEV_CHARGER,
+
+	POWER_SUPPLY_DEV_END,
+};
+
+static const char * const power_supply_dev_list[] = {
+	[POWER_SUPPLY_DEV_UNKNOWN]	= "unknown",
+	[POWER_SUPPLY_DEV_FUELGAUGE]	= "fuelgauge",
+	[POWER_SUPPLY_DEV_CHARGER]	= "charger",
+};
+
+#if IS_ENABLED(CONFIG_OF_POWER_SUPPLY)
+extern struct power_supply
+	*of_power_supply_get_dev(struct device *dev,
+				 enum power_supply_dev_type type,
+				 int index);
+#else
+static inline struct power_supply
+	*of_power_supply_get_dev(struct device *dev,
+				 enum power_supply_dev_type type,
+				 int index)
+{
+	return ERR_PTR(-ENOSYS);
+}
+#endif /* CONFIG_OF_POWER_SUPPLY */
+#endif /* __LINUX_OF_POWER_SUPPLY_H */
-- 
1.8.0

