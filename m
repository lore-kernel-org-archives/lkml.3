Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3HHJiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:38:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28756 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097Ab3HHJiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:38:16 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-7d-52036706fda0
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 05/16] clk: exynos: add gate clock descriptions of System MMU
Date: Thu, 08 Aug 2013 18:38:14 +0900
Message-id: <002901ce941b$0130db50$039291f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF21rkP+2y4lXTreJWRzjpsxjiQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+ZkS5bOnOQwcLbVhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TA58Hk8OzmPymN1wkcXjzrU9bB7nN61h9ti8pN5j8o3ljB59W1YxenzeJOdx5egZ
	pgDOKC6blNSczLLUIn27BK6ML33f2Qqmu1bMf7SRtYHxpWUXIyeHhICJxPRNTawQtpjEhXvr
	2boYuTiEBJYxSrS3HGWHKZq8bjVUYhGjxKxpfewQzl9GiVO998Gq2AS0JFbPPc4IkhAR+M0o
	cevZHFYQh1ngP5PE1ttNYFXCAgESX7f9ZgaxWQRUJV4/2McIYvMKWEqc29jBBGELSvyYfI8F
	xGYGmrp+53EmCFteYvOat8wQNylI7Dj7GqxXREBP4trpP2wQNSIS+168Y4Somcshsb5fAGKX
	gMS3yYeAZnIAxWUlNh2AGiMpcXDFDZYJjGKzkGyehWTzLCSbZyHZsICRZRWjaGpBckFxUnqR
	oV5xYm5xaV66XnJ+7iZGSPT37mC8fcD6EGMy0PqJzFKiyfnA5JFXEm9obGZkYWpiamxkbmlG
	mrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsajm9K+rzF+3HFtyXlGjQvRKm9T
	vO4t6/kqMDuhoStl2wZBt4xtTx+V9Hwr1dbLebw4s2uJFQOvbfT7G0W8HRELVkjm591qejJn
	276F/sKtQlUvWH3MPGU2WkxckvTsiqJXy6boBQEWL683u1+1EHl67vBjU39jq+Y4P5+Qli2i
	nlMYDjSJzlViKc5INNRiLipOBAC/DCO9FAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAV22dOYgg9WtphZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TA58Hk8OzmPymN1wkcXjzrU9bB7nN61h9ti8pN5j8o3ljB59W1YxenzeJOdx5egZ
	pgDOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	45UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGV/6vrMVTHetmP9oI2sD
	40vLLkZODgkBE4nJ61azQdhiEhfurQeyuTiEBBYxSsya1scO4fxllDjVe58dpIpNQEti9dzj
	jCAJEYHfjBK3ns1hBXGYBf4zSWy93QRWJSwQIPF1229mEJtFQFXi9YN9jCA2r4ClxLmNHUwQ
	tqDEj8n3WEBsZqCp63ceZ4Kw5SU2r3nLDHGTgsSOs6/BekUE9CSunf7DBlEjIrHvxTvGCYwC
	s5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi5PJPawbiyweIQ
	owAHoxIPb0cAU5AQa2JZcWXuIUYJDmYlEd6LxUAh3pTEyqrUovz4otKc1OJDjMlAn05klhJN
	zgcmvrySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFy1VeiR
	1G5tv2vfbfSlTspd2i+TKa8gMaM/WSBe5EJu3l1z84Kab7/KbjqcafN9vz/rSap/2sMdrgtP
	HQjo21gkPlvOxT7EYY+hobhrR9Q536WW+dplK7/ExWhoB/Nef3spyX3HL82DybO4d7jXJPyp
	uuW97r7E7wNa6Zm2ng73rUVPrQhxVmIpzkg01GIuKk4EAAMyNXRyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds gate clocks of all System MMUs and their master IPs
that are not apeared in clk-exynos5250.c
Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
for System MMU clocks in clk-exynos4.c

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +++++++++
 drivers/clk/samsung/clk-exynos4.c                  |   27 +++------
 drivers/clk/samsung/clk-exynos5250.c               |   57 ++++++++++++++++----
 3 files changed, 82 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 24765c1..9c76710 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -159,6 +159,32 @@ clock which they consume.
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
 
 
    [Clock Muxes]
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 68f9a4a..92dcf03 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -705,29 +705,20 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			GATE_IP_CAM, 4, 0, 0, "fimc"),
 	GATE_DA(csis1, "s5p-mipi-csis.1", "csis1", "aclk160",
 			GATE_IP_CAM, 5, 0, 0, "fimc"),
-	GATE_DA(smmu_fimc0, "exynos-sysmmu.5", "smmu_fimc0", "aclk160",
-			GATE_IP_CAM, 7, 0, 0, "sysmmu"),
-	GATE_DA(smmu_fimc1, "exynos-sysmmu.6", "smmu_fimc1", "aclk160",
-			GATE_IP_CAM, 8, 0, 0, "sysmmu"),
-	GATE_DA(smmu_fimc2, "exynos-sysmmu.7", "smmu_fimc2", "aclk160",
-			GATE_IP_CAM, 9, 0, 0, "sysmmu"),
-	GATE_DA(smmu_fimc3, "exynos-sysmmu.8", "smmu_fimc3", "aclk160",
-			GATE_IP_CAM, 10, 0, 0, "sysmmu"),
-	GATE_DA(smmu_jpeg, "exynos-sysmmu.3", "smmu_jpeg", "aclk160",
-			GATE_IP_CAM, 11, 0, 0, "sysmmu"),
+	GATE(smmu_fimc0, "smmu_fimc0", "aclk160", GATE_IP_CAM, 7, 0, 0),
+	GATE(smmu_fimc1, "smmu_fimc1", "aclk160", GATE_IP_CAM, 8, 0, 0),
+	GATE(smmu_fimc2, "smmu_fimc2", "aclk160", GATE_IP_CAM, 9, 0, 0),
+	GATE(smmu_fimc3, "smmu_fimc3", "aclk160", GATE_IP_CAM, 10, 0, 0),
+	GATE(smmu_jpeg, "smmu_jpeg", "aclk160", GATE_IP_CAM, 11, 0, 0),
 	GATE(pixelasyncm0, "pxl_async0", "aclk160", GATE_IP_CAM, 17, 0, 0),
 	GATE(pixelasyncm1, "pxl_async1", "aclk160", GATE_IP_CAM, 18, 0, 0),
-	GATE_DA(smmu_tv, "exynos-sysmmu.2", "smmu_tv", "aclk160",
-			GATE_IP_TV, 4, 0, 0, "sysmmu"),
+	GATE(smmu_tv, "smmu_tv", "aclk160", GATE_IP_TV, 4, 0, 0),
 	GATE_DA(mfc, "s5p-mfc", "mfc", "aclk100", GATE_IP_MFC, 0, 0, 0, "mfc"),
-	GATE_DA(smmu_mfcl, "exynos-sysmmu.0", "smmu_mfcl", "aclk100",
-			GATE_IP_MFC, 1, 0, 0, "sysmmu"),
-	GATE_DA(smmu_mfcr, "exynos-sysmmu.1", "smmu_mfcr", "aclk100",
-			GATE_IP_MFC, 2, 0, 0, "sysmmu"),
+	GATE(smmu_mfcl, "smmu_mfcl", "aclk100", GATE_IP_MFC, 1, 0, 0),
+	GATE(smmu_mfcr, "smmu_mfcr", "aclk100", GATE_IP_MFC, 2, 0, 0),
 	GATE_DA(fimd0, "exynos4-fb.0", "fimd0", "aclk160",
 			GATE_IP_LCD0, 0, 0, 0, "fimd"),
-	GATE_DA(smmu_fimd0, "exynos-sysmmu.10", "smmu_fimd0", "aclk160",
-			GATE_IP_LCD0, 4, 0, 0, "sysmmu"),
+	GATE(smmu_fimd0, "smmu_fimd0", "aclk160", GATE_IP_LCD0, 4, 0, 0),
 	GATE_DA(pdma0, "dma-pl330.0", "pdma0", "aclk133",
 			GATE_IP_FSYS, 0, 0, 0, "dma"),
 	GATE_DA(pdma1, "dma-pl330.1", "pdma1", "aclk133",
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index df3628c..e945fcf 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -64,6 +64,8 @@
 #define DIV_PERIC3		0x10564
 #define DIV_PERIC4		0x10568
 #define DIV_PERIC5		0x1056c
+#define GATE_IP_ISP0		0x0C800
+#define GATE_IP_ISP1		0x0C800
 #define GATE_IP_GSCL		0x10920
 #define GATE_IP_MFC		0x1092c
 #define GATE_IP_GEN		0x10934
@@ -75,7 +77,7 @@
 #define SRC_CDREX		0x20200
 #define PLL_DIV2_SEL		0x20a24
 #define GATE_IP_DISP1		0x10928
-#define GATE_IP_ACP		0x10000
+#define GATE_IP_ACP		0x18800
 
 /* list of PLLs to be registered */
 enum exynos5250_plls {
@@ -121,6 +123,13 @@ enum exynos5250_clks {
 	hsi2c3, chipid, sysreg, pmu, cmu_top, cmu_core, cmu_mem, tzpc0, tzpc1,
 	tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
 	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d,
+	smmu_fimc_lite0 = 346, smmu_fimc_lite1, smmu_fimc_lite2,
+	smmu_tv, smmu_fimd1, smmu_2d,
+	fimc_isp, fimc_drc, fimc_fd, fimc_scc, fimc_scp, fimc_mcuctl, fimc_odc,
+	fimc_dis, fimc_3dnr,
+	smmu_fimc_isp, smmu_fimc_drc, smmu_fimc_fd, smmu_fimc_scc,
+	smmu_fimc_scp, smmu_fimc_mcuctl, smmu_fimc_odc, smmu_fimc_dis0,
+	smmu_fimc_dis1, smmu_fimc_3dnr, camif_top,
 
 	/* mux clocks */
 	mout_hdmi = 1024,
@@ -349,19 +358,26 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
 	GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
 	GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
-	GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
-	GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
-	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
-	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
+	GATE(smmu_gscl0, "smmu_gscl0", "none", GATE_IP_GSCL, 7, 0, 0),
+	GATE(smmu_gscl1, "smmu_gscl1", "none", GATE_IP_GSCL, 8, 0, 0),
+	GATE(smmu_gscl2, "smmu_gscl2", "none", GATE_IP_GSCL, 9, 0, 0),
+	GATE(smmu_gscl3, "smmu_gscl3", "none", GATE_IP_GSCL, 10, 0, 0),
+	GATE(camif_top, "camif_top", "aclk266", GATE_IP_GSCL, 4, 0, 0),
+	GATE(smmu_fimc_lite0, "smmu_fimc_lite0", "none",
+						GATE_IP_GSCL, 12, 0, 0),
+	GATE(smmu_fimc_lite1, "smmu_fimc_lite1", "none",
+						GATE_IP_GSCL, 13, 0, 0),
+	GATE(smmu_fimc_lite2, "smmu_fimc_lite2", "none",
+						GATE_IP_GSCL, 14, 0, 0),
 	GATE(mfc, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
-	GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
-	GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 2, 0, 0),
+	GATE(smmu_mfcr, "smmu_mfcr", "none", GATE_IP_MFC, 1, 0, 0),
+	GATE(smmu_mfcl, "smmu_mfcl", "none", GATE_IP_MFC, 2, 0, 0),
 	GATE(rotator, "rotator", "aclk266", GATE_IP_GEN, 1, 0, 0),
 	GATE(jpeg, "jpeg", "aclk166", GATE_IP_GEN, 2, 0, 0),
 	GATE(mdma1, "mdma1", "aclk266", GATE_IP_GEN, 4, 0, 0),
-	GATE(smmu_rotator, "smmu_rotator", "aclk266", GATE_IP_GEN, 6, 0, 0),
-	GATE(smmu_jpeg, "smmu_jpeg", "aclk166", GATE_IP_GEN, 7, 0, 0),
-	GATE(smmu_mdma1, "smmu_mdma1", "aclk266", GATE_IP_GEN, 9, 0, 0),
+	GATE(smmu_rotator, "smmu_rotator", "none", GATE_IP_GEN, 6, 0, 0),
+	GATE(smmu_jpeg, "smmu_jpeg", "none", GATE_IP_GEN, 7, 0, 0),
+	GATE(smmu_mdma1, "smmu_mdma1", "none", GATE_IP_GEN, 9, 0, 0),
 	GATE(pdma0, "pdma0", "aclk200", GATE_IP_FSYS, 1, 0, 0),
 	GATE(pdma1, "pdma1", "aclk200", GATE_IP_FSYS, 2, 0, 0),
 	GATE(sata, "sata", "aclk200", GATE_IP_FSYS, 6, 0, 0),
@@ -492,6 +508,27 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(mixer, "mixer", "aclk200", GATE_IP_DISP1, 5, 0, 0),
 	GATE(hdmi, "hdmi", "aclk200", GATE_IP_DISP1, 6, 0, 0),
 	GATE(g2d, "g2d", "aclk200", GATE_IP_ACP, 3, 0, 0),
+	GATE(smmu_tv, "smmu_tv", "none", GATE_IP_DISP1, 2, 0, 0),
+	GATE(smmu_fimd1, "smmu_fimd1", "none", GATE_IP_DISP1, 8, 0, 0),
+
+	GATE(smmu_fimc_isp, "smmu_fimc_isp", "none", GATE_IP_ISP0, 8, 0, 0),
+	GATE(smmu_fimc_drc, "smmu_fimc_drc", "none", GATE_IP_ISP0, 9, 0, 0),
+	GATE(smmu_fimc_fd, "smmu_fimc_fd", "none", GATE_IP_ISP0, 10, 0, 0),
+	GATE(smmu_fimc_scc, "smmu_fimc_scc", "none",
+							GATE_IP_ISP0, 11, 0, 0),
+	GATE(smmu_fimc_scp, "smmu_fimc_scp", "none",
+							GATE_IP_ISP0, 12, 0, 0),
+	GATE(smmu_fimc_mcuctl, "smmu_fimc_mcuctl", "none",
+							GATE_IP_ISP0, 13, 0, 0),
+	GATE(smmu_fimc_odc, "smmu_fimc_odc", "none", GATE_IP_ISP1, 4, 0, 0),
+	GATE(smmu_fimc_dis0, "smmu_fimc_dis0", "none",
+							GATE_IP_ISP1, 5, 0, 0),
+	GATE(smmu_fimc_dis1, "smmu_fimc_dis1", "none",
+							GATE_IP_ISP1, 6, 0, 0),
+	GATE(smmu_fimc_3dnr, "smmu_fimc_3dnr", "none",
+							GATE_IP_ISP1, 7, 0, 0),
+
+	GATE(smmu_2d, "smmu_2d", "none", GATE_IP_ACP, 7, 0, 0),
 };
 
 static __initdata struct samsung_pll_rate_table vpll_24mhz_tbl[] = {
-- 
1.7.2.5


