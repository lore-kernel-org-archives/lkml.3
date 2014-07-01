Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbaGAAdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:33:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50725 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaGAAd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:33:29 -0400
X-AuditID: cbfee690-b7fb56d000003439-94-53b201d5be6e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: kgene.kim@samsung.com, amit.daniel@samsung.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] thermal: samsung: Add TMU support for Exynos3250 SoC
Date: Tue, 01 Jul 2014 09:33:19 +0900
Message-id: <1404174799-8969-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkSPca46Zgg2u3mCwaroZYXP/ynNVi
	/pFzrBZr9v9ksug8+4TZonfBVTaLs01v2C0u75rDZvG59wijxYzz+5gsnjzsY7NYP+M1iwOP
	x+I9L5k8+rasYvQ4fmM7k8fnTXIBLFFcNimpOZllqUX6dglcGQ/bljMVLDKvOHxtJ1sDY7N+
	FyMnh4SAicSfX4cYIWwxiQv31rN1MXJxCAksZZTYdOc5E0zRr6Y5TBCJ6YwSCxv+QjlNTBKb
	9hxhBqliE9CS2P/iBhuILSJgINFxZQYzSBGzwDomifbjbUAOB4ewgKvE9f1cIDUsAqoS1/Z9
	YAWxeQVcJJ5+bWGH2CYn8WHPI3aQXgmBRewSLzp3sEA0CEh8m3yIBWSOhICsxKYDzBD1khIH
	V9xgmcAouICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYHif/vdswg7GewesDzEmA42b
	yCwlmpwPjI+8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamCcyaom9DOpkJXjSkWs+fnmFMvb6bNnL2zcludR+6Cl6PW12n3qJx7brnnSyJPzuCO6
	ucdpefWexcKr1vMl7FMRjRFormqPcp6Qt82ZK/wQu0Zd1EsWU4Hl7Zc+3y9LCXW7/O6vga/o
	FqndB7m7uK/W/888YLno93uBORt+3FC9O0P65YPnjeVKLMUZiYZazEXFiQAtIKGGhQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2rjJuCDVb0mFk0XA2xuP7lOavF
	/CPnWC3W7P/JZNF59gmzRe+Cq2wWZ5vesFtc3jWHzeJz7xFGixnn9zFZPHnYx2axfsZrFgce
	j8V7XjJ59G1Zxehx/MZ2Jo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
	LS3MlRTyEnNTbZVcfAJ03TJzgE5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SA
	BhLWMGY8bFvOVLDIvOLwtZ1sDYzN+l2MnBwSAiYSv5rmMEHYYhIX7q1n62Lk4hASmM4osbDh
	LxOE08QksWnPEWaQKjYBLYn9L26wgdgiAgYSHVdmMIMUMQusY5JoP94G5HBwCAu4SlzfzwVS
	wyKgKnFt3wdWEJtXwEXi6dcWdohtchIf9jxin8DIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcPQ8k97BuKrB4hCjAAejEg/vidqNwUKsiWXFlbmHGCU4mJVEePN/AIV4UxIrq1KL
	8uOLSnNSiw8xmgJtn8gsJZqcD4zsvJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakF
	qUUwfUwcnFINjP752UeVZjBXmaZ1iR3kuHRvzh++pOvf7qV5xRxeOinEPZdt/t9H5qZ+n6ZG
	/O/68eBM8TalZQdnTsyZI7J+X/+aq6obeVneb70htvvRsi+Tlryfb3nEP6GtsP6GVNbDzUHn
	taW2P/pS+mHqsqkvTW+VLFgrGuVZlrC1anbsh8PH/uzwWjmJ21ZRiaU4I9FQi7moOBEA2IZZ
	tbQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add registers, bit fields and compatible strings for Exynos3250 TMU
(Thermal Management Unit). Exynos3250 uses the Cortex-A7 dual cores and has
a target speed of 1.0 GHz.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[Add MUX address setting bits by Jonghwa Lee]
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |  1 +
 drivers/thermal/samsung/exynos_tmu.c               |  7 +-
 drivers/thermal/samsung/exynos_tmu.h               |  3 +-
 drivers/thermal/samsung/exynos_tmu_data.c          | 89 ++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h          |  7 ++
 5 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index c949092..ae738f5 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -3,6 +3,7 @@
 ** Required properties:
 
 - compatible : One of the following:
+	       "samsung,exynos3250-tmu"
 	       "samsung,exynos4412-tmu"
 	       "samsung,exynos4210-tmu"
 	       "samsung,exynos5250-tmu"
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 2412090..97ebc1e 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -501,6 +501,10 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 
 static const struct of_device_id exynos_tmu_match[] = {
 	{
+		.compatible = "samsung,exynos3250-tmu",
+		.data = (void *)EXYNOS3250_TMU_DRV_DATA,
+	},
+	{
 		.compatible = "samsung,exynos4210-tmu",
 		.data = (void *)EXYNOS4210_TMU_DRV_DATA,
 	},
@@ -675,7 +679,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk_sec;
 	}
 
-	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
+	if (pdata->type == SOC_ARCH_EXYNOS3250 ||
+	    pdata->type == SOC_ARCH_EXYNOS4210 ||
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
 	    pdata->type == SOC_ARCH_EXYNOS5250 ||
 	    pdata->type == SOC_ARCH_EXYNOS5260 ||
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index edd08cf..1b4a644 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -40,7 +40,8 @@ enum calibration_mode {
 };
 
 enum soc_type {
-	SOC_ARCH_EXYNOS4210 = 1,
+	SOC_ARCH_EXYNOS3250 = 1,
+	SOC_ARCH_EXYNOS4210,
 	SOC_ARCH_EXYNOS4412,
 	SOC_ARCH_EXYNOS5250,
 	SOC_ARCH_EXYNOS5260,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index c1d81dc..aa8e0de 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -90,6 +90,95 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 };
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS3250)
+static const struct exynos_tmu_registers exynos3250_tmu_registers = {
+	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
+	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
+	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
+	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
+	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
+	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
+	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
+	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
+	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
+	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
+	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
+	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
+	.tmu_status = EXYNOS_TMU_REG_STATUS,
+	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
+	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
+	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
+	.tmu_inten = EXYNOS_TMU_REG_INTEN,
+	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
+	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
+	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
+	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
+	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
+	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
+	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
+	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
+	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
+	.emul_con = EXYNOS_EMUL_CON,
+	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
+	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
+	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
+};
+
+#define EXYNOS3250_TMU_DATA \
+	.threshold_falling = 10, \
+	.trigger_levels[0] = 70, \
+	.trigger_levels[1] = 95, \
+	.trigger_levels[2] = 110, \
+	.trigger_levels[3] = 120, \
+	.trigger_enable[0] = true, \
+	.trigger_enable[1] = true, \
+	.trigger_enable[2] = true, \
+	.trigger_enable[3] = false, \
+	.trigger_type[0] = THROTTLE_ACTIVE, \
+	.trigger_type[1] = THROTTLE_ACTIVE, \
+	.trigger_type[2] = SW_TRIP, \
+	.trigger_type[3] = HW_TRIP, \
+	.max_trigger_level = 4, \
+	.gain = 8, \
+	.reference_voltage = 16, \
+	.noise_cancel_mode = 4, \
+	.cal_type = TYPE_TWO_POINT_TRIMMING, \
+	.efuse_value = 55, \
+	.min_efuse_value = 40, \
+	.max_efuse_value = 100, \
+	.first_point_trim = 25, \
+	.second_point_trim = 85, \
+	.default_temp_offset = 50, \
+	.freq_tab[0] = { \
+		.freq_clip_max = 800 * 1000, \
+		.temp_level = 70, \
+	}, \
+	.freq_tab[1] = { \
+		.freq_clip_max = 400 * 1000, \
+		.temp_level = 95, \
+	}, \
+	.freq_tab_count = 2, \
+	.registers = &exynos3250_tmu_registers, \
+	.features = (TMU_SUPPORT_EMULATION | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME)
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS3250)
+struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
+	.tmu_data = {
+		{
+			EXYNOS3250_TMU_DATA,
+			.type = SOC_ARCH_EXYNOS3250,
+			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
+		},
+	},
+	.tmu_count = 1,
+};
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index d268981..f0979e5 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -148,6 +148,13 @@
 #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
 #define EXYNOS5440_EFUSE_SWAP_OFFSET		8
 
+#if defined(CONFIG_SOC_EXYNOS3250)
+extern struct exynos_tmu_init_data const exynos3250_default_tmu_data;
+#define EXYNOS3250_TMU_DRV_DATA (&exynos3250_default_tmu_data)
+#else
+#define EXYNOS3250_TMU_DRV_DATA (NULL)
+#endif
+
 #if defined(CONFIG_CPU_EXYNOS4210)
 extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
 #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
-- 
1.8.0

