Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3JGB44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:56:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59821 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3JGB4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:56:53 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-30-525214e4c2d3
Date: Mon, 07 Oct 2013 10:56:51 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 10/20] clk: exynos: add gate clock descriptions of System
 MMU
Message-id: <20131007105651.da0427edf3fa77fe4038d65b@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY90nIkFBBm8XyFncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK+Pgxn0sBZcCK9b2v2duYGx36WLk5JAQMJHY
	1tjOBmGLSVy4tx7I5uIQEljGKLF52V5mmKK+M79YIRKLGCW+/VnGBOFMYpK4+qufCaSKRUBV
	4tfW6SwgNpuAlsTquccZQYpEBNqYJL42HmIBcZgFTjNLrNq9AmguB4ewQLBE78xAkAZeAUeJ
	hV0fodZZSFxo6mCHiAtK/Jh8D2woM9DQzduaWCFseYnNa94yg8yUEJjKIbFqzl42iCsEJL5N
	BlnGAZSQldh0AGqmpMTBFTdYJjCKzEIydhaSsbOQjF3AyLyKUTS1ILmgOCm9yFSvODG3uDQv
	XS85P3cTIySSJ+5gvH/A+hBjMtDKicxSosn5wESQVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1
	oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG3aSg0JbwE98XFDEWPjxw5Lqpz7WJzpvi3H5J
	KdVtlfwdm/dmzdILSgfibb5INrP475jxUYr9k3nVqWd5+6+0Pqt2XeH5iE3P+P89j+sNdztv
	nD83Z1lAfvZ9663WXzgcdHY9Kmi8seDIloSVQesP2gswGKr4GbcFGBeFTPwQFWmxhuuzSHa5
	EktxRqKhFnNRcSIAeUzNNPoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd0nIkFBBp37JCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj4MZ9
	LAWXAivW9r9nbmBsd+li5OSQEDCR6DvzixXCFpO4cG89WxcjF4eQwCJGiW9/ljFBOJOYJK7+
	6mcCqWIRUJX4tXU6C4jNJqAlsXrucUaQIhGBNiaJr42HWEAcZoHTzBKrdq9g7mLk4BAWCJbo
	nRkI0sAr4CixsOsjM8Q6C4kLTR3sEHFBiR+T74ENZQYaunlbEyuELS+xec1b5gmMfLOQlM1C
	UjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFp4pn0DsZVDRaHGAU4GJV4eHfc
	DwwSYk0sK67MPcQowcGsJMJ7qQ4oxJuSWFmVWpQfX1Sak1p8iDEZ6O2JzFKiyfnAFJZXEm9o
	bGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwTD0cI8oQyqfMdep/v
	EyKwKuNE876T4d5nZLYpVbidPxCidmRbSuvmpQol11+JKTPV3JtZZW35I7Gz++OyeTxThHsc
	eX9xHd5rXLr71L+6tXqzq1zUq0K5nWzcF5r6vpN8MKdxR1Bv7MH8G55xd2uDLSNNcqfs6Vp1
	6teRhwJ80yxfOP31nqLEUpyRaKjFXFScCADdCfMLVwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds gate clocks of all System MMUs and their master IPs
that are not apeared in clk-exynos5250.c and clk-exynos5420.c
Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
for System MMU clocks in clk-exynos4.c

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +++++++++++
 .../devicetree/bindings/clock/exynos5420-clock.txt |    3 +
 drivers/clk/samsung/clk-exynos5250.c               |   49 ++++++++++++++++++-
 drivers/clk/samsung/clk-exynos5420.c               |   12 ++++-
 4 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 24765c1..929cfba 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -159,6 +159,34 @@ clock which they consume.
   mixer			343
   hdmi			344
   g2d			345
+  smmu_fimc_lite0	346
+  smmu_fimc_lite1	347
+  smmu_fimc_lite2	348
+  smmu_tv		349
+  smmu_fimd1		350
+  smmu_2d		351
+  fimc_isp		352
+  fimc_drc		353
+  fimc_fd		354
+  fimc_scc		355
+  fimc_scp		356
+  fimc_mcuctl		357
+  fimc_odc		358
+  fimc_dis		359
+  fimc_3dnr		360
+  smmu_fimc_isp		361
+  smmu_fimc_drc		362
+  smmu_fimc_fd		363
+  smmu_fimc_scc		364
+  smmu_fimc_scp		365
+  smmu_fimc_mcuctl	366
+  smmu_fimc_odc		367
+  smmu_fimc_dis0	368
+  smmu_fimc_dis1	369
+  smmu_fimc_3dnr	370
+  camif_top		371
+  mdma0			372
+  smmu_mdma0		373
 
 
    [Clock Muxes]
diff --git a/Documentation/devicetree/bindings/clock/exynos5420-clock.txt b/Documentation/devicetree/bindings/clock/exynos5420-clock.txt
index 32aa34e..09dfa44 100644
--- a/Documentation/devicetree/bindings/clock/exynos5420-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5420-clock.txt
@@ -172,12 +172,15 @@ clock which they consume.
   mdma0			473
   aclk333_g2d		480
   g2d			481
+  smmu_g2d		482
   aclk333_432_gscl	490
   smmu_3aa		491
   smmu_fimcl0		492
   smmu_fimcl1		493
   smmu_fimcl3		494
   fimc_lite3		495
+  fimc_lite0		496
+  fimc_lite1		497
   aclk_g3d		500
   g3d			501
   smmu_mixer		502
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index adf3234..c0312db 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -34,6 +34,7 @@
 #define VPLL_CON0		0x10140
 #define GPLL_CON0		0x10150
 #define SRC_TOP0		0x10210
+#define SRC_TOP1		0x10214
 #define SRC_TOP2		0x10218
 #define SRC_GSCL		0x10220
 #define SRC_DISP1_0		0x1022c
@@ -64,6 +65,8 @@
 #define DIV_PERIC3		0x10564
 #define DIV_PERIC4		0x10568
 #define DIV_PERIC5		0x1056c
+#define GATE_IP_ISP0		0x0C800
+#define GATE_IP_ISP1		0x0C800
 #define GATE_IP_GSCL		0x10920
 #define GATE_IP_MFC		0x1092c
 #define GATE_IP_GEN		0x10934
@@ -75,7 +78,7 @@
 #define SRC_CDREX		0x20200
 #define PLL_DIV2_SEL		0x20a24
 #define GATE_IP_DISP1		0x10928
-#define GATE_IP_ACP		0x10000
+#define GATE_IP_ACP		0x18800
 
 /* list of PLLs to be registered */
 enum exynos5250_plls {
@@ -121,6 +124,13 @@ enum exynos5250_clks {
 	hsi2c3, chipid, sysreg, pmu, cmu_top, cmu_core, cmu_mem, tzpc0, tzpc1,
 	tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
 	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d,
+	smmu_fimc_lite0 = 346, smmu_fimc_lite1, smmu_fimc_lite2,
+	smmu_tv, smmu_fimd1, smmu_2d,
+	fimc_isp, fimc_drc, fimc_fd, fimc_scc, fimc_scp, fimc_mcuctl, fimc_odc,
+	fimc_dis, fimc_3dnr,
+	smmu_fimc_isp, smmu_fimc_drc, smmu_fimc_fd, smmu_fimc_scc,
+	smmu_fimc_scp, smmu_fimc_mcuctl, smmu_fimc_odc, smmu_fimc_dis0,
+	smmu_fimc_dis1, smmu_fimc_3dnr, camif_top, mdma0, smmu_mdma0,
 
 	/* mux clocks */
 	mout_hdmi = 1024,
@@ -194,6 +204,7 @@ PNAME(mout_mpll_user_p)	= { "fin_pll", "sclk_mpll" };
 PNAME(mout_bpll_user_p)	= { "fin_pll", "sclk_bpll" };
 PNAME(mout_aclk166_p)	= { "sclk_cpll", "sclk_mpll_user" };
 PNAME(mout_aclk200_p)	= { "sclk_mpll_user", "sclk_bpll_user" };
+PNAME(mout_aclk400_isp_p)	= { "sclk_mpll_user", "sclk_bpll_user" };
 PNAME(mout_hdmi_p)	= { "div_hdmi_pixel", "sclk_hdmiphy" };
 PNAME(mout_usb3_p)	= { "sclk_mpll_user", "sclk_cpll" };
 PNAME(mout_group1_p)	= { "fin_pll", "fin_pll", "sclk_hdmi27m",
@@ -252,6 +263,7 @@ static struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
 	MUX(none, "mout_aclk166", mout_aclk166_p, SRC_TOP0, 8, 1),
 	MUX(none, "mout_aclk333", mout_aclk166_p, SRC_TOP0, 16, 1),
 	MUX(none, "mout_aclk200", mout_aclk200_p, SRC_TOP0, 12, 1),
+	MUX(none, "mout_aclk400_isp", mout_aclk400_isp_p, SRC_TOP1, 24, 1),
 	MUX(none, "mout_cam_bayer", mout_group1_p, SRC_GSCL, 12, 4),
 	MUX(none, "mout_cam0", mout_group1_p, SRC_GSCL, 16, 4),
 	MUX(none, "mout_cam1", mout_group1_p, SRC_GSCL, 20, 4),
@@ -291,6 +303,7 @@ static struct samsung_div_clock exynos5250_div_clks[] __initdata = {
 	DIV(none, "aclk166", "mout_aclk166", DIV_TOP0, 8, 3),
 	DIV(none, "aclk333", "mout_aclk333", DIV_TOP0, 20, 3),
 	DIV(none, "aclk200", "mout_aclk200", DIV_TOP0, 12, 3),
+	DIV(none, "aclk400_isp", "mout_aclk400_isp", DIV_TOP1, 20, 3),
 	DIV(none, "div_cam_bayer", "mout_cam_bayer", DIV_GSCL, 12, 4),
 	DIV(none, "div_cam0", "mout_cam0", DIV_GSCL, 16, 4),
 	DIV(none, "div_cam1", "mout_cam1", DIV_GSCL, 20, 4),
@@ -353,9 +366,16 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
 	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
 	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
+	GATE(camif_top, "camif_top", "aclk266", GATE_IP_GSCL, 4, 0, 0),
+	GATE(smmu_fimc_lite0, "smmu_fimc_lite0", "aclk266",
+						GATE_IP_GSCL, 12, 0, 0),
+	GATE(smmu_fimc_lite1, "smmu_fimc_lite1", "aclk266",
+						GATE_IP_GSCL, 13, 0, 0),
+	GATE(smmu_fimc_lite2, "smmu_fimc_lite2", "aclk266",
+						GATE_IP_GSCL, 14, 0, 0),
 	GATE(mfc, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
-	GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
-	GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 2, 0, 0),
+	GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 1, 0, 0),
+	GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 2, 0, 0),
 	GATE(rotator, "rotator", "aclk266", GATE_IP_GEN, 1, 0, 0),
 	GATE(jpeg, "jpeg", "aclk166", GATE_IP_GEN, 2, 0, 0),
 	GATE(mdma1, "mdma1", "aclk266", GATE_IP_GEN, 4, 0, 0),
@@ -492,6 +512,29 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(mixer, "mixer", "mout_aclk200_disp1", GATE_IP_DISP1, 5, 0, 0),
 	GATE(hdmi, "hdmi", "mout_aclk200_disp1", GATE_IP_DISP1, 6, 0, 0),
 	GATE(g2d, "g2d", "aclk200", GATE_IP_ACP, 3, 0, 0),
+	GATE(smmu_tv, "smmu_tv", "aclk200", GATE_IP_DISP1, 2, 0, 0),
+	GATE(smmu_fimd1, "smmu_fimd1", "aclk200", GATE_IP_DISP1, 8, 0, 0),
+
+	GATE(smmu_fimc_isp, "smmu_fimc_isp", "aclk400_isp", GATE_IP_ISP0, 8, 0, 0),
+	GATE(smmu_fimc_drc, "smmu_fimc_drc", "aclk400_isp", GATE_IP_ISP0, 9, 0, 0),
+	GATE(smmu_fimc_fd, "smmu_fimc_fd", "aclk400_isp", GATE_IP_ISP0, 10, 0, 0),
+	GATE(smmu_fimc_scc, "smmu_fimc_scc", "aclk400_isp",
+							GATE_IP_ISP0, 11, 0, 0),
+	GATE(smmu_fimc_scp, "smmu_fimc_scp", "aclk400_isp",
+							GATE_IP_ISP0, 12, 0, 0),
+	GATE(smmu_fimc_mcuctl, "smmu_fimc_mcuctl", "aclk400_isp",
+							GATE_IP_ISP0, 13, 0, 0),
+	GATE(smmu_fimc_odc, "smmu_fimc_odc", "aclk400_isp", GATE_IP_ISP1, 4, 0, 0),
+	GATE(smmu_fimc_dis0, "smmu_fimc_dis0", "aclk400_isp",
+							GATE_IP_ISP1, 5, 0, 0),
+	GATE(smmu_fimc_dis1, "smmu_fimc_dis1", "aclk400_isp",
+							GATE_IP_ISP1, 6, 0, 0),
+	GATE(smmu_fimc_3dnr, "smmu_fimc_3dnr", "aclk400_isp",
+							GATE_IP_ISP1, 7, 0, 0),
+
+	GATE(smmu_2d, "smmu_2d", "aclk200", GATE_IP_ACP, 7, 0, 0),
+	GATE(mdma0, "mdma0", "aclk200", GATE_IP_ACP, 1, 0, 0),
+	GATE(smmu_mdma0, "smmu_mdma0", "aclk200", GATE_IP_ACP, 5, 0, 0),
 };
 
 static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 48c4a93..7f379cf 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -80,6 +80,7 @@
 #define GATE_BUS_PERIC1		0x10754
 #define GATE_BUS_PERIS0		0x10760
 #define GATE_BUS_PERIS1		0x10764
+#define GATE_IP_G2D		0x08800
 #define GATE_IP_GSCL0		0x10910
 #define GATE_IP_GSCL1		0x10920
 #define GATE_IP_MFC		0x1092c
@@ -137,8 +138,8 @@ enum exynos5420_clks {
 	smmu_rotator, smmu_mdma1, aclk300_jpeg = 450, jpeg, jpeg2, smmu_jpeg,
 	aclk300_gscl = 460, smmu_gscl0, smmu_gscl1, gscl_wa, gscl_wb, gscl0,
 	gscl1, clk_3aa, aclk266_g2d = 470, sss, slim_sss, mdma0,
-	aclk333_g2d = 480, g2d, aclk333_432_gscl = 490, smmu_3aa, smmu_fimcl0,
-	smmu_fimcl1, smmu_fimcl3, fimc_lite3, aclk_g3d = 500, g3d, smmu_mixer,
+	aclk333_g2d = 480, g2d, smmu_g2d, aclk333_432_gscl = 490, smmu_3aa, smmu_fimcl0,
+	smmu_fimcl1, smmu_fimcl3, fimc_lite3, fimc_lite0, fimc_lite1, aclk_g3d = 500, g3d, smmu_mixer,
 
 	/* mux clocks */
 	mout_hdmi = 640,
@@ -198,6 +199,7 @@ static unsigned long exynos5420_clk_regs[] __initdata = {
 	GATE_BUS_PERIC1,
 	GATE_BUS_PERIS0,
 	GATE_BUS_PERIS1,
+	GATE_IP_G2D,
 	GATE_IP_GSCL0,
 	GATE_IP_GSCL1,
 	GATE_IP_MFC,
@@ -701,6 +703,10 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	GATE(gscl_wb, "gscl_wb", "aclk300_gscl", GATE_IP_GSCL1, 13, 0, 0),
 	GATE(smmu_fimcl3, "smmu_fimcl3,", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 16, 0, 0),
+	GATE(fimc_lite0, "fimc_lite0", "aclk333_432_gscl",
+			GATE_IP_GSCL0, 5, 0, 0),
+	GATE(fimc_lite1, "fimc_lite1", "aclk333_432_gscl",
+			GATE_IP_GSCL0, 6, 0, 0),
 	GATE(fimc_lite3, "fimc_lite3", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 17, 0, 0),
 
@@ -732,6 +738,8 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	GATE(smmu_mscl1, "smmu_mscl1", "aclk400_mscl", GATE_IP_MSCL, 9, 0, 0),
 	GATE(smmu_mscl2, "smmu_mscl2", "aclk400_mscl", GATE_IP_MSCL, 10, 0, 0),
 	GATE(smmu_mixer, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0, 0),
+	GATE(g2d, "g2d", "aclk333_g2d", GATE_IP_G2D, 3, 0, 0),
+	GATE(smmu_g2d, "smmu_g2d", "aclk333_g2d", GATE_IP_G2D, 7, 0, 0),
 };
 
 static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
-- 
1.7.2.5

