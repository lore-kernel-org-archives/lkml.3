Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaLBI4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:56:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLBIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:05 -0500
X-AuditID: cbfee691-f79b86d000004a5a-98-547d7d37fb39
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
Subject: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_G3D domain
Date: Tue, 02 Dec 2014 17:49:48 +0900
Message-id: <1417510196-6714-12-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUNe8tjbEYOZXeYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVcefiS
	sWC5VcWOfycZGxgnG3YxcnJICJhILFz3hRXCFpO4cG89WxcjF4eQwFJGiTdL3zJ1MXKAFS3Y
	kgsRn84oMefvRhYIp4lJ4sGNDYwg3WwCWhL7X9xgA7FFBJwlGqY2MoEUMQu8YZbYc383C0hC
	WMBPonndLmaQqSwCqhIrv7GDhHkFXCU+zX3HCHGFgsSy5TPBLuIEined6QOrERJwkfjV+pEd
	ZKaEwEwOiXc7PoHNZBEQkPg2+RALxKWyEpsOMEPMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KL
	TPWKE3OLS/PS9ZLzczcxAqPx9L9nE3cw3j9gfYhRgINRiYf3xPmaECHWxLLiytxDjKZAGyYy
	S4km5wNjPq8k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	Bka+rMeJd1s39Jf9POG4u7m1eoPHXr0docmOofK2DKdURKce8VU/qBEnZ8r3xtGgLYffbt6b
	rjdnTLbev7HQgX+G0bw6rRl7D55cUbzO8sGPwF2f5u3qNVRkWXfeNmXNo7Ks1GzVeGa/Q411
	WY1tAs2sFXqLn84rZi9p+Xd1z9K3Wx7M89oep6DEUpyRaKjFXFScCABc3ByBwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV3z2toQgw1bRCwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYx48rDl4wFy60qdvw7ydjAONmwi5GDQ0LARGLBltwuRk4gU0zi
	wr31bF2MXBxCAtMZJeb83cgC4TQxSTy4sYERpIpNQEti/4sbbCC2iICzRMPURiaQImaBN8wS
	e+7vZgFJCAv4STSv28UMsoFFQFVi5Td2kDCvgKvEp7nvGCG2KUgsWz6TFcTmBIp3nekDqxES
	cJH41fqRfQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwbH+TGoH48oGi0OMAhyM
	Sjy8J87XhAixJpYVV+YeYpTgYFYS4f1lXBsixJuSWFmVWpQfX1Sak1p8iNEU6KiJzFKiyfnA
	NJRXEm9obGJmZGlkbmhhZGyuJM5742ZuiJBAemJJanZqakFqEUwfEwenVANj6a6bwdsm258s
	35Bu/Kx+hbg9v9qn4p1pxQsbnObofuG/rVy62D42Yd9y699zLny0vmKU8yxZceMhaYf1bBNO
	hSz1r71vdirw2fUQFY16pnvMsV5rvrxo5nH+t9pupzzrQ2EDza+bKv/eYHJbdt1XhydROsZe
	arP1eTfOr3eEChNunbZM0exXYinOSDTUYi4qTgQAMHoTOQsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mux/divider/gate clocks for CMU_G3D domain which contains
the clocks for GPU(3D Graphics Engine).

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
 drivers/clk/samsung/clk-exynos5433.c               | 127 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  25 ++++
 3 files changed, 160 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
index 03ae40a..589ed93 100644
--- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -28,6 +28,8 @@ Required Properties:
   - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
     and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
     which generates global data buses clock and global peripheral buses clock.
+  - "samsung,exynos5433-cmu-g3d"  - clock controller compatible for CMU_G3D
+    which generates clocks for 3D Graphics Engine IP.
 
 - reg: physical base address of the controller and length of memory mapped
   region.
@@ -115,6 +117,12 @@ Example 1: Examples of clock controller nodes are listed below.
 		#clock-cells = <1>;
 	};
 
+	cmu_g3d: clock-controller@0x14aa0000 {
+		compatible = "samsung,exynos5433-cmu-g3d";
+		reg = <0x14aa0000 0x1000>;
+		#clock-cells = <1>;
+	};
+
 Example 2: UART controller node that consumes the clock generated by the clock
 	   controller.
 
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index e2b7ea6..a7f5feb 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -3096,3 +3096,130 @@ CLK_OF_DECLARE(exynos5433_cmu_bus##id,					\
 exynos5433_cmu_bus_init(0);
 exynos5433_cmu_bus_init(1);
 exynos5433_cmu_bus_init(2);
+
+/*
+ * Register offset definitions for CMU_G3D
+ */
+#define G3D_PLL_LOCK			0x0000
+#define G3D_PLL_CON0			0x0100
+#define G3D_PLL_CON1			0x0104
+#define G3D_PLL_FREQ_DET		0x010c
+#define MUX_SEL_G3D			0x0200
+#define MUX_ENABLE_G3D			0x0300
+#define MUX_STAT_G3D			0x0400
+#define DIV_G3D				0x0600
+#define DIV_G3D_PLL_FREQ_DET		0x0604
+#define DIV_STAT_G3D			0x0700
+#define DIV_STAT_G3D_PLL_FREQ_DET	0x0704
+#define ENABLE_ACLK_G3D			0x0800
+#define ENABLE_PCLK_G3D			0x0900
+#define ENABLE_SCLK_G3D			0x0a00
+#define ENABLE_IP_G3D0			0x0b00
+#define ENABLE_IP_G3D1			0x0b04
+#define CLKOUT_CMU_G3D			0x0c00
+#define CLKOUT_CMU_G3D_DIV_STAT		0x0c04
+#define CLK_STOPCTRL			0x1000
+
+static unsigned long g3d_clk_regs[] __initdata = {
+	G3D_PLL_LOCK,
+	G3D_PLL_CON0,
+	G3D_PLL_CON1,
+	G3D_PLL_FREQ_DET,
+	MUX_SEL_G3D,
+	MUX_ENABLE_G3D,
+	MUX_STAT_G3D,
+	DIV_G3D,
+	DIV_G3D_PLL_FREQ_DET,
+	DIV_STAT_G3D,
+	DIV_STAT_G3D_PLL_FREQ_DET,
+	ENABLE_ACLK_G3D,
+	ENABLE_PCLK_G3D,
+	ENABLE_SCLK_G3D,
+	ENABLE_IP_G3D0,
+	ENABLE_IP_G3D1,
+	CLKOUT_CMU_G3D,
+	CLKOUT_CMU_G3D_DIV_STAT,
+	CLK_STOPCTRL,
+};
+
+/* list of all parent clock list */
+PNAME(mout_aclk_g3d_400_p)	= { "mout_g3d_pll", "aclk_g3d_400", };
+PNAME(mout_g3d_pll_p)		= { "fin_pll", "fout_g3d_pll", };
+
+static struct samsung_pll_clock g3d_pll_clks[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_G3D_PLL, "fout_g3d_pll", "fin_pll",
+		G3D_PLL_LOCK, G3D_PLL_CON0, exynos5443_pll_rates),
+};
+
+static struct samsung_mux_clock g3d_mux_clks[] __initdata = {
+	/* MUX_SEL_G3D */
+	MUX(CLK_MOUT_ACLK_G3D_400, "mout_aclk_g3d_400", mout_aclk_g3d_400_p,
+			MUX_SEL_G3D, 8, 1),
+	MUX(CLK_MOUT_G3D_PLL, "mout_g3d_pll", mout_g3d_pll_p,
+			MUX_SEL_G3D, 0, 1),
+};
+
+static struct samsung_div_clock g3d_div_clks[] __initdata = {
+	/* DIV_G3D */
+	DIV(CLK_DIV_SCLK_HPM_G3D, "div_sclk_hpm_g3d", "mout_g3d_pll", DIV_G3D,
+			8, 2),
+	DIV(CLK_DIV_PCLK_G3D, "div_pclk_g3d", "div_aclk_g3d", DIV_G3D,
+			4, 3),
+	DIV(CLK_DIV_ACLK_G3D, "div_aclk_g3d", "mout_aclk_g3d_400", DIV_G3D,
+			0, 3),
+};
+
+static struct samsung_gate_clock g3d_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_G3D */
+	GATE(CLK_ACLK_BTS_G3D1, "aclk_bts_g3d1", "div_aclk_g3d",
+			ENABLE_ACLK_G3D, 7, 0, 0),
+	GATE(CLK_ACLK_BTS_G3D0, "aclk_bts_g3d0", "div_aclk_g3d",
+			ENABLE_ACLK_G3D, 6, 0, 0),
+	GATE(CLK_ACLK_ASYNCAPBS_G3D, "aclk_asyncapbs_g3d", "div_pclk_g3d",
+			ENABLE_ACLK_G3D, 5, 0, 0),
+	GATE(CLK_ACLK_ASYNCAPBM_G3D, "aclk_asyncapbm_g3d", "div_aclk_g3d",
+			ENABLE_ACLK_G3D, 4, 0, 0),
+	GATE(CLK_ACLK_AHB2APB_G3DP, "aclk_ahb2apb_g3dp", "div_pclk_g3d",
+			ENABLE_ACLK_G3D, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G3DNP_150, "aclk_g3dnp_150", "div_pclk_g3d",
+			ENABLE_ACLK_G3D, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G3DND_600, "aclk_g3dnd_600", "div_aclk_g3d",
+			ENABLE_ACLK_G3D, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G3D, "aclk_g3d", "div_aclk_g3d",
+			ENABLE_ACLK_G3D, 0, 0, 0),
+
+	/* ENABLE_PCLK_G3D */
+	GATE(CLK_PCLK_BTS_G3D1, "pclk_bts_g3d1", "div_pclk_g3d",
+			ENABLE_PCLK_G3D, 3, 0, 0),
+	GATE(CLK_PCLK_BTS_G3D0, "pclk_bts_g3d0", "div_pclk_g3d",
+			ENABLE_PCLK_G3D, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_G3D, "pclk_pmu_g3d", "div_pclk_g3d",
+			ENABLE_PCLK_G3D, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_G3D, "pclk_sysreg_g3d", "div_pclk_g3d",
+			ENABLE_PCLK_G3D, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_SCLK_G3D */
+	GATE(CLK_SCLK_HPM_G3D, "sclk_hpm_g3d", "div_sclk_hpm_g3d",
+			ENABLE_SCLK_G3D, 0, 0, 0),
+};
+
+static struct samsung_cmu_info g3d_cmu_info __initdata = {
+	.pll_clks		= g3d_pll_clks,
+	.nr_pll_clks		= ARRAY_SIZE(g3d_pll_clks),
+	.mux_clks		= g3d_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(g3d_mux_clks),
+	.div_clks		= g3d_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(g3d_div_clks),
+	.gate_clks		= g3d_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(g3d_gate_clks),
+	.nr_clk_ids		= G3D_NR_CLK,
+	.clk_regs		= g3d_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(g3d_clk_regs),
+};
+
+static void __init exynos5433_cmu_g3d_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &g3d_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_g3d, "samsung,exynos5433-cmu-g3d",
+		exynos5433_cmu_g3d_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index e76300a..04d4dbf 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -780,4 +780,29 @@
 
 #define BUSx_NR_CLK					11
 
+/* CMU_G3D */
+#define CLK_FOUT_G3D_PLL				1
+
+#define CLK_MOUT_ACLK_G3D_400				2
+#define CLK_MOUT_G3D_PLL				3
+
+#define CLK_DIV_SCLK_HPM_G3D				4
+#define CLK_DIV_PCLK_G3D				5
+#define CLK_DIV_ACLK_G3D				6
+#define CLK_ACLK_BTS_G3D1				7
+#define CLK_ACLK_BTS_G3D0				8
+#define CLK_ACLK_ASYNCAPBS_G3D				9
+#define CLK_ACLK_ASYNCAPBM_G3D				10
+#define CLK_ACLK_AHB2APB_G3DP				11
+#define CLK_ACLK_G3DNP_150				12
+#define CLK_ACLK_G3DND_600				13
+#define CLK_ACLK_G3D					14
+#define CLK_PCLK_BTS_G3D1				15
+#define CLK_PCLK_BTS_G3D0				16
+#define CLK_PCLK_PMU_G3D				17
+#define CLK_PCLK_SYSREG_G3D				18
+#define CLK_SCLK_HPM_G3D				19
+
+#define G3D_NR_CLK					20
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

