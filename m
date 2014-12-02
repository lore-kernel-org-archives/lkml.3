Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaLBIug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaLBIuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:07 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-cb-547d7d377c73
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
Subject: [PATCH 12/19] clk: samsung: exynos5433: Add clocks for CMU_GSCL domain
Date: Tue, 02 Dec 2014 17:49:49 +0900
Message-id: <1417510196-6714-13-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkWNe8tjbE4OhsI4vHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVMPl5e
	MMe/YtOJRawNjK+duxg5OSQETCS+HZjOAmGLSVy4t56ti5GLQ0hgKaPE06YfjDBFV1etZ4FI
	TGeU+HVnAVRVE5PEgxsbwKrYBLQk9r+4wQZiiwg4SzRMbWQCKWIWeMMssef+brAdwgL+Eh8P
	TgUrYhFQlVg97SNQMwcHr4CrxM/DpRDbFCSWLZ/JCmJzAoW7zvSxg9hCAi4Sv1o/soPMlBCY
	yiExqXczI8QcAYlvkw+xgMyREJCV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolec
	mFtcmpeul5yfu4kRGI2n/z2bsIPx3gHrQ4wCHIxKPLwnzteECLEmlhVX5h5iNAXaMJFZSjQ5
	HxjzeSXxhsZmRhamJqbGRuaWZkrivK+lfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYKyq
	ivKuitybe+XHjZlXTGPf2J2bJ8F9TYnrTXPyTwVx6en7TwRGnV75tpxt9oFcHW/Th7lbOQIr
	I92S079b7gma/nJSqe36p0b7jylVTT64L+M35+e9B/peRloo3jr4l1+xv/fE0WoG0y3sXR9O
	2sQzhos8tZJ99Tnu4dGbfTMOf7MKjZ3zmFOJpTgj0VCLuag4EQCkpPxnwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV3z2toQg4nHVS0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxY/Lx8oI5/hWbTixibWB87dzFyMkhIWAicXXVehYIW0ziwr31
	bF2MXBxCAtMZJX7dWQDlNDFJPLixgRGkik1AS2L/ixtsILaIgLNEw9RGJpAiZoE3zBJ77u8G
	GyUs4C/x8eBUsCIWAVWJ1dM+AjVzcPAKuEr8PFwKsU1BYtnymawgNidQuOtMHzuILSTgIvGr
	9SP7BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY/2Z1A7GlQ0WhxgFOBiVeHhP
	nK8JEWJNLCuuzD3EKMHBrCTC+8u4NkSINyWxsiq1KD++qDQntfgQoynQUROZpUST84FpKK8k
	3tDYxMzI0sjc0MLI2FxJnPfGzdwQIYH0xJLU7NTUgtQimD4mDk6pBkbrJ2IiHfL69albE6cE
	cRiYJzxUfWWWq7ToY4fHjdmC/1S0pdXrFW6eOb+l8N27sBn/j3rdCjzBIb/KVUQs81dgifzl
	WS9n5Xqc8y6MStlr9uctM7vuR8+wRMFdf5cr3eKqsH7F6fU1++MPg2CTWztUJlRPUC6U2mDU
	vCQ1Xe5/YP/aNY/+3lViKc5INNRiLipOBAC3hcGbCwMAAA==
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
 drivers/clk/samsung/clk-exynos5433.c               | 144 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  37 +++++-
 3 files changed, 188 insertions(+), 1 deletion(-)

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
index a7f5feb..00dcac3 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -540,6 +540,10 @@ static struct samsung_gate_clock top_gate_clks[] __initdata = {
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
@@ -3223,3 +3227,143 @@ static void __init exynos5433_cmu_g3d_init(struct device_node *np)
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
+			"mout_aclk_gscl_111_user", ENABLE_PCLK_GSCL,
+			3, CLK_IGNORE_UNUSED, 0),
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
index 04d4dbf..15d51b8 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -147,8 +147,10 @@
 #define CLK_SCLK_UFSUNIPRO_FSYS		229
 #define CLK_SCLK_USBHOST30_FSYS		230
 #define CLK_SCLK_USBDRD30_FSYS		231
+#define CLK_ACLK_GSCL_111		232
+#define CLK_ACLK_GSCL_333		233
 
-#define TOP_NR_CLK			232
+#define TOP_NR_CLK			234
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
@@ -805,4 +807,37 @@
 
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

