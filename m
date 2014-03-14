Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaCNFG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:06:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51240 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbaCNFGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:06:23 -0400
X-AuditID: cbfee68e-b7f566d000002344-b2-53228e4d073f
Date: Fri, 14 Mar 2014 14:06:21 +0900
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 11/27] clk: exynos: add gate clock descriptions of System
 MMU
Message-id: <20140314140621.14df1e40601c4f6a2487b5a8@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ13fPqVgg2PvLSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mr4NIOn4J9hxbFl+g2MOzS7GDk4JARMJNbeDOxi5AQy
	xSQu3FvP1sXIxSEksIxR4uy+BkaIhInEvxVHGSES0xkldh77xQzhTGaSOD1pCgtIFYuAqsSr
	C9/AbDYBLYnVc4+DdYgItDFJfG08xALiMAvMZZb4+G0OG0iVsECwxLezM9hBbF4BR4nWxr8s
	EPssJC40dUDFBSV+TL4HFmcGmrp5WxMrhC0vsXnNW7AzJAQ6OSSObG1mhjhDQOLbZJBtIM/J
	Smw6wAwxU1Li4IobLBMYRWYhGTsLydhZSMYuYGRexSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7
	iRESu307GG8esD7EmAy0ciKzlGhyPjD280riDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD4/zqULadUYUHXqx7xCxoHu497/TV+5fVnqdFJnKcf/vW
	40nljaW/1+pKOhmfZRIomH9ZgDFxlYjk5fAEnSsnFzfNiFx0bfv/HZE1+rIb1boSmGv5Hm2/
	vCJ9TtXZtef/BO996i16J+NS7sUyYT73ue7zvld65Nt5dyQz8O1pn39DUbW0OfKfhhJLcUai
	oRZzUXEiAEqbqcnzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV3fPqVgg/UPjSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WkGT8E/w4pj
	y/QbGHdodjFyckgImEj8W3GUEcIWk7hwbz1bFyMXh5DAdEaJncd+MUM4k5kkTk+awgJSxSKg
	KvHqwjcwm01AS2L13OOMIEUiAm1MEl8bD7GAOMwCc5klPn6bwwZSJSwQLPHt7Ax2EJtXwFGi
	tfEvC8Q+C4kLTR1QcUGJH5PvgcWZgaZu3tbECmHLS2xe85Z5AiPfLCRls5CUzUJStoCReRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGp4JrWDcWWDxSFGAQ5GJR5eh8OKwUKsiWXFlbmH
	GCU4mJVEeKsilIKFeFMSK6tSi/Lji0pzUosPMSYD/T2RWUo0OR+YtvJK4g2NTcyMLI3MLIxM
	zM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTH8wP2WLO1wp10fi2V/mCrJTZ8Wmc3B
	cei0yhG/wOBlMwtyWWzFND7sDQybP5P79BE+pWnL+J26O05fv/rDJP7lxRBZiyVqc/c8cNoW
	9NKU67v/n7NnVMwF/hQmLPxfo/Kj4FYeV+/GlV1cqTuijszPW7db971lMFvw4aUZNsVzQhg4
	bE40PVBiKc5INNRiLipOBAAWvR0sUQMAAA==
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
 .../devicetree/bindings/clock/exynos5250-clock.txt |    3 +++
 .../devicetree/bindings/clock/exynos5420-clock.txt |    6 +++++-
 drivers/clk/samsung/clk-exynos5250.c               |    5 +++++
 drivers/clk/samsung/clk-exynos5420.c               |   13 +++++++++++--
 include/dt-bindings/clock/exynos5250.h             |    4 ++++
 include/dt-bindings/clock/exynos5420.h             |    6 +++++-
 6 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 72ce617..67e50ba 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -162,6 +162,9 @@ clock which they consume.
   g2d			345
   mdma0			346
   smmu_mdma0		347
+  smmu_tv		348
+  smmu_fimd1		349
+  smmu_2d		350
 
 
    [Clock Muxes]
diff --git a/Documentation/devicetree/bindings/clock/exynos5420-clock.txt b/Documentation/devicetree/bindings/clock/exynos5420-clock.txt
index 458f347..62dabc3 100644
--- a/Documentation/devicetree/bindings/clock/exynos5420-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5420-clock.txt
@@ -146,7 +146,8 @@ clock which they consume.
   hdmi			413
   aclk300_disp1		420
   fimd1			421
-  smmu_fimd1		422
+  smmu_fimd1m0		422
+  smmu_fimd1m1		423
   aclk166		430
   mixer			431
   aclk266		440
@@ -172,12 +173,15 @@ clock which they consume.
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
index e7ee442..6605733 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -615,6 +615,11 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(CLK_WDT, "wdt", "div_aclk66", GATE_IP_PERIS, 19, 0, 0),
 	GATE(CLK_RTC, "rtc", "div_aclk66", GATE_IP_PERIS, 20, 0, 0),
 	GATE(CLK_TMU, "tmu", "div_aclk66", GATE_IP_PERIS, 21, 0, 0),
+	GATE(CLK_SMMU_TV, "smmu_tv", "mout_aclk200_disp1_sub",
+		GATE_IP_DISP1, 2, 0, 0),
+	GATE(CLK_SMMU_FIMD1, "smmu_fimd1", "mout_aclk200_disp1_sub",
+		GATE_IP_DISP1, 8, 0, 0),
+	GATE(CLK_SMMU_2D, "smmu_2d", "div_aclk200", GATE_IP_ACP, 7, 0, 0),
 };
 
 static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 60b2681..b58e4d3 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -82,6 +82,7 @@
 #define GATE_BUS_PERIC1		0x10754
 #define GATE_BUS_PERIS0		0x10760
 #define GATE_BUS_PERIS1		0x10764
+#define GATE_IP_G2D		0x08800
 #define GATE_IP_GSCL0		0x10910
 #define GATE_IP_GSCL1		0x10920
 #define GATE_IP_MFC		0x1092c
@@ -707,6 +708,10 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	GATE(CLK_GSCL_WB, "gscl_wb", "aclk300_gscl", GATE_IP_GSCL1, 13, 0, 0),
 	GATE(CLK_SMMU_FIMCL3, "smmu_fimcl3,", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 16, 0, 0),
+	GATE(CLK_FIMC_LITE0, "fimc_lite0", "aclk333_432_gscl",
+			GATE_IP_GSCL0, 5, 0, 0),
+	GATE(CLK_FIMC_LITE1, "fimc_lite1", "aclk333_432_gscl",
+			GATE_IP_GSCL0, 6, 0, 0),
 	GATE(CLK_FIMC_LITE3, "fimc_lite3", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 17, 0, 0),
 
@@ -715,8 +720,10 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 	GATE(CLK_DP1, "dp1", "aclk200_disp1", GATE_IP_DISP1, 4, 0, 0),
 	GATE(CLK_MIXER, "mixer", "aclk166", GATE_IP_DISP1, 5, 0, 0),
 	GATE(CLK_HDMI, "hdmi", "aclk200_disp1", GATE_IP_DISP1, 6, 0, 0),
-	GATE(CLK_SMMU_FIMD1, "smmu_fimd1", "aclk300_disp1", GATE_IP_DISP1, 8, 0,
-		0),
+	GATE(CLK_SMMU_FIMD1M0, "smmu_fimd1m0", "aclk300_disp1", GATE_IP_DISP1,
+		7, 0, 0),
+	GATE(CLK_SMMU_FIMD1M1, "smmu_fimd1m1", "aclk300_disp1", GATE_IP_DISP1,
+		8, 0, 0),
 
 	GATE(CLK_MFC, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
 	GATE(CLK_SMMU_MFCL, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
@@ -743,6 +750,8 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 		0),
 	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
 		0),
+	GATE(CLK_G2D, "g2d", "aclk333_g2d", GATE_IP_G2D, 3, 0, 0),
+	GATE(CLK_SMMU_G2D, "smmu_g2d", "aclk333_g2d", GATE_IP_G2D, 7, 0, 0),
 };
 
 static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
diff --git a/include/dt-bindings/clock/exynos5250.h b/include/dt-bindings/clock/exynos5250.h
index 922f2dc..2648ce7 100644
--- a/include/dt-bindings/clock/exynos5250.h
+++ b/include/dt-bindings/clock/exynos5250.h
@@ -150,6 +150,10 @@
 #define CLK_G2D			345
 #define CLK_MDMA0		346
 #define CLK_SMMU_MDMA0		347
+#define CLK_SMMU_TV		348
+#define CLK_SMMU_FIMD1		349
+#define CLK_SMMU_2D		350
+
 
 /* mux clocks */
 #define CLK_MOUT_HDMI		1024
diff --git a/include/dt-bindings/clock/exynos5420.h b/include/dt-bindings/clock/exynos5420.h
index 5eefd88..25dedca 100644
--- a/include/dt-bindings/clock/exynos5420.h
+++ b/include/dt-bindings/clock/exynos5420.h
@@ -140,7 +140,8 @@
 #define CLK_HDMI		413
 #define CLK_ACLK300_DISP1	420
 #define CLK_FIMD1		421
-#define CLK_SMMU_FIMD1		422
+#define CLK_SMMU_FIMD1M0	422
+#define CLK_SMMU_FIMD1M1	423
 #define CLK_ACLK166		430
 #define CLK_MIXER		431
 #define CLK_ACLK266		440
@@ -166,12 +167,15 @@
 #define CLK_MDMA0		473
 #define CLK_ACLK333_G2D		480
 #define CLK_G2D			481
+#define CLK_SMMU_G2D		482
 #define CLK_ACLK333_432_GSCL	490
 #define CLK_SMMU_3AA		491
 #define CLK_SMMU_FIMCL0		492
 #define CLK_SMMU_FIMCL1		493
 #define CLK_SMMU_FIMCL3		494
 #define CLK_FIMC_LITE3		495
+#define CLK_FIMC_LITE1		496
+#define CLK_FIMC_LITE0		497
 #define CLK_ACLK_G3D		500
 #define CLK_G3D			501
 #define CLK_SMMU_MIXER		502
-- 
1.7.9.5

