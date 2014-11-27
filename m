Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaK0Hfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaK0Hf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-fb-5476d437a992
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
Subject: [PATCH 10/19] clk: samsung: exynos5433: Add clocks for CMU_AUD domain
Date: Thu, 27 Nov 2014 16:35:07 +0900
Message-id: <1417073716-22997-11-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkRNf8SlmIwaEvZhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6M75PWsRfcCKroPTCbqYHxmmsXIweHhICJxKxvgl2MnECmmMSFe+vZuhi5OIQEljJK/DzW
	wQSRMJG4PXMFI0RiOqPEla3NrBBOE5PErZUP2EGq2AS0JPa/uMEGYosIOEs0TG1kAiliFvjI
	LNEw7SIrSEJYwE/id2cTmM0ioCqx+fZxFhCbV8BN4ty5dlaIdQoSy5bPBLM5geL7vx4Es4UE
	XCUWfbsCNlRCYC6HxM91W1kgBglIfJt8iAXiH1mJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJ
	BcVJ6UVGesWJucWleel6yfm5mxiBkXn637O+HYw3D1gfYhTgYFTi4bU4UBYixJpYVlyZe4jR
	FGjDRGYp0eR8YPznlcQbGpsZWZiamBobmVuaKYnzJkj9DBYSSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAmDg/1DUoTeFJXOOCmlDtF87flXJDbsYUKAowOwfV/U1Xu56rPuX/+iN6n5Z2X/cJ
	m2iy/T5TyqyKJeJe6dMedr49se/IrekzLiaa99UVdouunPR2pYiGh///M289NdJXfUz7ur7H
	beaR+NzLYh2KYumrk5w/zzE+Oj9tqtqjV/wcvtfyIxMilFiKMxINtZiLihMBDHjUj8cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQV3zK2UhBnNO61g8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnyftI694EZQRe+B2UwNjNdcuxg5OSQETCRuz1zB
	CGGLSVy4t56ti5GLQ0hgOqPEla3NrBBOE5PErZUP2EGq2AS0JPa/uMEGYosIOEs0TG1kAili
	FvjILNEw7SIrSEJYwE/id2cTmM0ioCqx+fZxFhCbV8BN4ty5dlaIdQoSy5bPBLM5geL7vx4E
	s4UEXCUWfbvCNIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Mh/Jr2DcVWDxSFG
	AQ5GJR5eiwNlIUKsiWXFlbmHGCU4mJVEeKUWAYV4UxIrq1KL8uOLSnNSiw8xmgJdNZFZSjQ5
	H5iU8kriDY1NzIwsjcwNLYyMzZXEeW/czA0REkhPLEnNTk0tSC2C6WPi4JRqYPSuv6aiXS1z
	KHo/o9K9p+Z7dkRlMqeJn8ncceR2sI4Lm+3Xd7Or4pyOJn79U3/x4TSXldMnPnh6NrDrtMgp
	n5pIH0aP3UvM/xhw1Pzb6jar4eo2yX0vec3sus1LBItn8JU4erNtmrHU+8FJ3x8ibO66s1Nv
	JE0W0/m/ydCa88+vyveTih7vm6bEUpyRaKjFXFScCABSXCTWEgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mux/divider/gate clocks for CMU_AUD domain which
includes the clocks of Cortex-A6/Bus/Audio clocks.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |   7 +
 drivers/clk/samsung/clk-exynos5433.c               | 173 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  53 +++++++
 3 files changed, 233 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
index 8d3dad4..9a6ae75 100644
--- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -23,6 +23,8 @@ Required Properties:
     which generates clocks for G2D/MDMA IPs.
   - "samsung,exynos5433-cmu-disp"  - clock controller compatible for CMU_DISP
     which generates clocks for Display (DECON/HDMI/DSIM/MIXER) IPs.
+  - "samsung,exynos5433-cmu-aud"   - clock controller compatible for CMU_AUD
+    which generates clocks for Cortex-A5/BUS/AUDIO clocks.
 
 - reg: physical base address of the controller and length of memory mapped
   region.
@@ -86,6 +88,11 @@ Example 1: Examples of clock controller nodes are listed below.
 		#clock-cells = <1>;
 	};
 
+	cmu_aud: clock-controller@0x114c0000 {
+		compatible = "samsung,exynos5433-cmu-aud";
+		reg = <0x114c0000 0x0b04>;
+		#clock-cells = <1>;
+	};
 
 Example 2: UART controller node that consumes the clock generated by the clock
 	   controller.
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index cd48209..9f28672 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -2456,3 +2456,176 @@ static void __init exynos5433_cmu_disp_init(struct device_node *np)
 
 CLK_OF_DECLARE(exynos5433_cmu_disp, "samsung,exynos5433-cmu-disp",
 		exynos5433_cmu_disp_init);
+
+/*
+ * Register offset definitions for CMU_AUD
+ */
+#define MUX_SEL_AUD0			0x0200
+#define MUX_SEL_AUD1			0x0204
+#define MUX_ENABLE_AUD0			0x0300
+#define MUX_ENABLE_AUD1			0x0304
+#define MUX_STAT_AUD0			0x0400
+#define DIV_AUD0			0x0600
+#define DIV_AUD1			0x0604
+#define DIV_STAT_AUD0			0x0700
+#define DIV_STAT_AUD1			0x0704
+#define ENABLE_ACLK_AUD			0x0800
+#define ENABLE_PCLK_AUD			0x0900
+#define ENABLE_SCLK_AUD0		0x0a00
+#define ENABLE_SCLK_AUD1		0x0a04
+#define ENABLE_IP_AUD0			0x0b00
+#define ENABLE_IP_AUD1			0x0b04
+
+static unsigned long aud_clk_regs[] __initdata = {
+	MUX_SEL_AUD0,
+	MUX_SEL_AUD1,
+	MUX_ENABLE_AUD0,
+	MUX_ENABLE_AUD1,
+	MUX_STAT_AUD0,
+	DIV_AUD0,
+	DIV_AUD1,
+	DIV_STAT_AUD0,
+	DIV_STAT_AUD1,
+	ENABLE_ACLK_AUD,
+	ENABLE_PCLK_AUD,
+	ENABLE_SCLK_AUD0,
+	ENABLE_SCLK_AUD1,
+	ENABLE_IP_AUD0,
+	ENABLE_IP_AUD1,
+};
+
+/* list of all parent clock list */
+PNAME(mout_aud_pll_user_aud_p)	= { "fin_pll", "fout_aud_pll", };
+PNAME(mout_sclk_aud_pcm_p)	= { "mout_aud_pll_user", "ioclk_audiocdclk0",};
+PNAME(mout_sclk_aud_i2s_p)	= { "mout_aud_pll_user", "ioclk_audiocdclk0",};
+
+static struct samsung_fixed_rate_clock aud_fixed_clks[] __initdata = {
+	FRATE(0, "ioclk_jtag_tclk", NULL, CLK_IS_ROOT, 188000000),
+	FRATE(0, "ioclk_slimbus_clk", NULL, CLK_IS_ROOT, 188000000),
+	FRATE(0, "ioclk_i2s_bclk", NULL, CLK_IS_ROOT, 188000000),
+};
+
+static struct samsung_mux_clock aud_mux_clks[] __initdata = {
+	/* MUX_SEL_AUD0 */
+	MUX(CLK_MOUT_AUD_PLL_USER, "mout_aud_pll_user",
+			mout_aud_pll_user_aud_p, MUX_SEL_AUD0, 0, 1),
+
+	/* MUX_SEL_AUD1 */
+	MUX(CLK_MOUT_SCLK_AUD_PCM, "mout_sclk_aud_pcm", mout_sclk_aud_pcm_p,
+			MUX_SEL_AUD1, 8, 1),
+	MUX(CLK_MOUT_SCLK_AUD_I2S, "mout_sclk_aud_i2s", mout_sclk_aud_i2s_p,
+			MUX_SEL_AUD1, 0, 1),
+};
+
+static struct samsung_div_clock aud_div_clks[] __initdata = {
+	/* DIV_AUD0 */
+	DIV(CLK_DIV_ATCLK_AUD, "div_atclk_aud", "div_aud_ca5", DIV_AUD0,
+			12, 4),
+	DIV(CLK_DIV_PCLK_DBG_AUD, "div_pclk_dbg_aud", "div_aud_ca5", DIV_AUD0,
+			8, 4),
+	DIV(CLK_DIV_ACLK_AUD, "div_aclk_aud", "div_aud_ca5", DIV_AUD0,
+			4, 4),
+	DIV(CLK_DIV_AUD_CA5, "div_aud_ca5", "mout_aud_pll_user", DIV_AUD0,
+			0, 4),
+
+	/* DIV_AUD1 */
+	DIV(CLK_DIV_SCLK_AUD_SLIMBUS, "div_sclk_aud_slimbus",
+			"mout_aud_pll_user", DIV_AUD1, 16, 5),
+	DIV(CLK_DIV_SCLK_AUD_UART, "div_sclk_aud_uart", "mout_aud_pll_user",
+			DIV_AUD1, 12, 4),
+	DIV(CLK_DIV_SCLK_AUD_PCM, "div_sclk_aud_pcm", "mout_sclk_aud_pcm",
+			DIV_AUD1, 4, 8),
+	DIV(CLK_DIV_SCLK_AUD_I2S, "div_sclk_aud_i2s",  "mout_sclk_aud_i2s",
+			DIV_AUD1, 0, 4),
+};
+
+static struct samsung_gate_clock aud_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_AUD */
+	GATE(CLK_ACLK_INTR_CTRL, "aclk_intr_ctrl", "div_aclk_aud",
+			ENABLE_ACLK_AUD, 12, 0, 0),
+	GATE(CLK_ACLK_SMMU_LPASSX, "aclk_smmu_lpassx", "div_aclk_aud",
+			ENABLE_ACLK_AUD, 7, 0, 0),
+	GATE(CLK_ACLK_XIU_LPASSX, "aclk_xiu_lpassx", "div_aclk_aud",
+			ENABLE_ACLK_AUD, 0, 4, 0),
+	GATE(CLK_ACLK_AUDNP_133, "aclk_audnp_133", "div_aclk_aud",
+			ENABLE_ACLK_AUD, 0, 3, 0),
+	GATE(CLK_ACLK_AUDND_133, "aclk_audnd_133", "div_aclk_aud",
+			ENABLE_ACLK_AUD, 0, 2, 0),
+	GATE(CLK_ACLK_SRAMC, "aclk_sramc", "div_aclk_aud", ENABLE_ACLK_AUD,
+			0, 1, 0),
+	GATE(CLK_ACLK_DMAC, "aclk_dmac",  "div_aclk_aud", ENABLE_ACLK_AUD,
+			0, 0, 0),
+
+	/* ENABLE_PCLK_AUD */
+	GATE(CLK_PCLK_WDT1, "pclk_wdt1", "div_aclk_aud", ENABLE_PCLK_AUD,
+			13, 0, 0),
+	GATE(CLK_PCLK_WDT0, "pclk_wdt0", "div_aclk_aud", ENABLE_PCLK_AUD,
+			12, 0, 0),
+	GATE(CLK_PCLK_SFR1, "pclk_sfr1", "div_aclk_aud", ENABLE_PCLK_AUD,
+			11, 0, 0),
+	GATE(CLK_PCLK_SMMU_LPASSX, "pclk_smmu_lpassx", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 10, 0, 0),
+	GATE(CLK_PCLK_GPIO_AUD, "pclk_gpio_aud", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 9, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_PMU_AUD, "pclk_pmu_aud", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_AUD, "pclk_sysreg_aud", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 7, 0, 0),
+	GATE(CLK_PCLK_AUD_SLIMBUS, "pclk_aud_slimbus", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 6, 0, 0),
+	GATE(CLK_PCLK_AUD_UART, "pclk_aud_uart", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 5, 0, 0),
+	GATE(CLK_PCLK_AUD_PCM, "pclk_aud_pcm", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 4, 0, 0),
+	GATE(CLK_PCLK_AUD_I2S, "pclk_aud_i2s", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 3, 0, 0),
+	GATE(CLK_PCLK_TIMER, "pclk_timer", "div_aclk_aud", ENABLE_PCLK_AUD,
+			2, 0, 0),
+	GATE(CLK_PCLK_SFR0_CTRL, "pclk_sfr0_ctrl", "div_aclk_aud",
+			ENABLE_PCLK_AUD, 0, 0, 0),
+
+	/* ENABLE_SCLK_AUD0 */
+	GATE(CLK_ATCLK_AUD, "atclk_aud", "div_atclk_aud", ENABLE_SCLK_AUD0,
+			2, 0, 0),
+	GATE(CLK_PCLK_DBG_AUD, "pclk_dbg_aud", "div_pclk_dbg_aud",
+			ENABLE_SCLK_AUD0, 1, 0, 0),
+	GATE(CLK_SCLK_AUD_CA5, "sclk_aud_ca5", "div_aud_ca5", ENABLE_SCLK_AUD0,
+			0, 0, 0),
+
+	/* ENABLE_SCLK_AUD1 */
+	GATE(CLK_SCLK_JTAG_TCK, "sclk_jtag_tck", "ioclk_jtag_tclk",
+			ENABLE_SCLK_AUD1, 6, 0, 0),
+	GATE(CLK_SCLK_SLIMBUS_CLKIN, "sclk_slimbus_clkin", "ioclk_slimbus_clk",
+			ENABLE_SCLK_AUD1, 5, 0, 0),
+	GATE(CLK_SCLK_AUD_SLIMBUS, "sclk_aud_slimbus", "div_sclk_aud_slimbus",
+			ENABLE_SCLK_AUD1, 4, 0, 0),
+	GATE(CLK_SCLK_AUD_UART, "sclk_aud_uart", "div_sclk_aud_uart",
+			ENABLE_SCLK_AUD1, 3, 0, 0),
+	GATE(CLK_SCLK_AUD_PCM, "sclk_aud_pcm", "div_sclk_aud_pcm",
+			ENABLE_SCLK_AUD1, 2, 0, 0),
+	GATE(CLK_SCLK_I2S_BCLK, "sclk_i2s_bclk", "ioclk_i2s_bclk",
+			ENABLE_SCLK_AUD1, 1, 0, 0),
+	GATE(CLK_SCLK_AUD_I2S, "sclk_aud_i2s", "div_sclk_aud_i2s",
+			ENABLE_SCLK_AUD1, 0, 0, 0),
+};
+
+static struct samsung_cmu_info aud_cmu_info __initdata = {
+	.mux_clks		= aud_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(aud_mux_clks),
+	.div_clks		= aud_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(aud_div_clks),
+	.gate_clks		= aud_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(aud_gate_clks),
+	.fixed_clks		= aud_fixed_clks,
+	.nr_fixed_clks		= ARRAY_SIZE(aud_fixed_clks),
+	.nr_clk_ids		= AUD_NR_CLK,
+	.clk_regs		= aud_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(aud_clk_regs),
+};
+
+static void __init exynos5433_cmu_aud_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &aud_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_aud, "samsung,exynos5433-cmu-aud",
+		exynos5433_cmu_aud_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 407e011..e1c848a 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -627,4 +627,57 @@
 
 #define DISP_NR_CLK					111
 
+/* CMU_AUD */
+#define CLK_MOUT_AUD_PLL_USER				1
+#define CLK_MOUT_SCLK_AUD_PCM				2
+#define CLK_MOUT_SCLK_AUD_I2S				3
+
+#define CLK_DIV_ATCLK_AUD				4
+#define CLK_DIV_PCLK_DBG_AUD				5
+#define CLK_DIV_ACLK_AUD				6
+#define CLK_DIV_AUD_CA5					7
+#define CLK_DIV_SCLK_AUD_SLIMBUS			8
+#define CLK_DIV_SCLK_AUD_UART				9
+#define CLK_DIV_SCLK_AUD_PCM				10
+#define CLK_DIV_SCLK_AUD_I2S				11
+
+#define CLK_ACLK_INTR_CTRL				12
+#define CLK_ACLK_AXIDS2_LPASSP				13
+#define CLK_ACLK_AXIDS1_LPASSP				14
+#define CLK_ACLK_AXI2APB1_LPASSP			15
+#define CLK_ACLK_AXI2APH_LPASSP				16
+#define CLK_ACLK_SMMU_LPASSX				17
+#define CLK_ACLK_AXIDS0_LPASSP				18
+#define CLK_ACLK_AXI2APB0_LPASSP			19
+#define CLK_ACLK_XIU_LPASSX				20
+#define CLK_ACLK_AUDNP_133				21
+#define CLK_ACLK_AUDND_133				22
+#define CLK_ACLK_SRAMC					23
+#define CLK_ACLK_DMAC					24
+#define CLK_PCLK_WDT1					25
+#define CLK_PCLK_WDT0					26
+#define CLK_PCLK_SFR1					27
+#define CLK_PCLK_SMMU_LPASSX				28
+#define CLK_PCLK_GPIO_AUD				29
+#define CLK_PCLK_PMU_AUD				30
+#define CLK_PCLK_SYSREG_AUD				31
+#define CLK_PCLK_AUD_SLIMBUS				32
+#define CLK_PCLK_AUD_UART				33
+#define CLK_PCLK_AUD_PCM				34
+#define CLK_PCLK_AUD_I2S				35
+#define CLK_PCLK_TIMER					36
+#define CLK_PCLK_SFR0_CTRL				37
+#define CLK_ATCLK_AUD					38
+#define CLK_PCLK_DBG_AUD				39
+#define CLK_SCLK_AUD_CA5				40
+#define CLK_SCLK_JTAG_TCK				41
+#define CLK_SCLK_SLIMBUS_CLKIN				42
+#define CLK_SCLK_AUD_SLIMBUS				43
+#define CLK_SCLK_AUD_UART				44
+#define CLK_SCLK_AUD_PCM				45
+#define CLK_SCLK_I2S_BCLK				46
+#define CLK_SCLK_AUD_I2S				47
+
+#define AUD_NR_CLK					48
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

