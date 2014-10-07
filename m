Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaJGK7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:59:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57715 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJGK6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:58:50 -0400
X-AuditID: cbfee691-f79b86d000004a5a-a9-5433c768ad18
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        jenny.tc@intel.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: =?UTF-8?q?=5BPATCH=203/3=5D=20power=3A=20of=5Fbattery=3A=20Initial=20support=20for=20of-based=20battery=20specification=20driver=2E?=
Date: Tue, 07 Oct 2014 19:58:38 +0900
Message-id: <1412679518-21499-4-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkWDfjuHGIQf8JEYuDWzUtJj15z2wx
	ceVkZou1X3vYLTrPPmG2uLxrDpvF594jjBZ3Tx1lszi9u8SB02NC/ydGj52z7rJ7bF6h5bF4
	z0smj02rOtk8+rasYvRYsfo7u8fnTXIBHFFcNimpOZllqUX6dglcGTd/GhWcMai4MvUHYwPj
	BI0uRk4OCQETif+/9rNB2GISF+6tB7K5OIQEljJKNH3ZxA5TtKznPVRiOqNE65xdLCAJXgFB
	iR+T74HZzALqEpPmLWKGsEUk5s/7BhXXlli28DVYXEigjUni4kFjEJtNQEfi/76bYAtEBBQk
	Nvc+Y4Wo384oMfdTMsgyYYEJjBLz2v+DDWIRUJV4NXEVI8RiD4mjH38DNXAAXacgMWeSDUiY
	U8BTovF2OwvELg+JRQ/esoLMkRD4yC7xY9F8Jog5AhLfJh9igeiVldh0gBniSUmJgytusExg
	FJ+F5LVZSF6bheS1WUheW8DIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMKJP/3s2cQfj
	/QPWhxgFOBiVeHhXaBmHCLEmlhVX5h5iNAW6aCKzlGhyPjBt5JXEGxqbGVmYmpgaG5lbmimJ
	8+pI/wwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJjPL6n8pMJQ1DEvq3fPq95zlQt+lQb1
	3/DjsGrXNZnqpnalZKvfE3vhox6RXfME7kvpnzK9pvXYYP6ia+v7vl+T8W9f2PtBn+GCyE71
	T06rJohtWSvvZvpGbBYnX4/qYdH/jh/dQqd15W9zYGisMZi6RTvk5+HECOZ7Pl5T4zjaDi6I
	ien+o8RSnJFoqMVcVJwIAAd/8VXjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG7GceMQg5nHuC0ObtW0mPTkPbPF
	xJWTmS3Wfu1ht+g8+4TZ4vKuOWwWn3uPMFrcPXWUzeL07hIHTo8J/Z8YPXbOusvusXmFlsfi
	PS+ZPDat6mTz6NuyitFjxerv7B6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcy48O05a8Eig4rTDxeyNjA+U+9i5OSQEDCRWNbzng3CFpO4cG89kM3FISQwnVGi
	dc4uFpAEr4CgxI/J94BsDg5mAXmJI5eyQcLMAuoSk+YtYgaxhQTamCQuHjQGsdkEdCT+77vJ
	DmKLCChIbO59xgpRv51RYu6nZJD5wgITGCXmtf8Hm88ioCrxauIqRohdHhJHP/5mBdklAdQ8
	Z5INSJhTwFOi8XY7C8QuD4lFD96yTmAUmIXkulkI181Cct0CRuZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMHR/0x6B+OqBotDjAIcjEo8vCu0jEOEWBPLiitzDzFKcDArifBaHwMK8aYk
	VlalFuXHF5XmpBYfYjQFunsis5Rocj4wMeWVxBsam5gZWRqZG1oYGZsrifMebLUOFBJITyxJ
	zU5NLUgtgulj4uCUamCMt7ZTubjzHtO3vm0CwpYCzKenz5nTXdK8JNBv+Z75/zJCHyXXMx3a
	E5C5J4EpV7hzL1ti9bav5dy8IvHnVc8EnFblnbHugmiDc2fYzcK7foEPudhUlfY4XKqexsZ8
	WfFrGXdF7Y92jjjrc1nTE398PS7+alm229HJ03f9jfvvs8HnqF/8/3lKLMUZiYZazEXFiQBS
	6FGEFAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports battery specification through the generic interface of
power_supply subsystem. All data are parsed from device tree and it exactly
matches with power_supply_info's content.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 .../bindings/power_supply/of_battery.txt           |   34 +++++++
 drivers/power/Kconfig                              |    7 ++
 drivers/power/Makefile                             |    1 +
 drivers/power/of_battery.c                         |  100 ++++++++++++++++++++
 4 files changed, 142 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/of_battery.txt
 create mode 100644 drivers/power/of_battery.c

diff --git a/Documentation/devicetree/bindings/power_supply/of_battery.txt b/Documentation/devicetree/bindings/power_supply/of_battery.txt
new file mode 100644
index 0000000..5ccd2a1
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/of_battery.txt
@@ -0,0 +1,34 @@
+of_battery bindings
+~~~~~~~~~~~~~~~~~~~
+
+This documentation describes how to define data in device tree
+to use of_battery driver. All properties are just matched with
+power_supply_info's.
+
+Required properties :
+ - battery-name : battery's name for identifying.
+
+Optional properties :
+ - voltage_max : Maximum voltage of the battery (uV).
+ - voltage_min : Minimum voltage of the battery (uV).
+ - charge_full : Full capacity of the battery (uAh).
+ - charge_empty : Empty capacity of the battery (uAh).
+ - energy_full : Full capacity of the battery (uWh).
+ - energy_empty : Empty capacity of the battery (uWh).
+ - temperature_max : Maximum temperature for the battery (deci 'C)
+ - temperature_min : Minium temperature for the battery (deci 'C)
+
+Example:
+	battery {
+		main-battery {
+			battery-name = "battery";
+			voltage-max = <4350000>;
+			charge-full = <2500000>;
+			temperature_max = <600>;
+			temperature_min = <(-100)>;
+		};
+		backup-battery {
+			battery-name = "coin-battery";
+			voltage-max = <3000000>;
+		};
+	};
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 73cfcdf..c324ac6 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -36,6 +36,13 @@ config GENERIC_ADC_BATTERY
 	  Say Y here to enable support for the generic battery driver
 	  which uses IIO framework to read adc.
 
+config BATTERY_OF
+	tristate "Generic of-based battery specification driver"
+	depends on OF
+	help
+	  Say Y here to enable support for the of-based generic battery
+	  specification driver which gives static battery data.
+
 config MAX8925_POWER
 	tristate "MAX8925 battery charger support"
 	depends on MFD_MAX8925
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index dfa8942..38a83aa 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -6,6 +6,7 @@ power_supply-$(CONFIG_LEDS_TRIGGERS)	+= power_supply_leds.o
 
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
+obj-$(CONFIG_BATTERY_OF)	+= of_battery.o
 
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
diff --git a/drivers/power/of_battery.c b/drivers/power/of_battery.c
new file mode 100644
index 0000000..3c66765
--- /dev/null
+++ b/drivers/power/of_battery.c
@@ -0,0 +1,100 @@
+/*
+ * OF-based battery specification driver
+ *
+ * This driver supports generic interface to get static battery data.
+ *
+ * Copyright © 2014 Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/power_supply.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+
+static struct power_supply_info *of_get_battery_info(struct device_node *np)
+{
+	struct power_supply_info *info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	if (of_property_read_string(np, "battery-name", &info->name)) {
+		kfree(info);
+		return ERR_PTR(-EINVAL);
+	}
+
+	of_property_read_u32(np, "voltage_max", &info->voltage_max_design);
+	of_property_read_u32(np, "voltage_min", &info->voltage_min_design);
+	of_property_read_u32(np, "charge_full", &info->charge_full_design);
+	of_property_read_u32(np, "charge_empty", &info->charge_empty_design);
+	of_property_read_u32(np, "energy_full", &info->energy_full_design);
+	of_property_read_u32(np, "energy_empty", &info->energy_empty_design);
+	of_property_read_u32(np, "temperature_max", &info->temperature_max);
+	of_property_read_u32(np, "temperature_min", &info->temperature_min);
+
+	return info;
+}
+
+static int __init psy_of_battery_init(void)
+{
+	struct power_supply_info *info;
+	struct device_node *np, *child;
+	int ret;
+
+	np = of_find_node_by_name(NULL, "battery");
+	if (!np)
+		return -ENODEV;
+
+	for_each_child_of_node(np, child) {
+		info = of_get_battery_info(child);
+		if (IS_ERR(info)) {
+			pr_err("Failed to get battery information (%ld)\n",
+				PTR_ERR(info));
+			continue;
+		}
+		ret = psy_register_battery_info(info);
+		if (ret) {
+			pr_err("Failed to register battery information (%d)\n",
+				ret);
+			kfree(info);
+			continue;
+		}
+	}
+
+	return 0;
+}
+module_init(psy_of_battery_init);
+
+static void __exit psy_of_battery_exit(void)
+{
+	struct power_supply_info *info;
+	struct device_node *np, *child;
+	const char *name;
+
+	np = of_find_node_by_name(NULL, "battery");
+	if (!np)
+		return;
+
+	for_each_child_of_node(np, child) {
+		if (!of_property_read_string(np, "battery-name", &name))
+			continue;
+
+		info = psy_get_battery_info(name);
+		if (IS_ERR(info))
+			continue;
+
+		psy_unregister_battery_info(info);
+	}
+}
+module_exit(psy_of_battery_exit);
+
+MODULE_AUTHOR("Jonghwa Lee <jonhgwa3.lee@samsung.com>");
+MODULE_DESCRIPTION("of battery specification driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

