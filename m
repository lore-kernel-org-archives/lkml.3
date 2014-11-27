Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaK0Hfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaK0Hfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:30 -0500
X-AuditID: cbfee691-f79b86d000004a5a-06-5476d437f25a
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
Subject: [PATCH 07/19] clk: samsung: exynos5433: Add clocks for CMU_G2D domain
Date: Thu, 27 Nov 2014 16:35:04 +0900
Message-id: <1417073716-22997-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkRNf8SlmIwcJODYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtM+bOcyWLT
	42usFpd3zWGzmHF+H5PF0usXmSxOXf/MZnH4TTurxYzJL9ksjs1YwmixatcfRouXH0+wOIh5
	rJm3htHj969JjB47Z91l97hzbQ+bx+Yl9R5XTjSxevRtWcXo8XmTXABHFJdNSmpOZllqkb5d
	AlfG4wu32QuuBVWc+rCKqYHxnFsXIyeHhICJxOWLixghbDGJC/fWs3UxcnEICSxllFj+8S9L
	FyMHWFHHcwOI+HRGiT13XjBCOE1MErdWPmAH6WYT0JLY/+IGG4gtIuAs0TC1kQmkiFngI7NE
	w7SLrCCThAX8JPaudgSpYRFQlXj//AwbSJhXwFXixpNkiCMUJJYtn8kKYnMKuEns/3oQzBYC
	Kln07QrYSAmBuRwSD5dvZYKYIyDxbfIhqENlJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcU
	J6UXmeoVJ+YWl+al6yXn525iBEbl6X/PJu5gvH/A+hCjAAejEg+vxYGyECHWxLLiytxDjKZA
	GyYyS4km5wNjP68k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBkbp/kNpjVHPOMNfn3nhsbRdyWvH+h+taycE3BX5fnm3ZlfOej4ttWeJJ19NMGfdy3WL
	ecfGjrNqzZt+7so59met6DW3/9zGrmcs1d35HxT4/Wk/kvPT5s5uwfsH1qw54rq3XjH52cyD
	zPbLZmy/eNH9Qt3PN5utLt/e1PI6ILm/tM0mUDR+wpEWJZbijERDLeai4kQAOCVXnsUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV3zK2UhBnsfyVg8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjy+cJu94FpQxakPq5gaGM+5dTFycEgImEh0PDfo
	YuQEMsUkLtxbz9bFyMUhJDCdUWLPnReMEE4Tk8StlQ/YQarYBLQk9r+4wQZiiwg4SzRMbWQC
	KWIW+Mgs0TDtIivIVGEBP4m9qx1BalgEVCXePz/DBhLmFXCVuPEkGWKZgsSy5TNZQWxOATeJ
	/V8PgtlCQCWLvl1hmsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcMw/k97BuKrB
	4hCjAAejEg+vxYGyECHWxLLiytxDjBIczEoivFKLgEK8KYmVValF+fFFpTmpxYcYTYGOmsgs
	JZqcD0xHeSXxhsYmZkaWRuaGFkbG5krivDdu5oYICaQnlqRmp6YWpBbB9DFxcEo1MLIUX5ze
	a7Nee+N/C78JZenbzb3n3LA4yzq38vjrz9qcvqevr/9x6MDdwv888juePNl9uKu7PfyXaBrD
	t59HLNQYtpz8PKcu17ZXf2qBZVZtHINsi875c3zXJ4lUr4/g6t6w8ObhWZO1a2t0mArsXHM+
	Pfs2hdXH67WUlnzWN51oh+vK2QwGL5RYijMSDbWYi4oTAUCDe04PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds ths mux/divider/gate clocksof CMU_G2D domain which includes
G2D/MDMA IPs. The CMU_G2D must need the clocks related to G2D by providing
CMU_TOP domain. So, this patch add several clocks for G2D from CMU_TOP domain.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
 drivers/clk/samsung/clk-exynos5433.c               | 144 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  42 +++++-
 3 files changed, 193 insertions(+), 1 deletion(-)

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
index b09f2cfe..dd1e6a1 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -403,6 +403,20 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
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
@@ -492,6 +506,10 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_ACLK_TOP, 21, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_FSYS_200, "aclk_fsys_200", "div_aclk_fsys_200",
 			ENABLE_ACLK_TOP, 18, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2D_266, "aclk_g2d_266", "div_aclk_g2d_266",
+			ENABLE_ACLK_TOP, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2D_400, "aclk_g2d_400", "div_aclk_g2d_400",
+			ENABLE_ACLK_TOP, 0, CLK_IGNORE_UNUSED, 0),
 
 	/* ENABLE_SCLK_TOP_FSYS */
 	GATE(CLK_SCLK_MMC2_FSYS, "sclk_mmc2_fsys", "div_sclk_mmc2_b",
@@ -1277,3 +1295,129 @@ static void __init exynos5433_cmu_fsys_init(struct device_node *np)
 
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
+			DIV_ENABLE_PCLK_G2D, 1, 0, 0),
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
index 5c34631..4000833 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -101,6 +101,12 @@
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
@@ -122,8 +128,10 @@
 #define CLK_SCLK_SLIMBUS		217
 #define CLK_SCLK_AUDIO1			218
 #define CLK_SCLK_AUDIO0			219
+#define CLK_ACLK_G2D_266		220
+#define CLK_ACLK_G2D_400		221
 
-#define TOP_NR_CLK			220
+#define TOP_NR_CLK			222
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
@@ -287,4 +295,36 @@
 
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

