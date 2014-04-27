Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaD0Huk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:50:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8652 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaD0HkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:01 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-fa-535cb450b133
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 26/31] clk: exynos: add gate clock descriptions of System
 MMU
Date: Sun, 27 Apr 2014 13:07:58 +0530
Message-id: <1398584283-22846-27-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkTjdgS0ywwZrVIhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bh2xfY
	Cpa6Vtzt287YwPjIqouRk0NCwETi+JTfjBC2mMSFe+vZQGwhgaWMEu1H5WFqnrd2MUPEFzFK
	XDrt0cXIBWRPYJJY9vkSK0iCTcBQYvu9K6wgCRGB1YwSfRfPsIM4zAJ3mSTmrHoHtkJYIFji
	6Ym/YDaLgKrEqoWPwLp5BTwkWibfZuli5ABapyAxZ5INSJgTKPzkzh4WiM3uEm9PfQFbICEw
	k0Oi+e07Jog5AhLfJh+C6pWV2HSAGeJqSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4
	NC9dLzk/dxMjMBpP/3s2cQfj/QPWhxiTgcZNZJYSTc4HRnNeSbyhsZmRhamJqbGRuaUZacJK
	4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAWS3pbWYmZSjBp7Hc7/DTE+Ncmzqk7
	2r1Ydt9hb10jtjeg4ojAjdcKtyxfagX7Z1XtPtf4eq/j+mVbOVrCq+NntJaVK5qruNoszSpf
	cNqm/S3zlC4XL6N7L1t03bYbM9k+ikj9fSQlqCHP5brZokVTZ6V9WbmeR++7LseVczM1Xt/a
	ePxqiZgSS3FGoqEWc1FxIgCfyUJK3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd2ALTHBBlfmcljcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzDt++wFaw1LXibt92xgbGR1ZdjJwcEgImEs9bu5ghbDGJC/fW
	s4HYQgKLGCUunfboYuQCsicwSSz7fIkVJMEmYCix/d4VVpCEiMBqRom+i2fYQRxmgbtMEnNW
	vWMEqRIWCJZ4euIvmM0ioCqxauEjsG5eAQ+Jlsm3WboYOYDWKUjMmWQDEuYECj+5s4cFYrO7
	xNtTX1gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc7c+kdjCubLA4xCjAwajE
	w7tAMiZYiDWxrLgy9xCjBAezkggv53SgEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDE1Fe
	SbyhsYm5qbGppYmFiZklacJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTA6G0Sap8VGnDIv
	36uQeyXo7JO/Xh23K28eX3imzikh3SvHeUfNEjtFI6G3FvPWPDsxx79tcpj29a+zV5zWnnwr
	0jrxjdILXgtWgQjHT6n5nraLw7S9V752M7ao4tn7JF3ikWngujDhGaGyzw4oXJw6R1Em03td
	T/PFr86vE6Q+GnWXe7zgXa/EUpyRaKjFXFScCAADvESaOgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This adds gate clocks of all System MMUs and their master IPs
that are not apeared in clk-exynos5250.c and clk-exynos5420.c

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/clk/samsung/clk-exynos5250.c   |   36 ++++++++++++++++++++++++++++++++
 drivers/clk/samsung/clk-exynos5420.c   |   13 ++++++++++--
 include/dt-bindings/clock/exynos5250.h |   17 +++++++++++++++
 include/dt-bindings/clock/exynos5420.h |    6 +++++-
 4 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index e7ee442..04f41ec 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -28,6 +28,8 @@
 #define MPLL_CON0		0x4100
 #define SRC_CORE1		0x4204
 #define GATE_IP_ACP		0x8800
+#define GATE_IP_ISP0		0xC800
+#define GATE_IP_ISP1		0xC804
 #define CPLL_LOCK		0x10020
 #define EPLL_LOCK		0x10030
 #define VPLL_LOCK		0x10040
@@ -37,6 +39,7 @@
 #define VPLL_CON0		0x10140
 #define GPLL_CON0		0x10150
 #define SRC_TOP0		0x10210
+#define SRC_TOP1		0x10214
 #define SRC_TOP2		0x10218
 #define SRC_TOP3		0x1021c
 #define SRC_GSCL		0x10220
@@ -100,6 +103,7 @@ static unsigned long exynos5250_clk_regs[] __initdata = {
 	DIV_CPU0,
 	SRC_CORE1,
 	SRC_TOP0,
+	SRC_TOP1,
 	SRC_TOP2,
 	SRC_TOP3,
 	SRC_GSCL,
@@ -141,6 +145,8 @@ static unsigned long exynos5250_clk_regs[] __initdata = {
 	PLL_DIV2_SEL,
 	GATE_IP_DISP1,
 	GATE_IP_ACP,
+	GATE_IP_ISP0,
+	GATE_IP_ISP1,
 };
 
 static int exynos5250_clk_suspend(void)
@@ -196,6 +202,7 @@ PNAME(mout_aclk200_p)	= { "mout_mpll_user", "mout_bpll_user" };
 PNAME(mout_aclk200_sub_p) = { "fin_pll", "div_aclk200" };
 PNAME(mout_aclk266_sub_p) = { "fin_pll", "div_aclk266" };
 PNAME(mout_aclk333_sub_p) = { "fin_pll", "div_aclk333" };
+PNAME(mout_aclk400_isp_sub_p) = { "fin_pll", "div_aclk400_isp" };
 PNAME(mout_hdmi_p)	= { "div_hdmi_pixel", "sclk_hdmiphy" };
 PNAME(mout_usb3_p)	= { "mout_mpll_user", "mout_cpll" };
 PNAME(mout_group1_p)	= { "fin_pll", "fin_pll", "sclk_hdmi27m",
@@ -273,6 +280,7 @@ static struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
 	MUX(0, "mout_aclk166", mout_aclk166_p, SRC_TOP0, 8, 1),
 	MUX(0, "mout_aclk200", mout_aclk200_p, SRC_TOP0, 12, 1),
 	MUX(0, "mout_aclk333", mout_aclk166_p, SRC_TOP0, 16, 1),
+	MUX(0, "mout_aclk400_isp", mout_aclk200_p, SRC_TOP1, 24, 1),
 
 	MUX(0, "mout_cpll", mout_cpll_p, SRC_TOP2, 8, 1),
 	MUX(0, "mout_epll", mout_epll_p, SRC_TOP2, 12, 1),
@@ -319,6 +327,8 @@ static struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
 	MUX(0, "mout_spi1", mout_group1_p, SRC_PERIC1, 20, 4),
 	MUX(0, "mout_spi2", mout_group1_p, SRC_PERIC1, 24, 4),
 
+	MUX(0, "mout_aclk_400_isp_sub", mout_aclk400_isp_sub_p, SRC_TOP3, 20, 1),
+	MUX(0, "mout_aclk_266_isp_sub", mout_aclk266_sub_p, SRC_TOP3, 16, 1),
 	/*
 	 * CMU_CDREX
 	 */
@@ -351,6 +361,7 @@ static struct samsung_div_clock exynos5250_div_clks[] __initdata = {
 	DIV(0, "div_aclk200", "mout_aclk200", DIV_TOP0, 12, 3),
 	DIV(0, "div_aclk266", "mout_mpll_user", DIV_TOP0, 16, 3),
 	DIV(0, "div_aclk333", "mout_aclk333", DIV_TOP0, 20, 3),
+	DIV(0, "div_aclk400_isp", "mout_aclk400_isp", DIV_TOP1, 20, 3),
 
 	DIV(0, "div_aclk66_pre", "mout_mpll_user", DIV_TOP1, 24, 3),
 
@@ -615,6 +626,31 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(CLK_WDT, "wdt", "div_aclk66", GATE_IP_PERIS, 19, 0, 0),
 	GATE(CLK_RTC, "rtc", "div_aclk66", GATE_IP_PERIS, 20, 0, 0),
 	GATE(CLK_TMU, "tmu", "div_aclk66", GATE_IP_PERIS, 21, 0, 0),
+	GATE(CLK_SMMU_TV, "smmu_tv", "mout_aclk200_disp1_sub",
+		GATE_IP_DISP1, 2, 0, 0),
+	GATE(CLK_SMMU_FIMD1, "smmu_fimd1", "mout_aclk200_disp1_sub",
+		GATE_IP_DISP1, 8, 0, 0),
+	GATE(CLK_SMMU_2D, "smmu_2d", "div_aclk200", GATE_IP_ACP, 7, 0, 0),
+	GATE(CLK_SMMU_FIMC_ISP, "smmu_fimc_isp", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP0, 8, 0, 0),
+	GATE(CLK_SMMU_FIMC_DRC, "smmu_fimc_drc", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP0, 9, 0, 0),
+	GATE(CLK_SMMU_FIMC_FD, "smmu_fimc_fd", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP0, 10, 0, 0),
+	GATE(CLK_SMMU_FIMC_SCC, "smmu_fimc_scc", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP0, 11, 0, 0),
+	GATE(CLK_SMMU_FIMC_SCP, "smmu_fimc_scp", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP0, 12, 0, 0),
+	GATE(CLK_SMMU_FIMC_MCU, "smmu_fimc_mcu", "mout_aclk_400_isp_sub",
+		GATE_IP_ISP0, 13, 0, 0),
+	GATE(CLK_SMMU_FIMC_ODC, "smmu_fimc_odc", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP1, 4, 0, 0),
+	GATE(CLK_SMMU_FIMC_DIS0, "smmu_fimc_dis0", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP1, 5, 0, 0),
+	GATE(CLK_SMMU_FIMC_DIS1, "smmu_fimc_dis1", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP1, 6, 0, 0),
+	GATE(CLK_SMMU_FIMC_3DNR, "smmu_fimc_3dnr", "mout_aclk_266_isp_sub",
+		GATE_IP_ISP1, 7, 0, 0),
 };
 
 static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 60b2681..b58e4d3 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -82,6 +82,7 @@
 #define GATE_BUS_PERIC1		0x10754
 #define GATE_BUS_PERIS0		0x10760
 #define GATE_BUS_PERIS1		0x10764
+#define GATE_IP_G2D		0x08800
 #define GATE_IP_GSCL0		0x10910
 #define GATE_IP_GSCL1		0x10920
 #define GATE_IP_MFC		0x1092c
@@ -707,6 +708,10 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	GATE(CLK_GSCL_WB, "gscl_wb", "aclk300_gscl", GATE_IP_GSCL1, 13, 0, 0),
 	GATE(CLK_SMMU_FIMCL3, "smmu_fimcl3,", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 16, 0, 0),
+	GATE(CLK_FIMC_LITE0, "fimc_lite0", "aclk333_432_gscl",
+			GATE_IP_GSCL0, 5, 0, 0),
+	GATE(CLK_FIMC_LITE1, "fimc_lite1", "aclk333_432_gscl",
+			GATE_IP_GSCL0, 6, 0, 0),
 	GATE(CLK_FIMC_LITE3, "fimc_lite3", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 17, 0, 0),
 
@@ -715,8 +720,10 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	GATE(CLK_DP1, "dp1", "aclk200_disp1", GATE_IP_DISP1, 4, 0, 0),
 	GATE(CLK_MIXER, "mixer", "aclk166", GATE_IP_DISP1, 5, 0, 0),
 	GATE(CLK_HDMI, "hdmi", "aclk200_disp1", GATE_IP_DISP1, 6, 0, 0),
-	GATE(CLK_SMMU_FIMD1, "smmu_fimd1", "aclk300_disp1", GATE_IP_DISP1, 8, 0,
-		0),
+	GATE(CLK_SMMU_FIMD1M0, "smmu_fimd1m0", "aclk300_disp1", GATE_IP_DISP1,
+		7, 0, 0),
+	GATE(CLK_SMMU_FIMD1M1, "smmu_fimd1m1", "aclk300_disp1", GATE_IP_DISP1,
+		8, 0, 0),
 
 	GATE(CLK_MFC, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
 	GATE(CLK_SMMU_MFCL, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
@@ -743,6 +750,8 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 		0),
 	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
 		0),
+	GATE(CLK_G2D, "g2d", "aclk333_g2d", GATE_IP_G2D, 3, 0, 0),
+	GATE(CLK_SMMU_G2D, "smmu_g2d", "aclk333_g2d", GATE_IP_G2D, 7, 0, 0),
 };
 
 static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
diff --git a/include/dt-bindings/clock/exynos5250.h b/include/dt-bindings/clock/exynos5250.h
index 922f2dc..743ec63 100644
--- a/include/dt-bindings/clock/exynos5250.h
+++ b/include/dt-bindings/clock/exynos5250.h
@@ -150,6 +150,23 @@
 #define CLK_G2D			345
 #define CLK_MDMA0		346
 #define CLK_SMMU_MDMA0		347
+#define CLK_SMMU_TV		348
+#define CLK_SMMU_FIMD1		349
+#define CLK_SMMU_2D		350
+#define CLK_SMMU_FIMC_ISP	351
+#define CLK_SMMU_FIMC_DRC	352
+#define CLK_SMMU_FIMC_SCC	353
+#define CLK_SMMU_FIMC_SCP	354
+#define CLK_SMMU_FIMC_FD	355
+#define CLK_SMMU_FIMC_MCU	356
+#define CLK_SMMU_FIMC_ODC	357
+#define CLK_SMMU_FIMC_DIS0	358
+#define CLK_SMMU_FIMC_DIS1	359
+#define CLK_SMMU_FIMC_3DNR	360
+#define CLK_SMMU_FIMC_LITE0	361
+#define CLK_SMMU_FIMC_LITE1	362
+#define CLK_CAMIF_TOP		363
+
 
 /* mux clocks */
 #define CLK_MOUT_HDMI		1024
diff --git a/include/dt-bindings/clock/exynos5420.h b/include/dt-bindings/clock/exynos5420.h
index 5eefd88..25dedca 100644
--- a/include/dt-bindings/clock/exynos5420.h
+++ b/include/dt-bindings/clock/exynos5420.h
@@ -140,7 +140,8 @@
 #define CLK_HDMI		413
 #define CLK_ACLK300_DISP1	420
 #define CLK_FIMD1		421
-#define CLK_SMMU_FIMD1		422
+#define CLK_SMMU_FIMD1M0	422
+#define CLK_SMMU_FIMD1M1	423
 #define CLK_ACLK166		430
 #define CLK_MIXER		431
 #define CLK_ACLK266		440
@@ -166,12 +167,15 @@
 #define CLK_MDMA0		473
 #define CLK_ACLK333_G2D		480
 #define CLK_G2D			481
+#define CLK_SMMU_G2D		482
 #define CLK_ACLK333_432_GSCL	490
 #define CLK_SMMU_3AA		491
 #define CLK_SMMU_FIMCL0		492
 #define CLK_SMMU_FIMCL1		493
 #define CLK_SMMU_FIMCL3		494
 #define CLK_FIMC_LITE3		495
+#define CLK_FIMC_LITE1		496
+#define CLK_FIMC_LITE0		497
 #define CLK_ACLK_G3D		500
 #define CLK_G3D			501
 #define CLK_SMMU_MIXER		502
-- 
1.7.9.5

