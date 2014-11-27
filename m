Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaK0Hfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaK0Hf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-04-5476d4388693
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/19] clk: samsung: exynos5433: Add clocks for CMU_G3D domain
Date: Thu, 27 Nov 2014 16:35:10 +0900
Message-id: <1417073716-22997-14-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkQNfiSlmIwYvp4haP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6M8z3tTAV7rCoaur4wNjAuNexi5OCQEDCR2HkjvouRE8gUk7hwbz1bFyMXh5DAUkaJnpaX
	rBAJE4nedcdZIRLTGSXmnv/KCOE0MUl8ubKFCaSKTUBLYv+LG2wgtoiAs0TD1EYmkCJmgY/M
	Eg3TLrKCrBMW8JPYNpsZpIZFQFXi4psXYBt4Bdwk3r/dxw6xTUFi2fKZYHFOoPj+rwfBbCEB
	V4lF366AzZQQmMsh8XLKXBaIQQIS3yYfYoF4R1Zi0wFmiDmSEgdX3GCZwCi8gJFhFaNoakFy
	QXFSepGRXnFibnFpXrpecn7uJkZgXJ7+96xvB+PNA9aHGAU4GJV4eC0OlIUIsSaWFVfmHmI0
	BdowkVlKNDkfGP15JfGGxmZGFqYmpsZG5pZmSuK8CVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUw1in6/LvPHcOxse/qXebl5wWzNe8EmZjU6bhYVT5YMonx87Juxie986S+vytw/MZQ
	bxWw1+qU8L+62N1ts/cvLU5K+uHulh7o1j7hfucffo1DHN9z70UveOJ+UiRqfcpBwQdNUQFx
	fdIrtI7s/GzEqC4+ef2HB60b1R5KP5vvca6ggFHj7HlLJZbijERDLeai4kQAyiwY2cYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQV2LK2UhBvvPcFs8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZpzvaWcq2GNV0dD1hbGBcalhFyMnh4SAiUTvuuOs
	ELaYxIV769m6GLk4hASmM0rMPf+VEcJpYpL4cmULE0gVm4CWxP4XN9hAbBEBZ4mGqY1MIEXM
	Ah+ZJRqmXQQaxcEhLOAnsW02M0gNi4CqxMU3L8A28Aq4Sbx/u48dYpuCxLLlM8HinEDx/V8P
	gtlCAq4Si75dYZrAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDcP5PewbiqweIQ
	owAHoxIPr8WBshAh1sSy4srcQ4wSHMxKIrxSi4BCvCmJlVWpRfnxRaU5qcWHGE2BrprILCWa
	nA9MSXkl8YbGJmZGlkbmhhZGxuZK4rw3buaGCAmkJ5akZqemFqQWwfQxcXBKNTCqiZWtO80c
	dFZNi3nFjs5E25u/Ktkq3U39I6tX9a3asebElXnz+TmXTXRlevC47kDzc4e8zLMXLyt9qfih
	N1FC8d+TanfHxbM5uO5szPyv9diwxfz415R1rVXcIfOfbM08kvOxXutwnnqOvHjLEcvrU4Xl
	C49/OB1h6MwmrVnK9/nIPPu7LnVKLMUZiYZazEXFiQC4KEh0EQMAAA==
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
index ee26974..920bc3c 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -3137,3 +3137,130 @@ static void __init exynos5433_cmu_bus2_init(struct device_node *np)
 }
 CLK_OF_DECLARE(exynos5433_cmu_bus2, "samsung,exynos5433-cmu-bus2",
 		exynos5433_cmu_bus2_init);
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
+			ENABLE_PCLK_G3D, 0, 0, 0),
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
index 3614044..d0fda01 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -804,4 +804,29 @@
 
 #define BUS2_NR_CLK					10
 
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

