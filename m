Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaLBIyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:54:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaLBIuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:07 -0500
X-AuditID: cbfee68f-f791c6d000004834-9b-547d7d36c23c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/19] clk: samsung: exynos5433: Add clocks for CMU_DISP domain
Date: Tue, 02 Dec 2014 17:49:44 +0900
Message-id: <1417510196-6714-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWyRsSkRNe8tjbEYJ2lxeM1i5ks/k46xm7x
	flkPo8Xl/doW1788Z7WYf+Qcq8WfCa1sFpPuT2CxuPGrjdWid8FVNouzTW/YLTY9vsZqcXnX
	HDaLGef3AfXf+cdmsfT6RSaLU9c/s1ks2vqF3eLwm3ZWixmTX7JZrNr1h9Hi5ccTLA5iHmvm
	rWH0+P1rEqPHzll32T02L6n3uHKiidWjb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mm5MX8ha
	sOExY0Xvo/XsDYzthxm7GDk5JARMJC7e2ssMYYtJXLi3nq2LkYtDSGApo0TT5h64omfn7rBC
	JKYzSsw528QE4TQxSTy4sQGsik1AS2L/ixtsILaIgLNEw9RGsCJmgTfMEnvu72bpYuTgEBbw
	l/gwkR+khkVAVeLc62lgvbwCLhKH3x9ig9imILFs+UxWEJtTwFWi60wfO4gtBFTzq/UjO8hM
	CYGZHBK3n/5jghgkIPFt8iGw+RICshKbDkC9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesV
	J+YWl+al6yXn525iBEbk6X/P+ncw3j1gfYhRgINRiYf3xPmaECHWxLLiytxDjKZAGyYyS4km
	5wPjPq8k3tDYzMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx6
	YnNK4jbsnbJvh9XODdG/1wjt5RI4VZ9tlHOjU1LujLPWldX35+1Lf/vx+9Ebgn+Zf72/sHk9
	94TkyjP6rl8WlxT7N8mv2xq3W9fLcqPwyccyP3l+Vnwo79r84cbq3amrRHd/ZOOOsIiesm6B
	66zUrjlK6/+zHq71CHb863zpiFLLrq1BU3fqKLEUZyQaajEXFScCAF7Lk+rDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV2z2toQgytfdCwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYx48b0hawFGx4zVvQ+Ws/ewNh+mLGLkZNDQsBE4tm5O6wQtpjE
	hXvr2boYuTiEBKYzSsw528QE4TQxSTy4sQGsg01AS2L/ixtsILaIgLNEw9RGsCJmgTfMEnvu
	72bpYuTgEBbwl/gwkR+khkVAVeLc62lgvbwCLhKH3x9ig9imILFs+UywzZwCrhJdZ/rYQWwh
	oJpfrR/ZJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPHPpHYwrmywOMQowMGo
	xMN74nxNiBBrYllxZe4hRgkOZiUR3l/GtSFCvCmJlVWpRfnxRaU5qcWHGE2BrprILCWanA9M
	Rnkl8YbGJmZGlkbmhhZGxuZK4rw3buaGCAmkJ5akZqemFqQWwfQxcXBKNTCmyVb8PDqt75+/
	+x6H5m+3AmZcmprSdS6+4fvSqZbhJfdLPzM0a29s3dE5bSOTUsPRq7op8kcKf133O73waIK/
	8er/Mqe6/BzfSx7QLNiw6P+1EyIXtilWtnop7/SzzdFtN9oUb7csoc2VrXvC70LZat1sBseZ
	DiJP/6a79vX/m1I9eQHr239KLMUZiYZazEXFiQCJbEnXDgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the the mux/divider/gate clocks for CMU_DISP domain which
includes the clocks of Display IPs (DECON/HDMI/DSIM/MIXER). The CMU_DISP clocks
is used to need the source clock of CMU_MIF domain so, the CMU_MIF's clocks
related to CMU_DISP should be always on state.

Also, CMU_DISP must need the source clock of 'sclk_hdmi_spdif_disp'
from CMU_TOP domain. This patch adds the clocks of CMU_TOP related to HDMI.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |   9 +
 drivers/clk/samsung/clk-exynos5433.c               | 465 ++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h             | 114 ++++-
 3 files changed, 577 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
index 27dd77b..8d3dad4 100644
--- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -21,6 +21,8 @@ Required Properties:
     which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
   - "samsung,exynos5433-cmu-g2d"   - clock controller compatible for CMU_G2D
     which generates clocks for G2D/MDMA IPs.
+  - "samsung,exynos5433-cmu-disp"  - clock controller compatible for CMU_DISP
+    which generates clocks for Display (DECON/HDMI/DSIM/MIXER) IPs.
 
 - reg: physical base address of the controller and length of memory mapped
   region.
@@ -78,6 +80,13 @@ Example 1: Examples of clock controller nodes are listed below.
 		#clock-cells = <1>;
 	};
 
+	cmu_disp: clock-controller@0x13b90000 {
+		compatible = "samsung,exynos5433-cmu-disp";
+		reg = <0x13b90000 0x0c04>;
+		#clock-cells = <1>;
+	};
+
+
 Example 2: UART controller node that consumes the clock generated by the clock
 	   controller.
 
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 10197a1..ec23e97 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -245,6 +245,8 @@ PNAME(mout_sclk_audio1_p)	= { "ioclk_audiocdclk1", "fin_pll",
 PNAME(mout_sclk_audio0_p)	= { "ioclk_audiocdclk0", "fin_pll",
 				    "mout_aud_pll_user_t",};
 
+PNAME(mout_sclk_hdmi_spdif_p)	= { "sclk_audio1", "ioclk_spdif_extclk", };
+
 static struct samsung_fixed_factor_clock top_fixed_factor_clks[] __initdata = {
 	FFACTOR(0, "sclk_bus_pll", "fout_bus_pll", 1, 1, 0),
 	FFACTOR(0, "sclk_mfc_pll", "fout_mfc_pll", 1, 1, 0),
@@ -397,6 +399,10 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 			MUX_SEL_TOP_PERIC1, 4, 2),
 	MUX(CLK_MOUT_SCLK_AUDIO0, "mout_sclk_audio0", mout_sclk_audio0_p,
 			MUX_SEL_TOP_PERIC1, 0, 2),
+
+	/* MUX_SEL_TOP_DISP */
+	MUX(CLK_MOUT_SCLK_HDMI_SPDIF, "mout_sclk_hdmi_spdif",
+			mout_sclk_hdmi_spdif_p, MUX_SEL_TOP_DISP, 0, 1),
 };
 
 static struct samsung_div_clock top_div_clks[] __initdata = {
@@ -1256,9 +1262,9 @@ static struct samsung_gate_clock mif_gate_clks[] __initdata = {
 
 	/* ENABLE_ACLK_MIF3 */
 	GATE(CLK_ACLK_BUS2_400, "aclk_bus2_400", "div_aclk_bus2_400",
-			ENABLE_ACLK_MIF3, 4, 0, 0),
+			ENABLE_ACLK_MIF3, 4, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_DISP_333, "aclk_disp_333", "div_aclk_disp_333",
-			ENABLE_ACLK_MIF3, 1, 0, 0),
+			ENABLE_ACLK_MIF3, 1, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_CPIF_200, "aclk_cpif_200", "div_aclk_cpif_200",
 			ENABLE_ACLK_MIF3, 0, CLK_IGNORE_UNUSED, 0),
 
@@ -1333,21 +1339,30 @@ static struct samsung_gate_clock mif_gate_clks[] __initdata = {
 
 	/* ENABLE_SCLK_MIF */
 	GATE(CLK_SCLK_DSIM1_DISP, "sclk_dsim1_disp", "div_sclk_dsim1",
-			ENABLE_SCLK_MIF, 15, 0, 0),
+			ENABLE_SCLK_MIF, 15, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_DECON_TV_VCLK_DISP, "sclk_decon_tv_vclk_disp",
-			"div_sclk_decon_tv_vclk", ENABLE_SCLK_MIF, 14, 0, 0),
+			"div_sclk_decon_tv_vclk", ENABLE_SCLK_MIF,
+			14, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_DSIM0_DISP, "sclk_dsim0_disp", "div_sclk_dsim0",
-			ENABLE_SCLK_MIF, 9, 0, 0),
+			ENABLE_SCLK_MIF, 9, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_DSD_DISP, "sclk_dsd_disp", "div_sclk_dsd",
-			ENABLE_SCLK_MIF, 8, 0, 0),
+			ENABLE_SCLK_MIF, 8, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_DECON_TV_ECLK_DISP, "sclk_decon_tv_eclk_disp",
-			"div_sclk_decon_tv_eclk", ENABLE_SCLK_MIF, 7, 0, 0),
+			"div_sclk_decon_tv_eclk", ENABLE_SCLK_MIF,
+			7, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_DECON_VCLK_DISP, "sclk_decon_vclk_disp",
-			"div_sclk_decon_vclk", ENABLE_SCLK_MIF, 6, 0, 0),
+			"div_sclk_decon_vclk", ENABLE_SCLK_MIF,
+			6, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_DECON_ECLK_DISP, "sclk_decon_eclk_disp",
-			"div_sclk_decon_eclk", ENABLE_SCLK_MIF, 5, 0, 0),
+			"div_sclk_decon_eclk", ENABLE_SCLK_MIF,
+			5, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SCLK_HPM_MIF, "sclk_hpm_mif", "div_sclk_hpm_mif",
-			ENABLE_SCLK_MIF, 4, 0, 0),
+			ENABLE_SCLK_MIF, 4, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_SCLK_TOP_DISP */
+	GATE(CLK_SCLK_HDMI_SPDIF_DISP, "sclk_hdmi_spdif_disp",
+			"mout_sclk_hdmi_spdif", ENABLE_SCLK_TOP_DISP, 0,
+			CLK_IGNORE_UNUSED, 0),
 };
 
 static struct samsung_cmu_info mif_cmu_info __initdata = {
@@ -2009,3 +2024,433 @@ static void __init exynos5433_cmu_g2d_init(struct device_node *np)
 
 CLK_OF_DECLARE(exynos5433_cmu_g2d, "samsung,exynos5433-cmu-g2d",
 		exynos5433_cmu_g2d_init);
+
+/*
+ * Register offset definitions for CMU_DISP
+ */
+#define DISP_PLL_LOCK			0x0000
+#define DISP_PLL_CON0			0x0100
+#define DISP_PLL_CON1			0x0104
+#define DISP_PLL_FREQ_DET		0x0108
+#define MUX_SEL_DISP0			0x0200
+#define MUX_SEL_DISP1			0x0204
+#define MUX_SEL_DISP2			0x0208
+#define MUX_SEL_DISP3			0x020c
+#define MUX_SEL_DISP4			0x0210
+#define MUX_ENABLE_DISP0		0x0300
+#define MUX_ENABLE_DISP1		0x0304
+#define MUX_ENABLE_DISP2		0x0308
+#define MUX_ENABLE_DISP3		0x030c
+#define MUX_ENABLE_DISP4		0x0310
+#define MUX_STAT_DISP0			0x0400
+#define MUX_STAT_DISP1			0x0404
+#define MUX_STAT_DISP2			0x0408
+#define MUX_STAT_DISP3			0x040c
+#define MUX_STAT_DISP4			0x0410
+#define MUX_IGNORE_DISP2		0x0508
+#define DIV_DISP			0x0600
+#define DIV_DISP_PLL_FREQ_DET		0x0604
+#define DIV_STAT_DISP			0x0700
+#define DIV_STAT_DISP_PLL_FREQ_DET	0x0704
+#define ENABLE_ACLK_DISP0		0x0800
+#define ENABLE_ACLK_DISP1		0x0804
+#define ENABLE_PCLK_DISP		0x0900
+#define ENABLE_SCLK_DISP		0x0a00
+#define ENABLE_IP_DISP0			0x0b00
+#define ENABLE_IP_DISP1			0x0b04
+#define CLKOUT_CMU_DISP			0x0c00
+#define CLKOUT_CMU_DISP_DIV_STAT	0x0c04
+
+static unsigned long disp_clk_regs[] __initdata = {
+	DISP_PLL_LOCK,
+	DISP_PLL_CON0,
+	DISP_PLL_CON1,
+	DISP_PLL_FREQ_DET,
+	MUX_SEL_DISP0,
+	MUX_SEL_DISP1,
+	MUX_SEL_DISP2,
+	MUX_SEL_DISP3,
+	MUX_SEL_DISP4,
+	MUX_ENABLE_DISP0,
+	MUX_ENABLE_DISP1,
+	MUX_ENABLE_DISP2,
+	MUX_ENABLE_DISP3,
+	MUX_ENABLE_DISP4,
+	MUX_STAT_DISP0,
+	MUX_STAT_DISP1,
+	MUX_STAT_DISP2,
+	MUX_STAT_DISP3,
+	MUX_STAT_DISP4,
+	MUX_IGNORE_DISP2,
+	DIV_DISP,
+	DIV_DISP_PLL_FREQ_DET,
+	DIV_STAT_DISP,
+	DIV_STAT_DISP_PLL_FREQ_DET,
+	ENABLE_ACLK_DISP0,
+	ENABLE_ACLK_DISP1,
+	ENABLE_PCLK_DISP,
+	ENABLE_SCLK_DISP,
+	ENABLE_IP_DISP0,
+	ENABLE_IP_DISP1,
+	CLKOUT_CMU_DISP,
+	CLKOUT_CMU_DISP_DIV_STAT,
+};
+
+/* list of all parent clock list */
+PNAME(mout_disp_pll_p)			= { "fin_pll", "fout_disp_pll", };
+PNAME(mout_sclk_dsim1_user_p)		= { "fin_pll", "sclk_dsim1_disp", };
+PNAME(mout_sclk_dsim0_user_p)		= { "fin_pll", "sclk_dsim0_disp", };
+PNAME(mout_sclk_dsd_user_p)		= { "fin_pll", "sclk_dsd_disp", };
+PNAME(mout_sclk_decon_tv_eclk_user_p)	= { "fin_pll",
+					    "sclk_decon_tv_eclk_disp", };
+PNAME(mout_sclk_decon_vclk_user_p)	= { "fin_pll",
+					    "sclk_decon_vclk_disp", };
+PNAME(mout_sclk_decon_eclk_user_p)	= { "fin_pll",
+					    "sclk_decon_eclk_disp", };
+PNAME(mout_sclk_decon_tv_vlkc_user_p)	= { "fin_pll",
+					    "sclk_decon_tv_vclk_disp", };
+PNAME(mout_aclk_disp_333_user_p)	= { "fin_pll", "aclk_disp_333", };
+
+PNAME(mout_phyclk_mipidphy1_bitclkdiv8_user_p)	= { "fin_pll",
+					"phyclk_mipidphy1_bitclkdiv8_phy", };
+PNAME(mout_phyclk_mipidphy1_rxclkesc0_user_p)	= { "fin_pll",
+					"phyclk_mipidphy1_rxclkesc0_phy", };
+PNAME(mout_phyclk_mipidphy0_bitclkdiv8_user_p)	= { "fin_pll",
+					"phyclk_mipidphy0_bitclkdiv8_phy", };
+PNAME(mout_phyclk_mipidphy0_rxclkesc0_user_p)	= { "fin_pll",
+					"phyclk_mipidphy0_rxclkesc0_phy", };
+PNAME(mout_phyclk_hdmiphy_tmds_clko_user_p)	= { "fin_pll",
+					"phyclk_hdmiphy_tmds_clko_phy", };
+PNAME(mout_phyclk_hdmiphy_pixel_clko_user_p)	= { "fin_pll",
+					"phyclk_hdmiphy_pixel_clko_phy", };
+
+PNAME(mout_sclk_dsim0_p)		= { "mout_disp_pll",
+					    "mout_sclk_dsim0_user", };
+PNAME(mout_sclk_decon_tv_eclk_p)	= { "mout_disp_pll",
+					    "mout_sclk_decon_tv_eclk_user", };
+PNAME(mout_sclk_decon_vclk_p)		= { "mout_disp_pll",
+					    "mout_sclk_decon_vclk_user", };
+PNAME(mout_sclk_decon_eclk_p)		= { "mout_disp_pll",
+					    "mout_sclk_decon_eclk_user", };
+
+PNAME(mout_sclk_dsim1_b_disp_p)		= { "mout_sclk_dsim1_a_disp",
+					    "mout_sclk_dsim1_user", };
+PNAME(mout_sclk_dsim1_a_disp_p)		= { "mout_disp_pll",
+					    "mout_sclk_dsim0_user", };
+PNAME(mout_sclk_decon_tv_vclk_c_disp_p)	= {
+				"mout_phyclk_hdmiphy_pixel_clko_user",
+				"mout_sclk_decon_tv_vclk_b_disp", };
+PNAME(mout_sclk_decon_tv_vclk_b_disp_p)	= { "mout_sclk_decon_tv_vclk_a_disp",
+					    "mout_sclk_decon_tv_vclk_user", };
+PNAME(mout_sclk_decon_tv_vclk_a_disp_p)	= { "mout_disp_pll",
+					    "mout_sclk_decon_vclk_user", };
+
+static struct samsung_pll_clock disp_pll_clks[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_DISP_PLL, "fout_disp_pll", "fin_pll",
+		DISP_PLL_LOCK, DISP_PLL_CON0, exynos5443_pll_rates),
+};
+
+static struct samsung_fixed_factor_clock disp_fixed_factor_clks[] __initdata = {
+	/*
+	 * sclk_rgb_{vclk|tv_vclk} is half clock of sclk_decon_{vclk|tv_vclk}.
+	 * The divider has fixed value (2) betwwen sclk_rgb_{vclk|tv_vclk}
+	 * and sclk_decon_{vclk|tv_vclk}.
+	 */
+	FFACTOR(CLK_SCLK_RGB_VCLK, "sclk_rgb_vclk", "sclk_decon_vclk",
+			1, 2, 0),
+	FFACTOR(CLK_SCLK_RGB_TV_VCLK, "sclk_rgb_tv_vclk", "sclk_decon_tv_vclk",
+			1, 2, 0),
+};
+
+static struct samsung_fixed_rate_clock disp_fixed_clks[] __initdata = {
+	/* PHY clocks from MIPI_DPHY1 */
+	FRATE(0, "phyclk_mipidphy1_bitclkdiv8_phy", NULL, CLK_IS_ROOT,
+			188000000),
+	FRATE(0, "phyclk_mipidphy1_rxclkesc0_phy", NULL, CLK_IS_ROOT,
+			100000000),
+	/* PHY clocks from MIPI_DPHY0 */
+	FRATE(0, "phyclk_mipidphy0_bitclkdiv8_phy", NULL, CLK_IS_ROOT,
+			188000000),
+	FRATE(0, "phyclk_mipidphy0_rxclkesc0_phy", NULL, CLK_IS_ROOT,
+			100000000),
+	/* PHY clocks from HDMI_PHY */
+	FRATE(0, "phyclk_hdmiphy_tmds_clko_phy", NULL, CLK_IS_ROOT, 300000000),
+	FRATE(0, "phyclk_hdmiphy_pixel_clko_phy", NULL, CLK_IS_ROOT, 166000000),
+};
+
+static struct samsung_mux_clock disp_mux_clks[] __initdata = {
+	/* MUX_SEL_DISP0 */
+	MUX(CLK_MOUT_DISP_PLL, "mout_disp_pll", mout_disp_pll_p, MUX_SEL_DISP0,
+			0, 1),
+
+	/* MUX_SEL_DISP1 */
+	MUX(CLK_MOUT_SCLK_DSIM1_USER, "mout_sclk_dsim1_user",
+			mout_sclk_dsim1_user_p, MUX_SEL_DISP1, 28, 1),
+	MUX(CLK_MOUT_SCLK_DSIM0_USER, "mout_sclk_dsim0_user",
+			mout_sclk_dsim0_user_p, MUX_SEL_DISP1, 24, 1),
+	MUX(CLK_MOUT_SCLK_DSD_USER, "mout_sclk_dsd_user", mout_sclk_dsd_user_p,
+			MUX_SEL_DISP1, 20, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_ECLK_USER, "mout_sclk_decon_tv_eclk_user",
+			mout_sclk_decon_tv_eclk_user_p, MUX_SEL_DISP1, 16, 1),
+	MUX(CLK_MOUT_SCLK_DECON_VCLK_USER, "mout_sclk_decon_vclk_user",
+			mout_sclk_decon_vclk_user_p, MUX_SEL_DISP1, 12, 1),
+	MUX(CLK_MOUT_SCLK_DECON_ECLK_USER, "mout_sclk_decon_eclk_user",
+			mout_sclk_decon_eclk_user_p, MUX_SEL_DISP1, 8, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_USER, "mout_sclk_decon_tv_vclk_user",
+			mout_sclk_decon_tv_vlkc_user_p, MUX_SEL_DISP1, 4, 1),
+	MUX(CLK_MOUT_ACLK_DISP_333_USER, "mout_aclk_disp_333_user",
+			mout_aclk_disp_333_user_p, MUX_SEL_DISP1, 0, 1),
+
+	/* MUX_SEL_DISP2 */
+	MUX(CLK_MOUT_PHYCLK_MIPIDPHY1_BITCLKDIV8_USER,
+			"mout_phyclk_mipidphy1_bitclkdiv8_user",
+			mout_phyclk_mipidphy1_bitclkdiv8_user_p, MUX_SEL_DISP2,
+			20, 1),
+	MUX(CLK_MOUT_PHYCLK_MIPIDPHY1_RXCLKESC0_USER,
+			"mout_phyclk_mipidphy1_rxclkesc0_user",
+			mout_phyclk_mipidphy1_rxclkesc0_user_p, MUX_SEL_DISP2,
+			16, 1),
+	MUX(CLK_MOUT_PHYCLK_MIPIDPHY0_BITCLKDIV8_USER,
+			"mout_phyclk_mipidphy0_bitclkdiv8_user",
+			mout_phyclk_mipidphy0_bitclkdiv8_user_p, MUX_SEL_DISP2,
+			12, 1),
+	MUX(CLK_MOUT_PHYCLK_MIPIDPHY0_RXCLKESC0_USER,
+			"mout_phyclk_mipidphy0_rxclkesc0_user",
+			mout_phyclk_mipidphy0_rxclkesc0_user_p, MUX_SEL_DISP2,
+			8, 1),
+	MUX(CLK_MOUT_PHYCLK_HDMIPHY_TMDS_CLKO_USER,
+			"mout_phyclk_hdmiphy_tmds_clko_user",
+			mout_phyclk_hdmiphy_tmds_clko_user_p, MUX_SEL_DISP2,
+			4, 1),
+	MUX(CLK_MOUT_PHYCLK_HDMIPHY_PIXEL_CLKO_USER,
+			"mout_phyclk_hdmiphy_pixel_clko_user",
+			mout_phyclk_hdmiphy_pixel_clko_user_p, MUX_SEL_DISP2,
+			0, 1),
+
+	/* MUX_SEL_DISP3 */
+	MUX(CLK_MOUT_SCLK_DSIM0, "mout_sclk_dsim0", mout_sclk_dsim0_p,
+			MUX_SEL_DISP3, 12, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_ECLK, "mout_sclk_decon_tv_eclk",
+			mout_sclk_decon_tv_eclk_p, MUX_SEL_DISP3, 8, 1),
+	MUX(CLK_MOUT_SCLK_DECON_VCLK, "mout_sclk_decon_vclk",
+			mout_sclk_decon_vclk_p, MUX_SEL_DISP3, 4, 1),
+	MUX(CLK_MOUT_SCLK_DECON_ECLK, "mout_sclk_decon_eclk",
+			mout_sclk_decon_eclk_p, MUX_SEL_DISP3, 0, 1),
+
+	/* MUX_SEL_DISP4 */
+	MUX(CLK_MOUT_SCLK_DSIM1_B_DISP, "mout_sclk_dsim1_b_disp",
+			mout_sclk_dsim1_b_disp_p, MUX_SEL_DISP4, 16, 1),
+	MUX(CLK_MOUT_SCLK_DSIM1_A_DISP, "mout_sclk_dsim1_a_disp",
+			mout_sclk_dsim1_a_disp_p, MUX_SEL_DISP4, 12, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_C_DISP,
+			"mout_sclk_decon_tv_vclk_c_disp",
+			mout_sclk_decon_tv_vclk_c_disp_p, MUX_SEL_DISP4, 8, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_B_DISP,
+			"mout_sclk_decon_tv_vclk_b_disp",
+			mout_sclk_decon_tv_vclk_b_disp_p, MUX_SEL_DISP4, 4, 1),
+	MUX(CLK_MOUT_SCLK_DECON_TV_VCLK_A_DISP,
+			"mout_sclk_decon_tv_vclk_a_disp",
+			mout_sclk_decon_tv_vclk_a_disp_p, MUX_SEL_DISP4, 0, 1),
+};
+
+static struct samsung_div_clock disp_div_clks[] __initdata = {
+	/* DIV_DISP */
+	DIV(CLK_DIV_SCLK_DSIM1_DISP, "div_sclk_dsim1_disp",
+			"mout_sclk_dsim1_b_disp", DIV_DISP, 24, 3),
+	DIV(CLK_DIV_SCLK_DECON_TV_VCLK_DISP, "div_sclk_decon_tv_vclk_disp",
+			"mout_sclk_decon_tv_vclk_c_disp", DIV_DISP, 20, 3),
+	DIV(CLK_DIV_SCLK_DSIM0_DISP, "div_sclk_dsim0_disp", "mout_sclk_dsim0",
+			DIV_DISP, 16, 3),
+	DIV(CLK_DIV_SCLK_DECON_TV_ECLK_DISP, "div_sclk_decon_tv_eclk_disp",
+			"mout_sclk_decon_tv_eclk", DIV_DISP, 12, 3),
+	DIV(CLK_DIV_SCLK_DECON_VCLK_DISP, "div_sclk_decon_vclk_disp",
+			"mout_sclk_decon_vclk", DIV_DISP, 8, 3),
+	DIV(CLK_DIV_SCLK_DECON_ECLK_DISP, "div_sclk_decon_eclk_disp",
+			"mout_sclk_decon_eclk", DIV_DISP, 4, 3),
+	DIV(CLK_DIV_PCLK_DISP, "div_pclk_disp", "mout_aclk_disp_333_user",
+			DIV_DISP, 0, 2),
+};
+
+static struct samsung_gate_clock disp_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_DISP0 */
+	GATE(CLK_ACLK_DECON_TV, "aclk_decon_tv", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP0, 2, 0, 0),
+	GATE(CLK_ACLK_DECON, "aclk_decon", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP0, 0, 0, 0),
+
+	/* ENABLE_ACLK_DISP1 */
+	GATE(CLK_ACLK_SMMU_TV1X, "aclk_smmu_tv1x", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP1, 25, 0, 0),
+	GATE(CLK_ACLK_SMMU_TV0X, "aclk_smmu_tv0x", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP1, 24, 0, 0),
+	GATE(CLK_ACLK_SMMU_DECON1X, "aclk_smmu_decon1x",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 23, 0, 0),
+	GATE(CLK_ACLK_SMMU_DECON0X, "aclk_smmu_decon0x",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 22, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_TV_M3, "aclk_bts_decon_tv_m3",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 21, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_TV_M2, "aclk_bts_decon_tv_m2",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 20, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_TV_M1, "aclk_bts_decon_tv_m1",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 19, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_TV_M0, "aclk-bts_decon_tv_m0",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 18, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_NM4, "aclk_bts_decon_nm4",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 17, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_NM3, "aclk_bts_decon_nm3",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 16, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_NM2, "aclk_bts_decon_nm2",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 15, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_NM1, "aclk_bts_decon_nm1",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 14, 0, 0),
+	GATE(CLK_ACLK_BTS_DECON_NM0, "aclk_bts_decon_nm0",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 13, 0, 0),
+	GATE(CLK_ACLK_AHB2APB_DISPSFR2P, "aclk_ahb2apb_dispsfr2p",
+			"div_pclk_disp", ENABLE_ACLK_DISP1,
+			12, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_DISPSFR1P, "aclk_ahb2apb_dispsfr1p",
+			"div_pclk_disp", ENABLE_ACLK_DISP1,
+			11, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_DISPSFR0P, "aclk_ahb2apb_dispsfr0p",
+			"div_pclk_disp", ENABLE_ACLK_DISP1,
+			10, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB_DISPH, "aclk_ahb_disph", "div_pclk_disp",
+			ENABLE_ACLK_DISP1, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_TV1X, "aclk_xiu_tv1x", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP1, 7, 0, 0),
+	GATE(CLK_ACLK_XIU_TV0X, "aclk_xiu_tv0x", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP1, 6, 0, 0),
+	GATE(CLK_ACLK_XIU_DECON1X, "aclk_xiu_decon1x",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 5, 0, 0),
+	GATE(CLK_ACLK_XIU_DECON0X, "aclk_xiu_decon0x",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 4, 0, 0),
+	GATE(CLK_ACLK_XIU_DISP1X, "aclk_xiu_disp1x", "mout_aclk_disp_333_user",
+			ENABLE_ACLK_DISP1, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_DISPNP_100, "aclk_xiu_dispnp_100", "div_pclk_disp",
+			ENABLE_ACLK_DISP1, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DISP1ND_333, "aclk_disp1nd_333",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1, 1,
+			CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_DISP0ND_333, "aclk_disp0nd_333",
+			"mout_aclk_disp_333_user", ENABLE_ACLK_DISP1,
+			0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_DISP */
+	GATE(CLK_PCLK_SMMU_TV1X, "pclk_smmu_tv1x", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 23, 0, 0),
+	GATE(CLK_PCLK_SMMU_TV0X, "pclk_smmu_tv0x", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 22, 0, 0),
+	GATE(CLK_PCLK_SMMU_DECON1X, "pclk_smmu_decon1x", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 21, 0, 0),
+	GATE(CLK_PCLK_SMMU_DECON0X, "pclk_smmu_decon0x", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 20, 0, 0),
+	GATE(CLK_PCLK_BTS_DECON_TV_M3, "pclk_bts_decon_tv_m3", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 19, 0, 0),
+	GATE(CLK_PCLK_BTS_DECON_TV_M2, "pclk_bts_decon_tv_m2", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 18, 0, 0),
+	GATE(CLK_PCLK_BTS_DECON_TV_M1, "pclk_bts_decon_tv_m1", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 17, 0, 0),
+	GATE(CLK_PCLK_BTS_DECON_TV_M0, "pclk_bts_decon_tv_m0", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 16, 0, 0),
+	GATE(CLK_PCLK_BTS_DECONM4, "pclk_bts_deconm4", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 15, 0, 0),
+	GATE(CLK_PCLK_BTS_DECONM3, "pclk_bts_deconm3", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 14, 0, 0),
+	GATE(CLK_PCLK_BTS_DECONM2, "pclk_bts_deconm2", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 13, 0, 0),
+	GATE(CLK_PCLK_BTS_DECONM1, "pclk_bts_deconm1", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 12, 0, 0),
+	GATE(CLK_PCLK_BTS_DECONM0, "pclk_bts_deconm0", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 11, 0, 0),
+	GATE(CLK_PCLK_MIC1, "pclk_mic1", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 10, 0, 0),
+	GATE(CLK_PCLK_PMU_DISP, "pclk_pmu_disp", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_DISP, "pclk_sysreg_disp", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_HDMIPHY, "pclk_hdmiphy", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 7, 0, 0),
+	GATE(CLK_PCLK_HDMI, "pclk_hdmi", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 6, 0, 0),
+	GATE(CLK_PCLK_MIC0, "pclk_mic0", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 5, 0, 0),
+	GATE(CLK_PCLK_DSIM1, "pclk_dsim1", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 3, 0, 0),
+	GATE(CLK_PCLK_DSIM0, "pclk_dsim0", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 2, 0, 0),
+	GATE(CLK_PCLK_DECON_TV, "pclk_decon_tv", "div_pclk_disp",
+			ENABLE_PCLK_DISP, 1, 0, 0),
+
+	/* ENABLE_SCLK_DISP */
+	GATE(CLK_PHYCLK_MIPIDPHY1_BITCLKDIV8, "phyclk_mipidphy1_bitclkdiv8",
+			"mout_phyclk_mipidphy1_bitclkdiv8_user",
+			ENABLE_SCLK_DISP, 26, 0, 0),
+	GATE(CLK_PHYCLK_MIPIDPHY1_RXCLKESC0, "phyclk_mipidphy1_rxclkesc0",
+			"mout_phyclk_mipidphy1_rxclkesc0_user",
+			ENABLE_SCLK_DISP, 25, 0, 0),
+	GATE(CLK_SCLK_RGB_TV_VCLK_TO_DSIM1, "sclk_rgb_tv_vclk_to_dsim1",
+			"sclk_rgb_tv_vclk", ENABLE_SCLK_DISP, 24, 0, 0),
+	GATE(CLK_SCLK_RGB_TV_VCLK_TO_MIC1, "sclk_rgb_tv_vclk_to_mic1",
+			"sclk_rgb_tv_vclk", ENABLE_SCLK_DISP, 23, 0, 0),
+	GATE(CLK_SCLK_DSIM1, "sclk_dsim1", "div_sclk_dsim1_disp",
+			ENABLE_SCLK_DISP, 22, 0, 0),
+	GATE(CLK_SCLK_DECON_TV_VCLK, "sclk_decon_tv_vclk",
+			"div_sclk_decon_tv_vclk_disp",
+			ENABLE_SCLK_DISP, 21, 0, 0),
+	GATE(CLK_PHYCLK_MIPIDPHY0_BITCLKDIV8, "phyclk_mipidphy0_bitclkdiv8",
+			"mout_phyclk_mipidphy0_bitclkdiv8_user",
+			ENABLE_SCLK_DISP, 15, 0, 0),
+	GATE(CLK_PHYCLK_MIPIDPHY0_RXCLKESC0, "phyclk_mipidphy0_rxclkesc0",
+			"mout_phyclk_mipidphy0_rxclkesc0_user",
+			ENABLE_SCLK_DISP, 14, 0, 0),
+	GATE(CLK_PHYCLK_HDMIPHY_TMDS_CLKO, "phyclk_hdmiphy_tmds_clko",
+			"mout_phyclk_hdmiphy_tmds_clko_user",
+			ENABLE_SCLK_DISP, 13, 0, 0),
+	GATE(CLK_PHYCLK_HDMI_PIXEL, "phyclk_hdmi_pixel",
+			"sclk_rgb_tv_vclk", ENABLE_SCLK_DISP, 12, 0, 0),
+	GATE(CLK_SCLK_RGB_VCLK_TO_SMIES, "sclk_rgb_vclk_to_smies",
+			"sclk_rgb_vclk", ENABLE_SCLK_DISP, 11, 0, 0),
+	GATE(CLK_SCLK_RGB_VCLK_TO_DSIM0, "sclk_rgb_vclk_to_dsim0",
+			"sclk_rgb_vclk", ENABLE_SCLK_DISP, 9, 0, 0),
+	GATE(CLK_SCLK_RGB_VCLK_TO_MIC0, "sclk_rgb_vclk_to_mic0",
+			"sclk_rgb_vclk", ENABLE_SCLK_DISP, 8, 0, 0),
+	GATE(CLK_SCLK_DSD, "sclk_dsd", "mout_sclk_dsd_user",
+			ENABLE_SCLK_DISP, 7, 0, 0),
+	GATE(CLK_SCLK_HDMI_SPDIF, "sclk_hdmi_spdif", "sclk_hdmi_spdif_disp",
+			ENABLE_SCLK_DISP, 6, 0, 0),
+	GATE(CLK_SCLK_DSIM0, "sclk_dsim0", "div_sclk_dsim0_disp",
+			ENABLE_SCLK_DISP, 5, 0, 0),
+	GATE(CLK_SCLK_DECON_TV_ECLK, "sclk_decon_tv_eclk",
+			"div_sclk_decon_tv_eclk_disp",
+			ENABLE_SCLK_DISP, 4, 0, 0),
+	GATE(CLK_SCLK_DECON_VCLK, "sclk_decon_vclk",
+			"div_sclk_decon_vclk_disp", ENABLE_SCLK_DISP, 3, 0, 0),
+	GATE(CLK_SCLK_DECON_ECLK, "sclk_decon_eclk",
+			"div_sclk_decon_eclk_disp", ENABLE_SCLK_DISP, 2, 0, 0),
+};
+
+static struct samsung_cmu_info disp_cmu_info __initdata = {
+	.pll_clks		= disp_pll_clks,
+	.nr_pll_clks		= ARRAY_SIZE(disp_pll_clks),
+	.mux_clks		= disp_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(disp_mux_clks),
+	.div_clks		= disp_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(disp_div_clks),
+	.gate_clks		= disp_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(disp_gate_clks),
+	.fixed_clks		= disp_fixed_clks,
+	.nr_fixed_clks		= ARRAY_SIZE(disp_fixed_clks),
+	.fixed_factor_clks	= disp_fixed_factor_clks,
+	.nr_fixed_factor_clks	= ARRAY_SIZE(disp_fixed_factor_clks),
+	.nr_clk_ids		= DISP_NR_CLK,
+	.clk_regs		= disp_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(disp_clk_regs),
+};
+
+static void __init exynos5433_cmu_disp_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &disp_cmu_info);
+}
+
+CLK_OF_DECLARE(exynos5433_cmu_disp, "samsung,exynos5433-cmu-disp",
+		exynos5433_cmu_disp_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 3fb1f32..9372b77 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -68,6 +68,7 @@
 #define CLK_MOUT_SCLK_SPDIF		61
 #define CLK_MOUT_SCLK_AUDIO1		62
 #define CLK_MOUT_SCLK_AUDIO0		63
+#define CLK_MOUT_SCLK_HDMI_SPDIF	64
 
 #define CLK_DIV_ACLK_FSYS_200		100
 #define CLK_DIV_ACLK_IMEM_SSSX		101
@@ -337,8 +338,9 @@
 #define CLK_SCLK_BUS_PLL		198
 #define CLK_SCLK_BUS_PLL_APOLLO		199
 #define CLK_SCLK_BUS_PLL_ATLAS		200
+#define CLK_SCLK_HDMI_SPDIF_DISP	201
 
-#define MIF_NR_CLK			201
+#define MIF_NR_CLK			202
 
 /* CMU_PERIC */
 #define CLK_PCLK_SPI2			1
@@ -514,4 +516,114 @@
 
 #define G2D_NR_CLK			27
 
+/* CMU_DISP */
+#define CLK_FOUT_DISP_PLL				1
+
+#define CLK_MOUT_DISP_PLL				2
+#define CLK_MOUT_SCLK_DSIM1_USER			3
+#define CLK_MOUT_SCLK_DSIM0_USER			4
+#define CLK_MOUT_SCLK_DSD_USER				5
+#define CLK_MOUT_SCLK_DECON_TV_ECLK_USER		6
+#define CLK_MOUT_SCLK_DECON_VCLK_USER			7
+#define CLK_MOUT_SCLK_DECON_ECLK_USER			8
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_USER		9
+#define CLK_MOUT_ACLK_DISP_333_USER			10
+#define CLK_MOUT_PHYCLK_MIPIDPHY1_BITCLKDIV8_USER	11
+#define CLK_MOUT_PHYCLK_MIPIDPHY1_RXCLKESC0_USER	12
+#define CLK_MOUT_PHYCLK_MIPIDPHY0_BITCLKDIV8_USER	13
+#define CLK_MOUT_PHYCLK_MIPIDPHY0_RXCLKESC0_USER	14
+#define CLK_MOUT_PHYCLK_HDMIPHY_TMDS_CLKO_USER		15
+#define CLK_MOUT_PHYCLK_HDMIPHY_PIXEL_CLKO_USER		16
+#define CLK_MOUT_SCLK_DSIM0				17
+#define CLK_MOUT_SCLK_DECON_TV_ECLK			18
+#define CLK_MOUT_SCLK_DECON_VCLK			19
+#define CLK_MOUT_SCLK_DECON_ECLK			20
+#define CLK_MOUT_SCLK_DSIM1_B_DISP			21
+#define CLK_MOUT_SCLK_DSIM1_A_DISP			22
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_C_DISP		23
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_B_DISP		24
+#define CLK_MOUT_SCLK_DECON_TV_VCLK_A_DISP		25
+
+#define CLK_DIV_SCLK_DSIM1_DISP				30
+#define CLK_DIV_SCLK_DECON_TV_VCLK_DISP			31
+#define CLK_DIV_SCLK_DSIM0_DISP				32
+#define CLK_DIV_SCLK_DECON_TV_ECLK_DISP			33
+#define CLK_DIV_SCLK_DECON_VCLK_DISP			34
+#define CLK_DIV_SCLK_DECON_ECLK_DISP			35
+#define CLK_DIV_PCLK_DISP				36
+
+#define CLK_ACLK_DECON_TV				40
+#define CLK_ACLK_DECON					41
+#define CLK_ACLK_SMMU_TV1X				42
+#define CLK_ACLK_SMMU_TV0X				43
+#define CLK_ACLK_SMMU_DECON1X				44
+#define CLK_ACLK_SMMU_DECON0X				45
+#define CLK_ACLK_BTS_DECON_TV_M3			46
+#define CLK_ACLK_BTS_DECON_TV_M2			47
+#define CLK_ACLK_BTS_DECON_TV_M1			48
+#define CLK_ACLK_BTS_DECON_TV_M0			49
+#define CLK_ACLK_BTS_DECON_NM4				50
+#define CLK_ACLK_BTS_DECON_NM3				51
+#define CLK_ACLK_BTS_DECON_NM2				52
+#define CLK_ACLK_BTS_DECON_NM1				53
+#define CLK_ACLK_BTS_DECON_NM0				54
+#define CLK_ACLK_AHB2APB_DISPSFR2P			55
+#define CLK_ACLK_AHB2APB_DISPSFR1P			56
+#define CLK_ACLK_AHB2APB_DISPSFR0P			57
+#define CLK_ACLK_AHB_DISPH				58
+#define CLK_ACLK_XIU_TV1X				59
+#define CLK_ACLK_XIU_TV0X				60
+#define CLK_ACLK_XIU_DECON1X				61
+#define CLK_ACLK_XIU_DECON0X				62
+#define CLK_ACLK_XIU_DISP1X				63
+#define CLK_ACLK_XIU_DISPNP_100				64
+#define CLK_ACLK_DISP1ND_333				65
+#define CLK_ACLK_DISP0ND_333				66
+#define CLK_PCLK_SMMU_TV1X				67
+#define CLK_PCLK_SMMU_TV0X				68
+#define CLK_PCLK_SMMU_DECON1X				69
+#define CLK_PCLK_SMMU_DECON0X				70
+#define CLK_PCLK_BTS_DECON_TV_M3			71
+#define CLK_PCLK_BTS_DECON_TV_M2			72
+#define CLK_PCLK_BTS_DECON_TV_M1			73
+#define CLK_PCLK_BTS_DECON_TV_M0			74
+#define CLK_PCLK_BTS_DECONM4				75
+#define CLK_PCLK_BTS_DECONM3				76
+#define CLK_PCLK_BTS_DECONM2				77
+#define CLK_PCLK_BTS_DECONM1				78
+#define CLK_PCLK_BTS_DECONM0				79
+#define CLK_PCLK_MIC1					80
+#define CLK_PCLK_PMU_DISP				81
+#define CLK_PCLK_SYSREG_DISP				82
+#define CLK_PCLK_HDMIPHY				83
+#define CLK_PCLK_HDMI					84
+#define CLK_PCLK_MIC0					85
+#define CLK_PCLK_DSIM1					86
+#define CLK_PCLK_DSIM0					87
+#define CLK_PCLK_DECON_TV				88
+#define CLK_PHYCLK_MIPIDPHY1_BITCLKDIV8			89
+#define CLK_PHYCLK_MIPIDPHY1_RXCLKESC0			90
+#define CLK_SCLK_RGB_TV_VCLK_TO_DSIM1			91
+#define CLK_SCLK_RGB_TV_VCLK_TO_MIC1			92
+#define CLK_SCLK_DSIM1					93
+#define CLK_SCLK_DECON_TV_VCLK				94
+#define CLK_PHYCLK_MIPIDPHY0_BITCLKDIV8			95
+#define CLK_PHYCLK_MIPIDPHY0_RXCLKESC0			96
+#define CLK_PHYCLK_HDMIPHY_TMDS_CLKO			97
+#define CLK_PHYCLK_HDMI_PIXEL				98
+#define CLK_SCLK_RGB_VCLK_TO_SMIES			99
+#define CLK_SCLK_FREQ_DET_DISP_PLL			100
+#define CLK_SCLK_RGB_VCLK_TO_DSIM0			101
+#define CLK_SCLK_RGB_VCLK_TO_MIC0			102
+#define CLK_SCLK_DSD					103
+#define CLK_SCLK_HDMI_SPDIF				104
+#define CLK_SCLK_DSIM0					105
+#define CLK_SCLK_DECON_TV_ECLK				106
+#define CLK_SCLK_DECON_VCLK				107
+#define CLK_SCLK_DECON_ECLK				108
+#define CLK_SCLK_RGB_VCLK				109
+#define CLK_SCLK_RGB_TV_VCLK				110
+
+#define DISP_NR_CLK					111
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

