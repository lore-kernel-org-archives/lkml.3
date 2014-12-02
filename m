Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaLBI4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:56:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaLBIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:05 -0500
X-AuditID: cbfee68f-f791c6d000004834-97-547d7d3636e3
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
Subject: [PATCH 05/19] clk: samsung: exynos5433: Add clocks for CMU_G2D domain
Date: Tue, 02 Dec 2014 17:49:42 +0900
Message-id: <1417510196-6714-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkRNestjbEYOoKLYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGV83CBZ
	8DSo4uXvPSwNjHfduhg5OSQETCQuvJ3JBGGLSVy4t56ti5GLQ0hgKaPEuYOPGLsYOcCK/k+O
	hohPZ5Q4c2kFK4TTxCTx4MYGRpBuNgEtif0vbrCB2CICzhINUxuZQIqYBd4wS+y5v5sFJCEs
	4CfR8eMRK4jNIqAq8WHHfmYQm1fAReL8i6msEGcoSCxbPhPM5hRwleg608cOYgsB1fxq/cgO
	MlRCYCaHxJ+ls1kgBglIfJt8iAXiVFmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXG
	esWJucWleel6yfm5mxiB0Xj637P+HYx3D1gfYhTgYFTi4T1xviZEiDWxrLgy9xCjKdCGicxS
	osn5wJjPK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	Y/id1dErV825k/L1Vs3/rgO3ktZbc1us3lujxjzfViLdqf6ag6DO/cP5xj9DFjXocVQfmqpY
	2fhh+0mjfeFG56PKatOm/rpqXZezOE12UszTXz4J4e9k0hZMy52mOMf9/kHhrJeiE3Psat7P
	3MHXa/u6xMWtbM21FQs8mc9uN2rTeN6cx/OXXYmlOCPRUIu5qDgRANDqLhTBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV2z2toQg1nT5Swer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYx4+MGyYKnQRUvf+9haWC869bFyMEhIWAi8X9ydBcjJ5ApJnHh
	3nq2LkYuDiGB6YwSZy6tYIVwmpgkHtzYwAhSxSagJbH/xQ02EFtEwFmiYWojE0gRs8AbZok9
	93ezgCSEBfwkOn48YgWxWQRUJT7s2M8MYvMKuEicfzGVFWKdgsSy5TPBbE4BV4muM33sILYQ
	UM2v1o/sExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvVnUjsYVzZYHGIU4GBU
	4uE9cb4mRIg1say4MvcQowQHs5II7y/j2hAh3pTEyqrUovz4otKc1OJDjKZAV01klhJNzgem
	obySeENjEzMjSyNzQwsjY3Mlcd4bN3NDhATSE0tSs1NTC1KLYPqYODilGhjd+Xk67/W77BT0
	MDlocL56UW7r7UgOf9nZ3v/33UiwdvlxSlzhpZDDneccrQ+z7Wc+2X5n7qETXIZaRzM3/F2y
	SOXea7baJ1JbXGPXpc54MU9PIf4Wd//j2Z1/rIVFnxntXCKaNYVdrTTp+rFjqu+TZl1d1v5p
	Fu/h71+0Mzpk9+hU/+ueYS2pxFKckWioxVxUnAgAOpBGqAsDAAA=
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
index 7e4612f..4dec9fc 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -400,6 +400,20 @@ static struct samsung_mux_clock top_mux_clks[] __initdata = {
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
@@ -489,6 +503,10 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
 			ENABLE_ACLK_TOP, 21, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_FSYS_200, "aclk_fsys_200", "div_aclk_fsys_200",
 			ENABLE_ACLK_TOP, 18, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2D_266, "aclk_g2d_266", "div_aclk_g2d_266",
+			ENABLE_ACLK_TOP, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_G2D_400, "aclk_g2d_400", "div_aclk_g2d_400",
+			ENABLE_ACLK_TOP, 0, CLK_IGNORE_UNUSED, 0),
 
 	/* ENABLE_SCLK_TOP_FSYS */
 	GATE(CLK_SCLK_MMC2_FSYS, "sclk_mmc2_fsys", "div_sclk_mmc2_b",
@@ -1275,3 +1293,129 @@ static void __init exynos5433_cmu_fsys_init(struct device_node *np)
 
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
index 48eb6f3..054f767 100644
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

