Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3HZI5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:57:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26321 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3HZI5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:57:03 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-16-521b185ea919
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        "'devicetree'" <devicetree@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
In-reply-to: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
Subject: [PATCH 2/3] video: exynos_dp: remove non-DT support for Exynos Display
 Port
Date: Mon, 26 Aug 2013 17:57:01 +0900
Message-id: <004101cea23a$3ad2a7d0$b077f770$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6iOgN7MgvkoL3hRgS3gzfXOa2c2AAACd0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+ZsW6chHSQwbXVfBYH79dbvDykaTH/
	yDlWi+bF69ksLi+8xGrRu+Aqm8WFpz1sFif6PrBaXN41h81ixvl9TBbrHr5gsjj8pp3VYv2M
	1ywW6+ffYnPg83h14Q6Lx/65a9g9+rasYvQ4fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGS/m
	7GcqWJ9Q8WLXBLYGxpd+XYycHBICJhI3d9xlgbDFJC7cW8/WxcjFISSwjFHi65QbrDBF3/dc
	YIZILGKU2DMTpuoXo8Sm3ysZQarYBNQkvnw5zA5iiwjoSCw8vR6sg1ngHbPEreOrmUESQgK2
	Eq1bF4ON5RSwk/hzoJUJxBYWCJOYv+k5WDOLgKrEwrYTYDYvUP2Gf19YIGxBiR+T74HZzAJa
	Epu3NbFC2PISm9e8BZrPAXSqusSjv7oQNxhJ3O79zwxRIiKx78U7RohvZnJIHNkUDLFKQOLb
	5EMsEK2yEpsOMEOUSEocXHGDZQKjxCwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSoV5yY
	W1yal66XnJ+7iRGSAHp3MN4+YH2IMRlo/URmKdHkfGACySuJNzQ2M7IwNTE1NjK3NCNNWEmc
	V63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo3mbnEzO9h2Gc067X/gfzvRj8xIbpZnH
	jjm+dltQs3vHTC4e5vN7rO03tVa3iqjW/NH1+6f3zi3qq+12nV8xeRO5RDcXnN6lsPzqqXXs
	s45d3WN5tP3uoYxnnxpbb3/v11MrEP/+QCPextjoPN/hhUt0e57rt4Vm6+2xYEnuY9suvCp8
	EfOdJiWW4oxEQy3mouJEAAcM3JcWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd04CekggzWT2SwO3q+3eHlI02L+
	kXOsFs2L17NZXF54idWid8FVNosLT3vYLE70fWC1uLxrDpvFjPP7mCzWPXzBZHH4TTurxfoZ
	r1ks1s+/xebA5/Hqwh0Wj/1z17B79G1Zxehx/MZ2Jo/Pm+QCWKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWa8mLOfqWB9QsWLXRPYGhhf+nUxcnJICJhIfN9zgRnCFpO4
	cG89WxcjF4eQwCJGiT0zYZxfjBKbfq9kBKliE1CT+PLlMDuILSKgI7Hw9HpmkCJmgXfMEreO
	rwYbJSRgK9G6dTEriM0pYCfx50ArE4gtLBAmMX/Tc7BmFgFViYVtJ8BsXqD6Df++sEDYghI/
	Jt8Ds5kFtCQ2b2tihbDlJTaveQs0nwPoVHWJR391IW4wkrjd+58ZokREYt+Ld4wTGIVmIZk0
	C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcIJ5JrWDcWWDxSFGAQ5G
	JR7ewAKpICHWxLLiytxDjBIczEoivOai0kFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9M
	fnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJi5UuHcZyPv
	M+VxN7JCfpSempAV4y+rdkz0ws5t9+9evmKfns0ifsakKmT3xD+ik/eKPdWaxeT11rejLsBq
	mV22f7wo/8OvVg/EDL78DpepOO7a/CvBuZhP7oGSRqL8x97Xjjs05nLEmjorbOg9NEPZdqqs
	gVHIzze8ueIy5X+sHlstmPvujBJLcUaioRZzUXEiAOohlHx0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos Display Port can be used only for Exynos SoCs. In addition,
non-DT for EXYNOS SoCs is not supported from v3.11; thus, there is
no need to support non-DT for Exynos Display Port.

The 'include/video/exynos_dp.h' file has been used for non-DT
support and the content of file include/video/exynos_dp.h is moved
to drivers/video/exynos/exynos_dp_core.h. Thus, the 'exynos_dp.h'
file is removed. Also, 'struct exynos_dp_platdata' is removed,
because it is not used any more.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/video/exynos/Kconfig          |    2 +-
 drivers/video/exynos/exynos_dp_core.c |  116 +++++++----------------------
 drivers/video/exynos/exynos_dp_core.h |  109 +++++++++++++++++++++++++++
 drivers/video/exynos/exynos_dp_reg.c  |    2 -
 include/video/exynos_dp.h             |  131 ---------------------------------
 5 files changed, 135 insertions(+), 225 deletions(-)
 delete mode 100644 include/video/exynos_dp.h

diff --git a/drivers/video/exynos/Kconfig b/drivers/video/exynos/Kconfig
index 1b035b2..fab9019 100644
--- a/drivers/video/exynos/Kconfig
+++ b/drivers/video/exynos/Kconfig
@@ -29,7 +29,7 @@ config EXYNOS_LCD_S6E8AX0
 
 config EXYNOS_DP
 	bool "EXYNOS DP driver support"
-	depends on ARCH_EXYNOS
+	depends on OF && ARCH_EXYNOS
 	default n
 	help
 	  This enables support for DP device.
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 12bbede..05fed7d 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -20,8 +20,6 @@
 #include <linux/delay.h>
 #include <linux/of.h>
 
-#include <video/exynos_dp.h>
-
 #include "exynos_dp_core.h"
 
 static int exynos_dp_init_dp(struct exynos_dp_device *dp)
@@ -894,26 +892,17 @@ static void exynos_dp_hotplug(struct work_struct *work)
 		dev_err(dp->dev, "unable to config video\n");
 }
 
-#ifdef CONFIG_OF
-static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
+static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
 {
 	struct device_node *dp_node = dev->of_node;
-	struct exynos_dp_platdata *pd;
 	struct video_info *dp_video_config;
 
-	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "memory allocation for pdata failed\n");
-		return ERR_PTR(-ENOMEM);
-	}
 	dp_video_config = devm_kzalloc(dev,
 				sizeof(*dp_video_config), GFP_KERNEL);
-
 	if (!dp_video_config) {
 		dev_err(dev, "memory allocation for video config failed\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	pd->video_info = dp_video_config;
 
 	dp_video_config->h_sync_polarity =
 		of_property_read_bool(dp_node, "hsync-active-high");
@@ -960,7 +949,7 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	return pd;
+	return dp_video_config;
 }
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
@@ -1003,48 +992,30 @@ err:
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 {
-	u32 reg;
+	if (dp->phy_addr) {
+		u32 reg;
 
-	reg = __raw_readl(dp->phy_addr);
-	reg |= dp->enable_mask;
-	__raw_writel(reg, dp->phy_addr);
+		reg = __raw_readl(dp->phy_addr);
+		reg |= dp->enable_mask;
+		__raw_writel(reg, dp->phy_addr);
+	}
 }
 
 static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
 {
-	u32 reg;
-
-	reg = __raw_readl(dp->phy_addr);
-	reg &= ~(dp->enable_mask);
-	__raw_writel(reg, dp->phy_addr);
-}
-#else
-static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
-{
-	return NULL;
-}
-
-static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
-{
-	return -EINVAL;
-}
-
-static void exynos_dp_phy_init(struct exynos_dp_device *dp)
-{
-	return;
-}
+	if (dp->phy_addr) {
+		u32 reg;
 
-static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
-{
-	return;
+		reg = __raw_readl(dp->phy_addr);
+		reg &= ~(dp->enable_mask);
+		__raw_writel(reg, dp->phy_addr);
+	}
 }
-#endif /* CONFIG_OF */
 
 static int exynos_dp_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct exynos_dp_device *dp;
-	struct exynos_dp_platdata *pdata;
 
 	int ret = 0;
 
@@ -1057,21 +1028,13 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	dp->dev = &pdev->dev;
 
-	if (pdev->dev.of_node) {
-		pdata = exynos_dp_dt_parse_pdata(&pdev->dev);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
+	dp->video_info = exynos_dp_dt_parse_pdata(&pdev->dev);
+	if (IS_ERR(dp->video_info))
+		return PTR_ERR(dp->video_info);
 
-		ret = exynos_dp_dt_parse_phydata(dp);
-		if (ret)
-			return ret;
-	} else {
-		pdata = pdev->dev.platform_data;
-		if (!pdata) {
-			dev_err(&pdev->dev, "no platform data\n");
-			return -EINVAL;
-		}
-	}
+	ret = exynos_dp_dt_parse_phydata(dp);
+	if (ret)
+		return ret;
 
 	dp->clock = devm_clk_get(&pdev->dev, "dp");
 	if (IS_ERR(dp->clock)) {
@@ -1095,15 +1058,7 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	INIT_WORK(&dp->hotplug_work, exynos_dp_hotplug);
 
-	dp->video_info = pdata->video_info;
-
-	if (pdev->dev.of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_init(dp);
-	} else {
-		if (pdata->phy_init)
-			pdata->phy_init();
-	}
+	exynos_dp_phy_init(dp);
 
 	exynos_dp_init_dp(dp);
 
@@ -1121,18 +1076,11 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 static int exynos_dp_remove(struct platform_device *pdev)
 {
-	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
 
 	flush_work(&dp->hotplug_work);
 
-	if (pdev->dev.of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_exit(dp);
-	} else {
-		if (pdata->phy_exit)
-			pdata->phy_exit();
-	}
+	exynos_dp_phy_exit(dp);
 
 	clk_disable_unprepare(dp->clock);
 
@@ -1143,20 +1091,13 @@ static int exynos_dp_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int exynos_dp_suspend(struct device *dev)
 {
-	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
 	disable_irq(dp->irq);
 
 	flush_work(&dp->hotplug_work);
 
-	if (dev->of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_exit(dp);
-	} else {
-		if (pdata->phy_exit)
-			pdata->phy_exit();
-	}
+	exynos_dp_phy_exit(dp);
 
 	clk_disable_unprepare(dp->clock);
 
@@ -1165,16 +1106,9 @@ static int exynos_dp_suspend(struct device *dev)
 
 static int exynos_dp_resume(struct device *dev)
 {
-	struct exynos_dp_platdata *pdata = dev->platform_data;
 	struct exynos_dp_device *dp = dev_get_drvdata(dev);
 
-	if (dev->of_node) {
-		if (dp->phy_addr)
-			exynos_dp_phy_init(dp);
-	} else {
-		if (pdata->phy_init)
-			pdata->phy_init();
-	}
+	exynos_dp_phy_init(dp);
 
 	clk_prepare_enable(dp->clock);
 
@@ -1203,7 +1137,7 @@ static struct platform_driver exynos_dp_driver = {
 		.name	= "exynos-dp",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos_dp_pm_ops,
-		.of_match_table = of_match_ptr(exynos_dp_match),
+		.of_match_table = exynos_dp_match,
 	},
 };
 
diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/exynos/exynos_dp_core.h
index 6c567bbf..56cfec8 100644
--- a/drivers/video/exynos/exynos_dp_core.h
+++ b/drivers/video/exynos/exynos_dp_core.h
@@ -13,6 +13,99 @@
 #ifndef _EXYNOS_DP_CORE_H
 #define _EXYNOS_DP_CORE_H
 
+#define DP_TIMEOUT_LOOP_COUNT 100
+#define MAX_CR_LOOP 5
+#define MAX_EQ_LOOP 5
+
+enum link_rate_type {
+	LINK_RATE_1_62GBPS = 0x06,
+	LINK_RATE_2_70GBPS = 0x0a
+};
+
+enum link_lane_count_type {
+	LANE_COUNT1 = 1,
+	LANE_COUNT2 = 2,
+	LANE_COUNT4 = 4
+};
+
+enum link_training_state {
+	START,
+	CLOCK_RECOVERY,
+	EQUALIZER_TRAINING,
+	FINISHED,
+	FAILED
+};
+
+enum voltage_swing_level {
+	VOLTAGE_LEVEL_0,
+	VOLTAGE_LEVEL_1,
+	VOLTAGE_LEVEL_2,
+	VOLTAGE_LEVEL_3,
+};
+
+enum pre_emphasis_level {
+	PRE_EMPHASIS_LEVEL_0,
+	PRE_EMPHASIS_LEVEL_1,
+	PRE_EMPHASIS_LEVEL_2,
+	PRE_EMPHASIS_LEVEL_3,
+};
+
+enum pattern_set {
+	PRBS7,
+	D10_2,
+	TRAINING_PTN1,
+	TRAINING_PTN2,
+	DP_NONE
+};
+
+enum color_space {
+	COLOR_RGB,
+	COLOR_YCBCR422,
+	COLOR_YCBCR444
+};
+
+enum color_depth {
+	COLOR_6,
+	COLOR_8,
+	COLOR_10,
+	COLOR_12
+};
+
+enum color_coefficient {
+	COLOR_YCBCR601,
+	COLOR_YCBCR709
+};
+
+enum dynamic_range {
+	VESA,
+	CEA
+};
+
+enum pll_status {
+	PLL_UNLOCKED,
+	PLL_LOCKED
+};
+
+enum clock_recovery_m_value_type {
+	CALCULATED_M,
+	REGISTER_M
+};
+
+enum video_timing_recognition_type {
+	VIDEO_TIMING_FROM_CAPTURE,
+	VIDEO_TIMING_FROM_REGISTER
+};
+
+enum analog_power_block {
+	AUX_BLOCK,
+	CH0_BLOCK,
+	CH1_BLOCK,
+	CH2_BLOCK,
+	CH3_BLOCK,
+	ANALOG_TOTAL,
+	POWER_ALL
+};
+
 enum dp_irq_type {
 	DP_IRQ_TYPE_HP_CABLE_IN,
 	DP_IRQ_TYPE_HP_CABLE_OUT,
@@ -20,6 +113,22 @@ enum dp_irq_type {
 	DP_IRQ_TYPE_UNKNOWN,
 };
 
+struct video_info {
+	char *name;
+
+	bool h_sync_polarity;
+	bool v_sync_polarity;
+	bool interlaced;
+
+	enum color_space color_space;
+	enum dynamic_range dynamic_range;
+	enum color_coefficient ycbcr_coeff;
+	enum color_depth color_depth;
+
+	enum link_rate_type link_rate;
+	enum link_lane_count_type lane_count;
+};
+
 struct link_train {
 	int eq_loop;
 	int cr_loop[4];
diff --git a/drivers/video/exynos/exynos_dp_reg.c b/drivers/video/exynos/exynos_dp_reg.c
index 29d9d03..b70da50 100644
--- a/drivers/video/exynos/exynos_dp_reg.c
+++ b/drivers/video/exynos/exynos_dp_reg.c
@@ -14,8 +14,6 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 
-#include <video/exynos_dp.h>
-
 #include "exynos_dp_core.h"
 #include "exynos_dp_reg.h"
 
diff --git a/include/video/exynos_dp.h b/include/video/exynos_dp.h
deleted file mode 100644
index bd8cabd..0000000
--- a/include/video/exynos_dp.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * Samsung SoC DP device support
- *
- * Copyright (C) 2012 Samsung Electronics Co., Ltd.
- * Author: Jingoo Han <jg1.han@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _EXYNOS_DP_H
-#define _EXYNOS_DP_H
-
-#define DP_TIMEOUT_LOOP_COUNT 100
-#define MAX_CR_LOOP 5
-#define MAX_EQ_LOOP 5
-
-enum link_rate_type {
-	LINK_RATE_1_62GBPS = 0x06,
-	LINK_RATE_2_70GBPS = 0x0a
-};
-
-enum link_lane_count_type {
-	LANE_COUNT1 = 1,
-	LANE_COUNT2 = 2,
-	LANE_COUNT4 = 4
-};
-
-enum link_training_state {
-	START,
-	CLOCK_RECOVERY,
-	EQUALIZER_TRAINING,
-	FINISHED,
-	FAILED
-};
-
-enum voltage_swing_level {
-	VOLTAGE_LEVEL_0,
-	VOLTAGE_LEVEL_1,
-	VOLTAGE_LEVEL_2,
-	VOLTAGE_LEVEL_3,
-};
-
-enum pre_emphasis_level {
-	PRE_EMPHASIS_LEVEL_0,
-	PRE_EMPHASIS_LEVEL_1,
-	PRE_EMPHASIS_LEVEL_2,
-	PRE_EMPHASIS_LEVEL_3,
-};
-
-enum pattern_set {
-	PRBS7,
-	D10_2,
-	TRAINING_PTN1,
-	TRAINING_PTN2,
-	DP_NONE
-};
-
-enum color_space {
-	COLOR_RGB,
-	COLOR_YCBCR422,
-	COLOR_YCBCR444
-};
-
-enum color_depth {
-	COLOR_6,
-	COLOR_8,
-	COLOR_10,
-	COLOR_12
-};
-
-enum color_coefficient {
-	COLOR_YCBCR601,
-	COLOR_YCBCR709
-};
-
-enum dynamic_range {
-	VESA,
-	CEA
-};
-
-enum pll_status {
-	PLL_UNLOCKED,
-	PLL_LOCKED
-};
-
-enum clock_recovery_m_value_type {
-	CALCULATED_M,
-	REGISTER_M
-};
-
-enum video_timing_recognition_type {
-	VIDEO_TIMING_FROM_CAPTURE,
-	VIDEO_TIMING_FROM_REGISTER
-};
-
-enum analog_power_block {
-	AUX_BLOCK,
-	CH0_BLOCK,
-	CH1_BLOCK,
-	CH2_BLOCK,
-	CH3_BLOCK,
-	ANALOG_TOTAL,
-	POWER_ALL
-};
-
-struct video_info {
-	char *name;
-
-	bool h_sync_polarity;
-	bool v_sync_polarity;
-	bool interlaced;
-
-	enum color_space color_space;
-	enum dynamic_range dynamic_range;
-	enum color_coefficient ycbcr_coeff;
-	enum color_depth color_depth;
-
-	enum link_rate_type link_rate;
-	enum link_lane_count_type lane_count;
-};
-
-struct exynos_dp_platdata {
-	struct video_info *video_info;
-
-	void (*phy_init)(void);
-	void (*phy_exit)(void);
-};
-
-#endif /* _EXYNOS_DP_H */
-- 
1.7.10.4


