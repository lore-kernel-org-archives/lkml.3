Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3BDMH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:07:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56562 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3BDMHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:07:23 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-20-510fa4790c13
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Abhilash Kesavan <a.kesavan@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v5 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver for
 Exynos5250
Date: Mon, 04 Feb 2013 17:44:48 +0530
Message-id: <1359980088-20799-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1358515490-7565-1-git-send-email-a.kesavan@samsung.com>
References: <1358515490-7565-1-git-send-email-a.kesavan@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkSrdyCX+gweK/mhaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsEroyNDRuZCibOYaz4fvMbcwNjYwNjFyMnh4SAicSFq29Z
	IWwxiQv31rN1MXJxCAksZZT4s+IEG0zR67YmZojEIkaJ60u3s0A4fUwSe9YdAKtiE9CTWPDv
	KzOILSIQJrFs/3L2LkYODmaBaolPHx1BTGGBEInpTyxAKlgEVCUu93SDLeYVcJVY+mIeE0iJ
	hICCxJxJNiBhTqDw9bW/wIYLCbhIzLl7kAlkq4TAfTaJpx0zWCHmCEh8m3yIBaJXVmLTAWaI
	kyUlDq64wTKBUXgBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjMBgPP3vmdQOxpUNFocY
	BTgYlXh4GX7xBQqxJpYVV+YeYpTgYFYS4S2azB8oxJuSWFmVWpQfX1Sak1p8iDEZaPlEZinR
	5HxgpOSVxBsam5ibGptaGhmZmZqSJqwkzst46kmAkEB6YklqdmpqQWoRzBYmDk6pBsbVq6el
	JoVcbGTpuq6sKCsp32Gm2uW6/Mm20HnMCZJH52VIXfshobL+fb2dt9Umu2Wlm+wF048pXFLK
	XvvVOTq8SqK1a7V2pm0T7+E/v/dPZ241+ihw59/Ck9dPrE8oXmn2XPHu+kNvXk3RKtn58Ufw
	Ih9niZQTfpGrV4k73Sy4E2QTq/ErfakSS3FGoqEWc1FxIgBvasliigIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAd3KJfyBBh/nyFpc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzNjZsZCqYOIex
	4vvNb8wNjI0NjF2MnBwSAiYSr9uamCFsMYkL99azdTFycQgJLGKUuL50OwuE08cksWfdATaQ
	KjYBPYkF/76CdYgIhEks27+cvYuRg4NZoFri00dHEFNYIERi+hMLkAoWAVWJyz3drCA2r4Cr
	xNIX85hASiQEFCTmTLIBCXMCha+v/QU2XEjARWLO3YNMExh5FzAyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIDvVnUjsYVzZYHGIU4GBU4uFl+MUXKMSaWFZcmXuIUYKDWUmEt2gyf6AQ
	b0piZVVqUX58UWlOavEhxmSgoyYyS4km5wPjMK8k3tDYxNzU2NTSxMLEzJI0YSVxXsZTTwKE
	BNITS1KzU1MLUotgtjBxcEo1MBrkyejKbJ1h/LA1Z/GGnl2v67V0G2JrOB1ey3erefWHs1yo
	7LrwLFD6iGgoN8++68dfLOnd/fW9Ll/l0knzhGMWumoVvZBv4d5slJLRMGfvYfm/3bGaK+qr
	TMWTzwXufie4u3/pNq28o9z6VqGsrrFfJKxd2V4LrsriVphWpOzextxdb2arxFKckWioxVxU
	nAgAlSyzY7kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5-bus device devfreq driver monitors PPMU counters and
adjusts operating frequencies and voltages with OPP. ASV should
be used to provide appropriate voltages as per the speed group
of the SoC rather than using a constant 1.025V.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
Changes since RFC v1:
* Moved the Exynos5 PPMU driver to machine specific directory
* Migrated to the PM QOS framework
Changes since v2:
* Moved the PPMU driver to drivers/devfreq/exynos
* Fixed whitespace, commenting, empty lines in PPMU driver
Changes since v3:
* Removed the custom devfreq monitor and PPMU polling function
* Moved exynos5 PPMU access functions to the devfreq driver
Changes since v4:
* Fixed compilation errors due to presence of devinit/devexit
* Moved exynos ppmu header to the drivers/devfreq/exynos directory

 drivers/devfreq/Kconfig              |   10 +
 drivers/devfreq/Makefile             |    1 +
 drivers/devfreq/exynos/Makefile      |    1 +
 drivers/devfreq/exynos/exynos5_bus.c |  503 ++++++++++++++++++++++++++++++++++
 drivers/devfreq/exynos/exynos_ppmu.c |   56 ++++
 drivers/devfreq/exynos/exynos_ppmu.h |   79 ++++++
 6 files changed, 650 insertions(+), 0 deletions(-)
 create mode 100644 drivers/devfreq/exynos/exynos5_bus.c
 create mode 100644 drivers/devfreq/exynos/exynos_ppmu.c
 create mode 100644 drivers/devfreq/exynos/exynos_ppmu.h

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 0f079be..1560d0d 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -78,4 +78,14 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 	  To operate with optimal voltages, ASV support is required
 	  (CONFIG_EXYNOS_ASV).
 
+config ARM_EXYNOS5_BUS_DEVFREQ
+	bool "ARM Exynos5250 Bus DEVFREQ Driver"
+	depends on SOC_EXYNOS5250
+	select ARCH_HAS_OPP
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	help
+	  This adds the DEVFREQ driver for Exynos5250 bus interface (vdd_int).
+	  It reads PPMU counters of memory controllers and adjusts the
+	  operating frequencies and voltages with OPP support.
+
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 3bc1fef..16138c9 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
+obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
diff --git a/drivers/devfreq/exynos/Makefile b/drivers/devfreq/exynos/Makefile
index 1498823..bfaaf5b 100644
--- a/drivers/devfreq/exynos/Makefile
+++ b/drivers/devfreq/exynos/Makefile
@@ -1,2 +1,3 @@
 # Exynos DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
+obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos_ppmu.o exynos5_bus.o
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
new file mode 100644
index 0000000..574b16b
--- /dev/null
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -0,0 +1,503 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5 INT clock frequency scaling support using DEVFREQ framework
+ * Based on work done by Jonghwan Choi <jhbird.choi@samsung.com>
+ * Support for only EXYNOS5250 is present.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/devfreq.h>
+#include <linux/io.h>
+#include <linux/opp.h>
+#include <linux/slab.h>
+#include <linux/suspend.h>
+#include <linux/opp.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/pm_qos.h>
+#include <linux/regulator/consumer.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#include "exynos_ppmu.h"
+
+#define MAX_SAFEVOLT			1100000 /* 1.10V */
+/* Assume that the bus is saturated if the utilization is 25% */
+#define INT_BUS_SATURATION_RATIO	25
+
+enum int_level_idx {
+	LV_0,
+	LV_1,
+	LV_2,
+	LV_3,
+	LV_4,
+	_LV_END
+};
+
+enum exynos_ppmu_list {
+	PPMU_RIGHT,
+	PPMU_END,
+};
+
+struct busfreq_data_int {
+	struct device *dev;
+	struct devfreq *devfreq;
+	struct regulator *vdd_int;
+	struct exynos_ppmu ppmu[PPMU_END];
+	unsigned long curr_freq;
+	bool disabled;
+
+	struct notifier_block pm_notifier;
+	struct mutex lock;
+	struct pm_qos_request int_req;
+	struct clk *int_clk;
+};
+
+struct int_bus_opp_table {
+	unsigned int idx;
+	unsigned long clk;
+	unsigned long volt;
+};
+
+static struct int_bus_opp_table exynos5_int_opp_table[] = {
+	{LV_0, 266000, 1025000},
+	{LV_1, 200000, 1025000},
+	{LV_2, 160000, 1025000},
+	{LV_3, 133000, 1025000},
+	{LV_4, 100000, 1025000},
+	{0, 0, 0},
+};
+
+static void busfreq_mon_reset(struct busfreq_data_int *data)
+{
+	unsigned int i;
+
+	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
+		void __iomem *ppmu_base = data->ppmu[i].hw_base;
+
+		/* Reset the performance and cycle counters */
+		exynos_ppmu_reset(ppmu_base);
+
+		/* Setup count registers to monitor read/write transactions */
+		data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
+					data->ppmu[i].event[PPMU_PMNCNT3]);
+
+		exynos_ppmu_start(ppmu_base);
+	}
+}
+
+static void exynos5_read_ppmu(struct busfreq_data_int *data)
+{
+	int i, j;
+
+	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
+		void __iomem *ppmu_base = data->ppmu[i].hw_base;
+
+		exynos_ppmu_stop(ppmu_base);
+
+		/* Update local data from PPMU */
+		data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (data->ppmu[i].event[j] == 0)
+				data->ppmu[i].count[j] = 0;
+			else
+				data->ppmu[i].count[j] =
+					exynos_ppmu_read(ppmu_base, j);
+		}
+	}
+
+	busfreq_mon_reset(data);
+}
+
+static int exynos5_int_setvolt(struct busfreq_data_int *data,
+				unsigned long volt)
+{
+	return regulator_set_voltage(data->vdd_int, volt, MAX_SAFEVOLT);
+}
+
+static int exynos5_busfreq_int_target(struct device *dev, unsigned long *_freq,
+			      u32 flags)
+{
+	int err = 0;
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+	struct opp *opp;
+	unsigned long old_freq, freq;
+	unsigned long volt;
+
+	rcu_read_lock();
+	opp = devfreq_recommended_opp(dev, _freq, flags);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		dev_err(dev, "%s: Invalid OPP.\n", __func__);
+		return PTR_ERR(opp);
+	}
+
+	freq = opp_get_freq(opp);
+	volt = opp_get_voltage(opp);
+	rcu_read_unlock();
+
+	old_freq = data->curr_freq;
+
+	if (old_freq == freq)
+		return 0;
+
+	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, volt);
+
+	mutex_lock(&data->lock);
+
+	if (data->disabled)
+		goto out;
+
+	if (freq > exynos5_int_opp_table[0].clk)
+		pm_qos_update_request(&data->int_req, freq * 16 / 1000);
+	else
+		pm_qos_update_request(&data->int_req, -1);
+
+	if (old_freq < freq)
+		err = exynos5_int_setvolt(data, volt);
+	if (err)
+		goto out;
+
+	err = clk_set_rate(data->int_clk, freq * 1000);
+
+	if (err)
+		goto out;
+
+	if (old_freq > freq)
+		err = exynos5_int_setvolt(data, volt);
+	if (err)
+		goto out;
+
+	data->curr_freq = freq;
+out:
+	mutex_unlock(&data->lock);
+	return err;
+}
+
+static int exynos5_get_busier_dmc(struct busfreq_data_int *data)
+{
+	int i, j;
+	int busy = 0;
+	unsigned int temp = 0;
+
+	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (data->ppmu[i].count[j] > temp) {
+				temp = data->ppmu[i].count[j];
+				busy = i;
+			}
+		}
+	}
+
+	return busy;
+}
+
+static int exynos5_int_get_dev_status(struct device *dev,
+				      struct devfreq_dev_status *stat)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+	int busier_dmc;
+
+	exynos5_read_ppmu(data);
+	busier_dmc = exynos5_get_busier_dmc(data);
+
+	stat->current_frequency = data->curr_freq;
+
+	/* Number of cycles spent on memory access */
+	stat->busy_time = data->ppmu[busier_dmc].count[PPMU_PMNCNT3];
+	stat->busy_time *= 100 / INT_BUS_SATURATION_RATIO;
+	stat->total_time = data->ppmu[busier_dmc].ccnt;
+
+	return 0;
+}
+static void exynos5_int_exit(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	devfreq_unregister_opp_notifier(dev, data->devfreq);
+}
+
+static struct devfreq_dev_profile exynos5_devfreq_int_profile = {
+	.initial_freq		= 160000,
+	.polling_ms		= 100,
+	.target			= exynos5_busfreq_int_target,
+	.get_dev_status		= exynos5_int_get_dev_status,
+	.exit			= exynos5_int_exit,
+};
+
+static int exynos5250_init_int_tables(struct busfreq_data_int *data)
+{
+	int i, err = 0;
+
+	for (i = LV_0; i < _LV_END; i++) {
+		err = opp_add(data->dev, exynos5_int_opp_table[i].clk,
+				exynos5_int_opp_table[i].volt);
+		if (err) {
+			dev_err(data->dev, "Cannot add opp entries.\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
+		unsigned long event, void *ptr)
+{
+	struct busfreq_data_int *data = container_of(this,
+					struct busfreq_data_int, pm_notifier);
+	struct opp *opp;
+	unsigned long maxfreq = ULONG_MAX;
+	unsigned long freq;
+	unsigned long volt;
+	int err = 0;
+
+	switch (event) {
+	case PM_SUSPEND_PREPARE:
+		/* Set Fastest and Deactivate DVFS */
+		mutex_lock(&data->lock);
+
+		data->disabled = true;
+
+		rcu_read_lock();
+		opp = opp_find_freq_floor(data->dev, &maxfreq);
+		if (IS_ERR(opp)) {
+			rcu_read_unlock();
+			err = PTR_ERR(opp);
+			goto unlock;
+		}
+		freq = opp_get_freq(opp);
+		volt = opp_get_voltage(opp);
+		rcu_read_unlock();
+
+		err = exynos5_int_setvolt(data, volt);
+		if (err)
+			goto unlock;
+
+		err = clk_set_rate(data->int_clk, freq * 1000);
+
+		if (err)
+			goto unlock;
+
+		data->curr_freq = freq;
+unlock:
+		mutex_unlock(&data->lock);
+		if (err)
+			return NOTIFY_BAD;
+		return NOTIFY_OK;
+	case PM_POST_RESTORE:
+	case PM_POST_SUSPEND:
+		/* Reactivate */
+		mutex_lock(&data->lock);
+		data->disabled = false;
+		mutex_unlock(&data->lock);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int exynos5_busfreq_int_probe(struct platform_device *pdev)
+{
+	struct busfreq_data_int *data;
+	struct opp *opp;
+	struct device *dev = &pdev->dev;
+	struct device_node *np;
+	unsigned long initial_freq;
+	unsigned long initial_volt;
+	int err = 0;
+	int i;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data_int),
+				GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "samsung,exynos5250-ppmu");
+	if (np == NULL) {
+		pr_err("Unable to find PPMU node\n");
+		return -ENOENT;
+	}
+
+	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
+		/* map PPMU memory region */
+		data->ppmu[i].hw_base = of_iomap(np, i);
+		if (data->ppmu[i].hw_base == NULL) {
+			dev_err(&pdev->dev, "failed to map memory region\n");
+			return -ENOMEM;
+		}
+	}
+	data->pm_notifier.notifier_call = exynos5_busfreq_int_pm_notifier_event;
+	data->dev = dev;
+	mutex_init(&data->lock);
+
+	err = exynos5250_init_int_tables(data);
+	if (err)
+		goto err_regulator;
+
+	data->vdd_int = regulator_get(dev, "vdd_int");
+	if (IS_ERR(data->vdd_int)) {
+		dev_err(dev, "Cannot get the regulator \"vdd_int\"\n");
+		err = PTR_ERR(data->vdd_int);
+		goto err_regulator;
+	}
+
+	data->int_clk = clk_get(dev, "int_clk");
+	if (IS_ERR(data->int_clk)) {
+		dev_err(dev, "Cannot get clock \"int_clk\"\n");
+		err = PTR_ERR(data->int_clk);
+		goto err_clock;
+	}
+
+	rcu_read_lock();
+	opp = opp_find_freq_floor(dev,
+			&exynos5_devfreq_int_profile.initial_freq);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
+		       exynos5_devfreq_int_profile.initial_freq);
+		err = PTR_ERR(opp);
+		goto err_opp_add;
+	}
+	initial_freq = opp_get_freq(opp);
+	initial_volt = opp_get_voltage(opp);
+	rcu_read_unlock();
+	data->curr_freq = initial_freq;
+
+	err = clk_set_rate(data->int_clk, initial_freq * 1000);
+	if (err) {
+		dev_err(dev, "Failed to set initial frequency\n");
+		goto err_opp_add;
+	}
+
+	err = exynos5_int_setvolt(data, initial_volt);
+	if (err)
+		goto err_opp_add;
+
+	platform_set_drvdata(pdev, data);
+
+	busfreq_mon_reset(data);
+
+	data->devfreq = devfreq_add_device(dev, &exynos5_devfreq_int_profile,
+					   "simple_ondemand", NULL);
+
+	if (IS_ERR(data->devfreq)) {
+		err = PTR_ERR(data->devfreq);
+		goto err_devfreq_add;
+	}
+
+	devfreq_register_opp_notifier(dev, data->devfreq);
+
+	err = register_pm_notifier(&data->pm_notifier);
+	if (err) {
+		dev_err(dev, "Failed to setup pm notifier\n");
+		goto err_devfreq_add;
+	}
+
+	/* TODO: Add a new QOS class for int/mif bus */
+	pm_qos_add_request(&data->int_req, PM_QOS_NETWORK_THROUGHPUT, -1);
+
+	return 0;
+
+err_devfreq_add:
+	devfreq_remove_device(data->devfreq);
+	platform_set_drvdata(pdev, NULL);
+err_opp_add:
+	clk_put(data->int_clk);
+err_clock:
+	regulator_put(data->vdd_int);
+err_regulator:
+	return err;
+}
+
+static int exynos5_busfreq_int_remove(struct platform_device *pdev)
+{
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	pm_qos_remove_request(&data->int_req);
+	unregister_pm_notifier(&data->pm_notifier);
+	devfreq_remove_device(data->devfreq);
+	regulator_put(data->vdd_int);
+	clk_put(data->int_clk);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static int exynos5_busfreq_int_resume(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	busfreq_mon_reset(data);
+	return 0;
+}
+
+static const struct dev_pm_ops exynos5_busfreq_int_pm = {
+	.resume	= exynos5_busfreq_int_resume,
+};
+
+/* platform device pointer for exynos5 devfreq device. */
+static struct platform_device *exynos5_devfreq_pdev;
+
+static struct platform_driver exynos5_busfreq_int_driver = {
+	.probe		= exynos5_busfreq_int_probe,
+	.remove		= exynos5_busfreq_int_remove,
+	.driver		= {
+		.name		= "exynos5-bus-int",
+		.owner		= THIS_MODULE,
+		.pm		= &exynos5_busfreq_int_pm,
+	},
+};
+
+static int __init exynos5_busfreq_int_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&exynos5_busfreq_int_driver);
+	if (ret < 0)
+		goto out;
+
+	exynos5_devfreq_pdev =
+		platform_device_register_simple("exynos5-bus-int", -1, NULL, 0);
+	if (IS_ERR_OR_NULL(exynos5_devfreq_pdev)) {
+		ret = PTR_ERR(exynos5_devfreq_pdev);
+		goto out1;
+	}
+
+	return 0;
+out1:
+	platform_driver_unregister(&exynos5_busfreq_int_driver);
+out:
+	return ret;
+}
+late_initcall(exynos5_busfreq_int_init);
+
+static void __exit exynos5_busfreq_int_exit(void)
+{
+	platform_device_unregister(exynos5_devfreq_pdev);
+	platform_driver_unregister(&exynos5_busfreq_int_driver);
+}
+module_exit(exynos5_busfreq_int_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("EXYNOS5 busfreq driver with devfreq framework");
diff --git a/drivers/devfreq/exynos/exynos_ppmu.c b/drivers/devfreq/exynos/exynos_ppmu.c
new file mode 100644
index 0000000..85fc5ac
--- /dev/null
+++ b/drivers/devfreq/exynos/exynos_ppmu.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS - PPMU support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include "exynos_ppmu.h"
+
+void exynos_ppmu_reset(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, ppmu_base);
+	__raw_writel(PPMU_ENABLE_CYCLE  |
+		     PPMU_ENABLE_COUNT0 |
+		     PPMU_ENABLE_COUNT1 |
+		     PPMU_ENABLE_COUNT2 |
+		     PPMU_ENABLE_COUNT3,
+		     ppmu_base + PPMU_CNTENS);
+}
+
+void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+			unsigned int evt)
+{
+	__raw_writel(evt, ppmu_base + PPMU_BEVTSEL(ch));
+}
+
+void exynos_ppmu_start(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_ENABLE, ppmu_base);
+}
+
+void exynos_ppmu_stop(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_DISABLE, ppmu_base);
+}
+
+unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch)
+{
+	unsigned int total;
+
+	if (ch == PPMU_PMNCNT3)
+		total = ((__raw_readl(ppmu_base + PMCNT_OFFSET(ch)) << 8) |
+			  __raw_readl(ppmu_base + PMCNT_OFFSET(ch + 1)));
+	else
+		total = __raw_readl(ppmu_base + PMCNT_OFFSET(ch));
+
+	return total;
+}
diff --git a/drivers/devfreq/exynos/exynos_ppmu.h b/drivers/devfreq/exynos/exynos_ppmu.h
new file mode 100644
index 0000000..b46d31b
--- /dev/null
+++ b/drivers/devfreq/exynos/exynos_ppmu.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS PPMU header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __DEVFREQ_EXYNOS_PPMU_H
+#define __DEVFREQ_EXYNOS_PPMU_H __FILE__
+
+#include <linux/ktime.h>
+
+/* For PPMU Control */
+#define PPMU_ENABLE             BIT(0)
+#define PPMU_DISABLE            0x0
+#define PPMU_CYCLE_RESET        BIT(1)
+#define PPMU_COUNTER_RESET      BIT(2)
+
+#define PPMU_ENABLE_COUNT0      BIT(0)
+#define PPMU_ENABLE_COUNT1      BIT(1)
+#define PPMU_ENABLE_COUNT2      BIT(2)
+#define PPMU_ENABLE_COUNT3      BIT(3)
+#define PPMU_ENABLE_CYCLE       BIT(31)
+
+#define PPMU_CNTENS		0x10
+#define PPMU_FLAG		0x50
+#define PPMU_CCNT_OVERFLOW	BIT(31)
+#define PPMU_CCNT		0x100
+
+#define PPMU_PMCNT0		0x110
+#define PPMU_PMCNT_OFFSET	0x10
+#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
+
+#define PPMU_BEVT0SEL		0x1000
+#define PPMU_BEVTSEL_OFFSET	0x100
+#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (ch * PPMU_BEVTSEL_OFFSET))
+
+/* For Event Selection */
+#define RD_DATA_COUNT		0x5
+#define WR_DATA_COUNT		0x6
+#define RDWR_DATA_COUNT		0x7
+
+enum ppmu_counter {
+	PPMU_PMNCNT0,
+	PPMU_PMCCNT1,
+	PPMU_PMNCNT2,
+	PPMU_PMNCNT3,
+	PPMU_PMNCNT_MAX,
+};
+
+struct bus_opp_table {
+	unsigned int idx;
+	unsigned long clk;
+	unsigned long volt;
+};
+
+struct exynos_ppmu {
+	void __iomem *hw_base;
+	unsigned int ccnt;
+	unsigned int event[PPMU_PMNCNT_MAX];
+	unsigned int count[PPMU_PMNCNT_MAX];
+	unsigned long long ns;
+	ktime_t reset_time;
+	bool ccnt_overflow;
+	bool count_overflow[PPMU_PMNCNT_MAX];
+};
+
+void exynos_ppmu_reset(void __iomem *ppmu_base);
+void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+			unsigned int evt);
+void exynos_ppmu_start(void __iomem *ppmu_base);
+void exynos_ppmu_stop(void __iomem *ppmu_base);
+unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch);
+#endif /* __DEVFREQ_EXYNOS_PPMU_H */
+
-- 
1.7.8.6

