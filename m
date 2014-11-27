Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaK0HiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:38:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52583 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaK0Hf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:29 -0500
X-AuditID: cbfee691-f79b86d000004a5a-17-5476d438c129
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
Subject: [PATCH 14/19] clk: samsung: exynos5433: Add clocks for CMU_GSCL domain
Date: Thu, 27 Nov 2014 16:35:11 +0900
Message-id: <1417073716-22997-15-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkRNfiSlmIweeP4haP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6M/bNXsRa0+1esfrWJvYHxlnMXIyeHhICJxP+9VxghbDGJC/fWs3UxcnEICSxllPj2azZT
	FyMHWNGpCwIQ8emMEkd79rFAOE1MEl+ubGEC6WYT0JLY/+IGG4gtIuAs0TC1kQmkiFngI7NE
	w7SLrF2M7BzCAv4SewpASlgEVCVmbJoCVs4r4Cax9/wqJogjFCSWLZ/JCmJzAsX3fz0IZgsJ
	uEos+nYFbKSEwEIOif9PJrJDDBKQ+Db5EAvEobISmw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuS
	C4qT0otM9YoTc4tL89L1kvNzNzECo/L0v2cTdzDeP2B9iFGAg1GJh9fiQFmIEGtiWXFl7iFG
	U6ANE5mlRJPzgbGfVxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QD4z6VByUz72w2CXwcsGHj0qyq0uStt18899y9+fI3xnXcldK7HskfaWowF1r/KWlh
	9MOfYTXbNZuOLlJ6qaumeGDzn9M3139ndLmUZy5VueZ05Q75yze4D8/IWz+R+ajck83LuiN2
	nj5XvNL5xAZO3dsux6bn3k5Ze9iEsyJFcIXCZ4Y9zqyyxfOVWIozEg21mIuKEwFVmLwPxQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV2LK2UhBpfe8lg8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZuyfvYq1oN2/YvWrTewNjLecuxg5OCQETCROXRDo
	YuQEMsUkLtxbz9bFyMUhJDCdUeJozz4WCKeJSeLLlS1MIFVsAloS+1/cYAOxRQScJRqmNjKB
	FDELfGSWaJh2kbWLkZ1DWMBfYk8BSAmLgKrEjE1TwMp5Bdwk9p5fxQSxTEFi2fKZrCA2J1B8
	/9eDYLaQgKvEom9XmCYw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzzz6R3MK5q
	sDjEKMDBqMTDa3GgLESINbGsuDL3EKMEB7OSCK/UIqAQb0piZVVqUX58UWlOavEhRlOgqyYy
	S4km5wPTUV5JvKGxiZmRpZG5oYWRsbmSOO+Nm7khQgLpiSWp2ampBalFMH1MHJxSDYxNE95e
	zeZ5orT6SmtAg57TPvbuiy/bjRc8UFfO/xfwsyND8mXVstJjS9jMdLc4z7TWSL2ornRpRfKP
	R7Wfrho5mfc97Xiusc9u+oVIxk99P6/dCmzZ4+lw5O+S0ymfhZeWGLYtvnX7odGehdqrKn3M
	RQqsta9XP7wu1mK/5bhu/55CzZCVBqeUWIozEg21mIuKEwGuqxkRDwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the divider/gate of CMU_GSCL domain which contains gscaler
clocks.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |   8 ++
 drivers/clk/samsung/clk-exynos5433.c               | 143 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  37 +++++-
 3 files changed, 187 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
index 589ed93..bf72817 100644
--- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -30,6 +30,8 @@ Required Properties:
     which generates global data buses clock and global peripheral buses clock.
   - "samsung,exynos5433-cmu-g3d"  - clock controller compatible for CMU_G3D
     which generates clocks for 3D Graphics Engine IP.
+  - "samsung,exynos5433-cmu-gscl"  - clock controller compatible for CMU_GSCL
+    which generates clocks for GSCALER IPs.
 
 - reg: physical base address of the controller and length of memory mapped
   region.
@@ -123,6 +125,12 @@ Example 1: Examples of clock controller nodes are listed below.
 		#clock-cells = <1>;
 	};
 
+	cmu_gscl: clock-controller@0x13cf0000 {
+		compatible = "samsung,exynos5433-cmu-gscl";
+		reg = <0x13cf0000 0x0b10>;
+		#clock-cells = <1>;
+	};
+
 Example 2: UART controller node that consumes the clock generated by the clock
 	   controller.
 
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 920bc3c..f515b95 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -543,6 +543,10 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_ACLK_TOP, 21, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_FSYS_200, "aclk_fsys_200", "div_aclk_fsys_200",
 			ENABLE_ACLK_TOP, 18, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_GSCL_111, "aclk_gscl_111", "div_aclk_gscl_111",
+			ENABLE_ACLK_TOP, 15, 0, 0),
+	GATE(CLK_ACLK_GSCL_333, "aclk_gscl_333", "div_aclk_gscl_333",
+			ENABLE_ACLK_TOP, 14, 0, 0),
 	GATE(CLK_ACLK_G2D_266, "aclk_g2d_266", "div_aclk_g2d_266",
 			ENABLE_ACLK_TOP, 2, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_G2D_400, "aclk_g2d_400", "div_aclk_g2d_400",
@@ -3264,3 +3268,142 @@ static void __init exynos5433_cmu_g3d_init(struct device_node *np)
 }
 CLK_OF_DECLARE(exynos5433_cmu_g3d, "samsung,exynos5433-cmu-g3d",
 		exynos5433_cmu_g3d_init);
+
+/*
+ * Register offset definitions for CMU_GSCL
+ */
+#define MUX_SEL_GSCL				0x0200
+#define MUX_ENABLE_GSCL				0x0300
+#define	MUX_STAT_GSCL				0x0400
+#define	ENABLE_ACLK_GSCL			0x0800
+#define	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL0	0x0804
+#define	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL1	0x0808
+#define	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL2	0x080c
+#define	ENABLE_PCLK_GSCL			0x0900
+#define	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0	0x0904
+#define	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL1	0x0908
+#define	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL2	0x090c
+#define	ENABLE_IP_GSCL0				0x0b00
+#define	ENABLE_IP_GSCL1				0x0b04
+#define	ENABLE_IP_GSCL_SECURE_SMMU_GSCL0	0x0b08
+#define	ENABLE_IP_GSCL_SECURE_SMMU_GSCL1	0x0b0c
+#define	ENABLE_IP_GSCL_SECURE_SMMU_GSCL2	0x0b10
+
+static unsigned long gscl_clk_regs[] __initdata = {
+	MUX_SEL_GSCL,
+	MUX_ENABLE_GSCL,
+	MUX_STAT_GSCL,
+	ENABLE_ACLK_GSCL,
+	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL0,
+	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL1,
+	ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL2,
+	ENABLE_PCLK_GSCL,
+	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0,
+	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL1,
+	ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL2,
+	ENABLE_IP_GSCL0,
+	ENABLE_IP_GSCL1,
+	ENABLE_IP_GSCL_SECURE_SMMU_GSCL0,
+	ENABLE_IP_GSCL_SECURE_SMMU_GSCL1,
+	ENABLE_IP_GSCL_SECURE_SMMU_GSCL2,
+};
+
+/* list of all parent clock list */
+PNAME(aclk_gscl_111_user_p)	= { "fin_pll", "aclk_gscl_111", };
+PNAME(aclk_gscl_333_user_p)	= { "fin_pll", "aclk_gscl_333", };
+
+static struct samsung_mux_clock gscl_mux_clks[] __initdata = {
+	/* MUX_SEL_GSCL */
+	MUX(CLK_MOUT_ACLK_GSCL_111_USER, "mout_aclk_gscl_111_user",
+			aclk_gscl_111_user_p, MUX_SEL_GSCL, 4, 1),
+	MUX(CLK_MOUT_ACLK_GSCL_333_USER, "mout_aclk_gscl_333_user",
+			aclk_gscl_333_user_p, MUX_SEL_GSCL, 4, 1),
+};
+
+static struct samsung_gate_clock gscl_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_GSCL */
+	GATE(CLK_ACLK_BTS_GSCL2, "aclk_bts_gscl2", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 11, 0, 0),
+	GATE(CLK_ACLK_BTS_GSCL1, "aclk_bts_gscl1", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 10, 0, 0),
+	GATE(CLK_ACLK_BTS_GSCL0, "aclk_bts_gscl0", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 9, 0, 0),
+	GATE(CLK_ACLK_AHB2APB_GSCLP, "aclk_ahb2apb_gsclp",
+			"mout_aclk_gscl_111_user", ENABLE_ACLK_GSCL,
+			8, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_XIU_GSCLX, "aclk_xiu_gsclx", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 7, 0, 0),
+	GATE(CLK_ACLK_GSCLNP_111, "aclk_gsclnp_111", "mout_aclk_gscl_111_user",
+			ENABLE_ACLK_GSCL, 6, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_GSCLRTND_333, "aclk_gsclrtnd_333",
+			"mout_aclk_gscl_333_user", ENABLE_ACLK_GSCL, 5, 0, 0),
+	GATE(CLK_ACLK_GSCLBEND_333, "aclk_gsclbend_333",
+			"mout_aclk_gscl_333_user", ENABLE_ACLK_GSCL, 4, 0, 0),
+	GATE(CLK_ACLK_GSD, "aclk_gsd", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 3, 0, 0),
+	GATE(CLK_ACLK_GSCL2, "aclk_gscl2", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 2, 0, 0),
+	GATE(CLK_ACLK_GSCL1, "aclk_gscl1", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 1, 0, 0),
+	GATE(CLK_ACLK_GSCL0, "aclk_gscl0", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL, 0, 0, 0),
+
+	/* ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL0 */
+	GATE(CLK_ACLK_SMMU_GSCL0, "aclk_smmu_gscl0", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL0, 0, 0, 0),
+
+	/* ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL1 */
+	GATE(CLK_ACLK_SMMU_GSCL1, "aclk_smmu_gscl1", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL1, 0, 0, 0),
+
+	/* ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL2 */
+	GATE(CLK_ACLK_SMMU_GSCL2, "aclk_smmu_gscl2", "mout_aclk_gscl_333_user",
+			ENABLE_ACLK_GSCL_SECURE_SMMU_GSCL2, 0, 0, 0),
+
+	/* ENABLE_PCLK_GSCL */
+	GATE(CLK_PCLK_BTS_GSCL2, "pclk_bts_gscl2", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 7, 0, 0),
+	GATE(CLK_PCLK_BTS_GSCL1, "pclk_bts_gscl1", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 6, 0, 0),
+	GATE(CLK_PCLK_BTS_GSCL0, "pclk_bts_gscl0", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 5, 0, 0),
+	GATE(CLK_PCLK_PMU_GSCL, "pclk_pmu_gscl", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_GSCL, "pclk_sysreg_gscl",
+			"mout_aclk_gscl_111_user", ENABLE_PCLK_GSCL, 3, 0, 0),
+	GATE(CLK_PCLK_GSCL2, "pclk_gscl2", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 2, 0, 0),
+	GATE(CLK_PCLK_GSCL1, "pclk_gscl1", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 1, 0, 0),
+	GATE(CLK_PCLK_GSCL0, "pclk_gscl0", "mout_aclk_gscl_111_user",
+			ENABLE_PCLK_GSCL, 0, 0, 0),
+
+	/* ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0 */
+	GATE(CLK_PCLK_SMMU_GSCL0, "pclk_smmu_gscl0", "mout_aclk_gscl_111_user",
+		ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0, 0, 0, 0),
+
+	/* ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL1 */
+	GATE(CLK_PCLK_SMMU_GSCL1, "pclk_smmu_gscl1", "mout_aclk_gscl_111_user",
+		ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0, 0, 0, 0),
+
+	/* ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL2 */
+	GATE(CLK_PCLK_SMMU_GSCL2, "pclk_smmu_gscl2", "mout_aclk_gscl_111_user",
+		ENABLE_PCLK_GSCL_SECURE_SMMU_GSCL0, 0, 0, 0),
+};
+
+static struct samsung_cmu_info gscl_cmu_info __initdata = {
+	.mux_clks		= gscl_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(gscl_mux_clks),
+	.gate_clks		= gscl_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(gscl_gate_clks),
+	.nr_clk_ids		= GSCL_NR_CLK,
+	.clk_regs		= gscl_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(gscl_clk_regs),
+};
+
+static void __init exynos5433_cmu_gscl_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &gscl_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_gscl, "samsung,exynos5433-cmu-gscl",
+		exynos5433_cmu_gscl_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index d0fda01..c408af4 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -148,8 +148,10 @@
 #define CLK_SCLK_UFSUNIPRO_FSYS		229
 #define CLK_SCLK_USBHOST30_FSYS		230
 #define CLK_SCLK_USBDRD30_FSYS		231
+#define CLK_ACLK_GSCL_111		232
+#define CLK_ACLK_GSCL_333		233
 
-#define TOP_NR_CLK			232
+#define TOP_NR_CLK			234
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
@@ -829,4 +831,37 @@
 
 #define G3D_NR_CLK					20
 
+/* CMU_GSCL */
+#define CLK_MOUT_ACLK_GSCL_111_USER			1
+#define CLK_MOUT_ACLK_GSCL_333_USER			2
+
+#define CLK_ACLK_BTS_GSCL2				3
+#define CLK_ACLK_BTS_GSCL1				4
+#define CLK_ACLK_BTS_GSCL0				5
+#define CLK_ACLK_AHB2APB_GSCLP				6
+#define CLK_ACLK_XIU_GSCLX				7
+#define CLK_ACLK_GSCLNP_111				8
+#define CLK_ACLK_GSCLRTND_333				9
+#define CLK_ACLK_GSCLBEND_333				10
+#define CLK_ACLK_GSD					11
+#define CLK_ACLK_GSCL2					12
+#define CLK_ACLK_GSCL1					13
+#define CLK_ACLK_GSCL0					14
+#define CLK_ACLK_SMMU_GSCL0				15
+#define CLK_ACLK_SMMU_GSCL1				16
+#define CLK_ACLK_SMMU_GSCL2				17
+#define CLK_PCLK_BTS_GSCL2				18
+#define CLK_PCLK_BTS_GSCL1				19
+#define CLK_PCLK_BTS_GSCL0				20
+#define CLK_PCLK_PMU_GSCL				21
+#define CLK_PCLK_SYSREG_GSCL				22
+#define CLK_PCLK_GSCL2					23
+#define CLK_PCLK_GSCL1					24
+#define CLK_PCLK_GSCL0					25
+#define CLK_PCLK_SMMU_GSCL0				26
+#define CLK_PCLK_SMMU_GSCL1				27
+#define CLK_PCLK_SMMU_GSCL2				28
+
+#define GSCL_NR_CLK					29
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

