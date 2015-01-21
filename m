Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbbAUG1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:27:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbAUG1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:27:07 -0500
X-AuditID: cbfee691-f79b86d000004a5a-e0-54bf46b49047
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/12] clk: samsung: exynos5433: Add clocks for CMU_G2D
 domain
Date: Wed, 21 Jan 2015 15:26:54 +0900
Message-id: <1421821618-8627-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWyRsSkQHeL2/4Qg923BSwu79e2uP7lOavF
	pPsTWCz6H79mtri8aw6bxYzz+5gsnk64yGaxaOsXdovDb9pZLWZMfslmsWrXH0YHbo+ds+6y
	e2xa1cnmcefaHjaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyji3zq2gO7ji97N9TA2MP9y6
	GDk5JARMJB796maFsMUkLtxbz9bFyMUhJLCUUeLIhUtACQ6wohkPhUFqhAQWMUr0tRZB1DQx
	SbScbWMBSbAJaEnsf3GDDaReRMBQ4uYhJZAaZoE3jBLd73+DLRAWCJZ4u/IqmM0ioCpxads/
	NhCbV8BFYm/7HqgjFCSWLZ8JtpdTwFWi/TYTiCkEVHJuSwlExSZ2iWONNhBTBCS+TT7EAnGl
	rMSmA8wQJZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmAMnP73bOIO
	xvsHrA8xCnAwKvHwvlDcHyLEmlhWXJl7iNEUaMNEZinR5HxgpOWVxBsamxlZmJqYGhuZW5op
	ifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCo7bzh+EnhX5cPSz/ZvtREQd/y4TT5
	kI/7xVVNd1zbY6ETs2ipWU9w9vFKZicxdfXPYZPErjoYbTG6b3jf5ypHQFmO2frbRj+4C5uu
	TdjGznOMTVZXslb+Zdsv7ZbO//VfN/5/5Mdx5JzjndX5cxw0JFcc3+TzZuq3joy2X2fUL3Wp
	+VacLO5XYinOSDTUYi4qTgQAPn1VZ3wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jAd0tbvtDDJ5eZLW4vF/b4vqX56wW
	k+5PYLHof/ya2eLyrjlsFjPO72OyeDrhIpvFoq1f2C0Ov2lntZgx+SWbxapdfxgduD12zrrL
	7rFpVSebx51re9g8+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhDWPGuXVuBd3BFb+f7WNqYPzh1sXIwSEhYCIx46FwFyMnkCkmceHeejYQW0hgEaNEX2tR
	FyMXkN3EJNFyto0FJMEmoCWx/8UNNpBeEQFDiZuHlEBqmAXeMEp0v//NClIjLBAs8XblVTCb
	RUBV4tK2f2BDeQVcJPa272GFWKYgsWz5TFaQOZwCrhLtt5lATCGgknNbSiYw8i5gZFjFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJERxjz6R2MK5ssDjEKMDBqMTD+0Jxf4gQa2JZcWXuIUYJ
	DmYlEV5FCaAQb0piZVVqUX58UWlOavEhRlOgmyYyS4km5wPjP68k3tDYxMzI0sjc0MLI2FxJ
	nFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgfHC3ZqbTu9N9CLbpt3+e/Qdr/zrRcG+Xo/Yuaqj
	wm/POV8mzGHIo/ehROzPTPbYmdMe2RRG8kx45s745Irm5/+MDgcEfNa9/liTupn73nKpJU5B
	hjf/Fz7letoR9YMxSfL8DfbDLHc774rXRIqutJc3KtVWTs3elBTLfui6qqkLH/NaV2mJ50os
	xRmJhlrMRcWJAKzL16vHAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds ths mux/divider/gate clocks of CMU_G2D domain which includes
G2D/MDMA IPs. The CMU_G2D must need the clocks related to G2D by providing
CMU_TOP domain. So, this patch add several clocks for G2D from CMU_TOP domain.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
 drivers/clk/samsung/clk-exynos5433.c               | 146 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  42 +++++-
 3 files changed, 195 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
index 72cd0ba..27dd77b 100644
--- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -19,6 +19,8 @@ Required Properties:
     which generates clocks for PMU/TMU/MCT/WDT/RTC/SECKEY/TZPC IPs.
   - "samsung,exynos5433-cmu-fsys"  - clock controller compatible for CMU_FSYS
     which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
+  - "samsung,exynos5433-cmu-g2d"   - clock controller compatible for CMU_G2D
+    which generates clocks for G2D/MDMA IPs.
 
 - reg: physical base address of the controller and length of memory mapped
   region.
@@ -70,6 +72,12 @@ Example 1: Examples of clock controller nodes are listed below.
 		#clock-cells = <1>;
 	};
 
+	cmu_g2d: clock-controller@0x12460000 {
+		compatible = "samsung,exynos5433-cmu-g2d";
+		reg = <0x12460000 0x0b08>;
+		#clock-cells = <1>;
+	};
+
 Example 2: UART controller node that consumes the clock generated by the clock
 	   controller.
 
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 88e8651..9754c3d 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -398,6 +398,20 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
 };
 
 static struct samsung_div_clock top_div_clks[] __initdata = {
+	/* DIV_TOP1 */
+	DIV(CLK_DIV_ACLK_GSCL_111, "div_aclk_gscl_111", "mout_aclk_gscl_333",
+			DIV_TOP1, 28, 3),
+	DIV(CLK_DIV_ACLK_GSCL_333, "div_aclk_gscl_333", "mout_aclk_gscl_333",
+			DIV_TOP1, 24, 3),
+	DIV(CLK_DIV_ACLK_HEVC_400, "div_aclk_hevc_400", "mout_aclk_hevc_400",
+			DIV_TOP1, 20, 3),
+	DIV(CLK_DIV_ACLK_MFC_400, "div_aclk_mfc_400", "mout_aclk_mfc_400_c",
+			DIV_TOP1, 12, 3),
+	DIV(CLK_DIV_ACLK_G2D_266, "div_aclk_g2d_266", "mout_bus_pll_user",
+			DIV_TOP1, 8, 3),
+	DIV(CLK_DIV_ACLK_G2D_400, "div_aclk_g2d_400", "mout_aclk_g2d_400_b",
+			DIV_TOP1, 0, 3),
+
 	/* DIV_TOP2 */
 	DIV(CLK_DIV_ACLK_FSYS_200, "div_aclk_fsys_200", "mout_bus_pll_user",
 			DIV_TOP2, 0, 3),
@@ -490,6 +504,12 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 	GATE(CLK_ACLK_FSYS_200, "aclk_fsys_200", "div_aclk_fsys_200",
 			ENABLE_ACLK_TOP, 18,
 			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2D_266, "aclk_g2d_266", "div_aclk_g2d_266",
+			ENABLE_ACLK_TOP, 2,
+			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2D_400, "aclk_g2d_400", "div_aclk_g2d_400",
+			ENABLE_ACLK_TOP, 0,
+			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
 
 	/* ENABLE_SCLK_TOP_FSYS */
 	GATE(CLK_SCLK_MMC2_FSYS, "sclk_mmc2_fsys", "div_sclk_mmc2_b",
@@ -1277,3 +1297,129 @@ static void __init exynos5433_cmu_fsys_init(struct device_node *np)
 
 CLK_OF_DECLARE(exynos5433_cmu_fsys, "samsung,exynos5433-cmu-fsys",
 		exynos5433_cmu_fsys_init);
+
+/*
+ * Register offset definitions for CMU_G2D
+ */
+#define MUX_SEL_G2D0				0x0200
+#define MUX_SEL_ENABLE_G2D0			0x0300
+#define MUX_SEL_STAT_G2D0			0x0400
+#define DIV_G2D					0x0600
+#define DIV_STAT_G2D				0x0700
+#define DIV_ENABLE_ACLK_G2D			0x0800
+#define DIV_ENABLE_ACLK_G2D_SECURE_SMMU_G2D	0x0804
+#define DIV_ENABLE_PCLK_G2D			0x0900
+#define DIV_ENABLE_PCLK_G2D_SECURE_SMMU_G2D	0x0904
+#define DIV_ENABLE_IP_G2D0			0x0b00
+#define DIV_ENABLE_IP_G2D1			0x0b04
+#define DIV_ENABLE_IP_G2D_SECURE_SMMU_G2D	0x0b08
+
+static unsigned long g2d_clk_regs[] __initdata = {
+	MUX_SEL_G2D0,
+	MUX_SEL_ENABLE_G2D0,
+	MUX_SEL_STAT_G2D0,
+	DIV_G2D,
+	DIV_STAT_G2D,
+	DIV_ENABLE_ACLK_G2D,
+	DIV_ENABLE_ACLK_G2D_SECURE_SMMU_G2D,
+	DIV_ENABLE_PCLK_G2D,
+	DIV_ENABLE_PCLK_G2D_SECURE_SMMU_G2D,
+	DIV_ENABLE_IP_G2D0,
+	DIV_ENABLE_IP_G2D1,
+	DIV_ENABLE_IP_G2D_SECURE_SMMU_G2D,
+};
+
+/* list of all parent clock list */
+PNAME(mout_aclk_g2d_266_user_p)		= { "fin_pll", "aclk_g2d_266", };
+PNAME(mout_aclk_g2d_400_user_p)		= { "fin_pll", "aclk_g2d_400", };
+
+static struct samsung_mux_clock g2d_mux_clks[] __initdata = {
+	/* MUX_SEL_G2D0 */
+	MUX(CLK_MUX_ACLK_G2D_266_USER, "mout_aclk_g2d_266_user",
+			mout_aclk_g2d_266_user_p, MUX_SEL_G2D0, 4, 1),
+	MUX(CLK_MUX_ACLK_G2D_400_USER, "mout_aclk_g2d_400_user",
+			mout_aclk_g2d_400_user_p, MUX_SEL_G2D0, 0, 1),
+};
+
+static struct samsung_div_clock g2d_div_clks[] __initdata = {
+	/* DIV_G2D */
+	DIV(CLK_DIV_PCLK_G2D, "div_pclk_g2d", "mout_aclk_g2d_266_user",
+			DIV_G2D, 0, 2),
+};
+
+static struct samsung_gate_clock g2d_gate_clks[] __initdata = {
+	/* DIV_ENABLE_ACLK_G2D */
+	GATE(CLK_ACLK_SMMU_MDMA1, "aclk_smmu_mdma1", "mout_aclk_g2d_266_user",
+			DIV_ENABLE_ACLK_G2D, 12, 0, 0),
+	GATE(CLK_ACLK_BTS_MDMA1, "aclk_bts_mdam1", "mout_aclk_g2d_266_user",
+			DIV_ENABLE_ACLK_G2D, 11, 0, 0),
+	GATE(CLK_ACLK_BTS_G2D, "aclk_bts_g2d", "mout_aclk_g2d_400_user",
+			DIV_ENABLE_ACLK_G2D, 10, 0, 0),
+	GATE(CLK_ACLK_ALB_G2D, "aclk_alb_g2d", "mout_aclk_g2d_400_user",
+			DIV_ENABLE_ACLK_G2D, 9, 0, 0),
+	GATE(CLK_ACLK_AXIUS_G2DX, "aclk_axius_g2dx", "mout_aclk_g2d_400_user",
+			DIV_ENABLE_ACLK_G2D, 8, 0, 0),
+	GATE(CLK_ACLK_ASYNCAXI_SYSX, "aclk_asyncaxi_sysx",
+			"mout_aclk_g2d_400_user", DIV_ENABLE_ACLK_G2D,
+			7, 0, 0),
+	GATE(CLK_ACLK_AHB2APB_G2D1P, "aclk_ahb2apb_g2d1p", "div_pclk_g2d",
+			DIV_ENABLE_ACLK_G2D, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_AHB2APB_G2D0P, "aclk_ahb2apb_g2d0p", "div_pclk_g2d",
+			DIV_ENABLE_ACLK_G2D, 5, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_G2DX, "aclk_xiu_g2dx", "mout_aclk_g2d_400_user",
+			DIV_ENABLE_ACLK_G2D, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2DNP_133, "aclk_g2dnp_133", "div_pclk_g2d",
+			DIV_ENABLE_ACLK_G2D, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2DND_400, "aclk_g2dnd_400", "mout_aclk_g2d_400_user",
+			DIV_ENABLE_ACLK_G2D, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_MDMA1, "aclk_mdma1", "mout_aclk_g2d_266_user",
+			DIV_ENABLE_ACLK_G2D, 1, 0, 0),
+	GATE(CLK_ACLK_G2D, "aclk_g2d", "mout_aclk_g2d_400_user",
+			DIV_ENABLE_ACLK_G2D, 0, 0, 0),
+
+	/* DIV_ENABLE_ACLK_G2D_SECURE_SMMU_G2D */
+	GATE(CLK_ACLK_SMMU_G2D, "aclk_smmu_g2d", "mout_aclk_g2d_400_user",
+		DIV_ENABLE_ACLK_G2D_SECURE_SMMU_G2D, 0, 0, 0),
+
+	/* DIV_ENABLE_PCLK_G2D */
+	GATE(CLK_PCLK_SMMU_MDMA1, "pclk_smmu_mdma1", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 7, 0, 0),
+	GATE(CLK_PCLK_BTS_MDMA1, "pclk_bts_mdam1", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 6, 0, 0),
+	GATE(CLK_PCLK_BTS_G2D, "pclk_bts_g2d", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 5, 0, 0),
+	GATE(CLK_PCLK_ALB_G2D, "pclk_alb_g2d", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 4, 0, 0),
+	GATE(CLK_PCLK_ASYNCAXI_SYSX, "pclk_asyncaxi_sysx", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 3, 0, 0),
+	GATE(CLK_PCLK_PMU_G2D, "pclk_pmu_g2d", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_G2D, "pclk_sysreg_g2d", "div_pclk_g2d",
+			DIV_ENABLE_PCLK_G2D, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_G2D, "pclk_g2d", "div_pclk_g2d", DIV_ENABLE_PCLK_G2D,
+			0, 0, 0),
+
+	/* DIV_ENABLE_PCLK_G2D_SECURE_SMMU_G2D */
+	GATE(CLK_PCLK_SMMU_G2D, "pclk_smmu_g2d", "div_pclk_g2d",
+		DIV_ENABLE_PCLK_G2D_SECURE_SMMU_G2D, 0, 0, 0),
+};
+
+static struct samsung_cmu_info g2d_cmu_info __initdata = {
+	.mux_clks		= g2d_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(g2d_mux_clks),
+	.div_clks		= g2d_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(g2d_div_clks),
+	.gate_clks		= g2d_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(g2d_gate_clks),
+	.nr_clk_ids		= G2D_NR_CLK,
+	.clk_regs		= g2d_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(g2d_clk_regs),
+};
+
+static void __init exynos5433_cmu_g2d_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &g2d_cmu_info);
+}
+
+CLK_OF_DECLARE(exynos5433_cmu_g2d, "samsung,exynos5433-cmu-g2d",
+		exynos5433_cmu_g2d_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index e9fc243..8e423a6 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -100,6 +100,12 @@
 #define CLK_DIV_SCLK_PCM1		128
 #define CLK_DIV_SCLK_AUDIO1		129
 #define CLK_DIV_SCLK_AUDIO0		130
+#define CLK_DIV_ACLK_GSCL_111		131
+#define CLK_DIV_ACLK_GSCL_333		132
+#define CLK_DIV_ACLK_HEVC_400		133
+#define CLK_DIV_ACLK_MFC_400		134
+#define CLK_DIV_ACLK_G2D_266		135
+#define CLK_DIV_ACLK_G2D_400		136
 
 #define CLK_ACLK_PERIC_66		200
 #define CLK_ACLK_PERIS_66		201
@@ -121,8 +127,10 @@
 #define CLK_SCLK_SLIMBUS		217
 #define CLK_SCLK_AUDIO1			218
 #define CLK_SCLK_AUDIO0			219
+#define CLK_ACLK_G2D_266		220
+#define CLK_ACLK_G2D_400		221
 
-#define TOP_NR_CLK			220
+#define TOP_NR_CLK			222
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
@@ -286,4 +294,36 @@
 
 #define FSYS_NR_CLK			66
 
+/* CMU_G2D */
+#define CLK_MUX_ACLK_G2D_266_USER	1
+#define CLK_MUX_ACLK_G2D_400_USER	2
+
+#define CLK_DIV_PCLK_G2D		3
+
+#define CLK_ACLK_SMMU_MDMA1		4
+#define CLK_ACLK_BTS_MDMA1		5
+#define CLK_ACLK_BTS_G2D		6
+#define CLK_ACLK_ALB_G2D		7
+#define CLK_ACLK_AXIUS_G2DX		8
+#define CLK_ACLK_ASYNCAXI_SYSX		9
+#define CLK_ACLK_AHB2APB_G2D1P		10
+#define CLK_ACLK_AHB2APB_G2D0P		11
+#define CLK_ACLK_XIU_G2DX		12
+#define CLK_ACLK_G2DNP_133		13
+#define CLK_ACLK_G2DND_400		14
+#define CLK_ACLK_MDMA1			15
+#define CLK_ACLK_G2D			16
+#define CLK_ACLK_SMMU_G2D		17
+#define CLK_PCLK_SMMU_MDMA1		18
+#define CLK_PCLK_BTS_MDMA1		19
+#define CLK_PCLK_BTS_G2D		20
+#define CLK_PCLK_ALB_G2D		21
+#define CLK_PCLK_ASYNCAXI_SYSX		22
+#define CLK_PCLK_PMU_G2D		23
+#define CLK_PCLK_SYSREG_G2D		24
+#define CLK_PCLK_G2D			25
+#define CLK_PCLK_SMMU_G2D		26
+
+#define G2D_NR_CLK			27
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

