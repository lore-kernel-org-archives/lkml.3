Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab3GEM3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36112 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883Ab3GEM3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:35 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b6-51d6bc2df359
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: [PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of System
 MMU
Date: Fri, 05 Jul 2013 21:29:33 +0900
Message-id: <002e01ce797b$4dc46d20$e94d4760$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d7xRykbUty4fTjiTNf7+/hql/Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zI13dPdcCDd5slbF4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mSyO
	zVjC6MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APYrLJiU1J7MstUjf
	LoEr4+HbI0wFrYYVL1q3MDUw3tboYuTgkBAwkWidldnFyAlkiklcuLeerYuRi0NIYBmjxMKu
	3UwwNRdeC0DEFzFK/N4+HaroL6PE9xnNzCDdbAJaEqvnHmcEsUUE7jJKvDzPA1LELNDBLLFs
	yjywImGBEIm7y9vZQWwWAVWJYxO+gdm8ApYSX/tfsEHYghI/Jt9jAbGZgYau33mcCcKWl9i8
	5i0zxKkKEjvOvoZapiex+u5tNogaEYl9L94xgiyWEOjlkNi4eynUMgGJb5MPsUC8Iyux6QDU
	HEmJgytusExgFJuFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFC
	YnvCDsZ7B6wPMSYDrZ/ILCWanA9MDXkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYMxxtD3UfF3TVXEhc+829emZG/9sP6z6yuH294lLMlgK759N
	u3isnl9T3uabx0XBpF05hROvK1pcqrwWZMUxb8WaEL5Xe2oSFnhs+/2hY0/ywp8dVlv/8nLI
	FS+cedbvH/t8+TRXzcfHF35ZKhtrwKGw9KXy+/eXty8KzZY+FLt596HveidutBxSYinOSDTU
	Yi4qTgQAlQmXQgMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAV3dPdcCDU5/FLN4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mSyO
	zVjC6MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bDt0eYCloNK160bmFqYLyt0cXIwSEhYCJx4bVA
	FyMnkCkmceHeerYuRi4OIYFFjBK/t0+Hcv4ySnyf0cwMUsUmoCWxeu5xRhBbROAuo8TL8zwg
	RcwCHcwSy6bMAysSFgiRuLu8nR3EZhFQlTg24RuYzStgKfG1/wUbhC0o8WPyPRYQmxlo6Pqd
	x5kgbHmJzWveMkOcpCCx4+xrqGV6Eqvv3maDqBGR2PfiHeMERoFZSEbNQjJqFpJRs5C0LGBk
	WcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnDqeSe9gXNVgcYhRgINRiYf3Qf3VQCHWxLLi
	ytxDjBIczEoivPYJ1wKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+Y1vJK4g2NTcyMLI3M
	LIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbF+I5NwBPffBMYt/5KvaUpMYu65
	ti7v3nz5nOQ3Yb1iVR98FXoXGPHdrdSZE1ajoKacdDf7dlpKy/cvp1/f2W6osL7vpfPMhMUP
	5O0fLa0IMTV+qD7ZYbnCh/kf529i7Tpxz93gx+YVD+N/vWvtevWEfU6auPi1j7pW/0Se2vQe
	N/PePEt6WpASS3FGoqEWc1FxIgAKxPZmYQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds gate clocks of all System MMUs and their master IPs
that are not apeared in clk-exynos5250.c

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
CC: Thomas Abraham <thomas.abraham@linaro.org>
---
 .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +++++++++-
 drivers/clk/samsung/clk-exynos5250.c               |   57 ++++++++++++++++---
 2 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 781a627..df49694 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -154,7 +154,33 @@ clock which they consume.
   dsim0			341
   dp			342
   mixer			343
-  hdmi			345
+  hdmi			344
+  camif_top		345
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
 
 Example 1: An example of a clock controller node is listed below.
 
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index 22d7699..1921d6c 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -53,12 +53,15 @@
 #define DIV_PERIC3		0x10564
 #define DIV_PERIC4		0x10568
 #define DIV_PERIC5		0x1056c
+#define GATE_IP_ISP0		0x0C800
+#define GATE_IP_ISP1		0x0C800
 #define GATE_IP_GSCL		0x10920
 #define GATE_IP_MFC		0x1092c
 #define GATE_IP_GEN		0x10934
 #define GATE_IP_FSYS		0x10944
 #define GATE_IP_PERIC		0x10950
 #define GATE_IP_PERIS		0x10960
+#define GATE_IP_ACP		0x18800
 #define SRC_CDREX		0x20200
 #define PLL_DIV2_SEL		0x20a24
 #define GATE_IP_DISP1		0x10928
@@ -100,6 +103,14 @@ enum exynos5250_clks {
 	tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
 	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi,
 
+	camif_top, smmu_fimc_lite0, smmu_fimc_lite1, smmu_fimc_lite2,
+	smmu_tv, smmu_fimd1, smmu_2d,
+	fimc_isp, fimc_drc, fimc_fd, fimc_scc, fimc_scp, fimc_mcuctl, fimc_odc,
+	fimc_dis, fimc_3dnr,
+	smmu_fimc_isp, smmu_fimc_drc, smmu_fimc_fd, smmu_fimc_scc,
+	smmu_fimc_scp, smmu_fimc_mcuctl, smmu_fimc_odc, smmu_fimc_dis0,
+	smmu_fimc_dis1, smmu_fimc_3dnr,
+
 	nr_clks,
 };
 
@@ -320,19 +331,26 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
 	GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
 	GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
-	GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
-	GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
-	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
-	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
+	GATE(smmu_gscl0, "smmu_gscl0", "gscl0", GATE_IP_GSCL, 7, 0, 0),
+	GATE(smmu_gscl1, "smmu_gscl1", "gscl1", GATE_IP_GSCL, 8, 0, 0),
+	GATE(smmu_gscl2, "smmu_gscl2", "gscl2", GATE_IP_GSCL, 9, 0, 0),
+	GATE(smmu_gscl3, "smmu_gscl3", "gscl3", GATE_IP_GSCL, 10, 0, 0),
+	GATE(camif_top, "camif_top", "aclk266", GATE_IP_GSCL, 4, 0, 0),
+	GATE(smmu_fimc_lite0, "smmu_fimc_lite0", "camif_top",
+						GATE_IP_GSCL, 12, 0, 0),
+	GATE(smmu_fimc_lite1, "smmu_fimc_lite1", "camif_top",
+						GATE_IP_GSCL, 13, 0, 0),
+	GATE(smmu_fimc_lite2, "smmu_fimc_lite2", "camif_top",
+						GATE_IP_GSCL, 14, 0, 0),
 	GATE(mfc, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
-	GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
-	GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 2, 0, 0),
+	GATE(smmu_mfcl, "smmu_mfcl", "mfc", GATE_IP_MFC, 1, 0, 0),
+	GATE(smmu_mfcr, "smmu_mfcr", "mfc", GATE_IP_MFC, 2, 0, 0),
 	GATE(rotator, "rotator", "aclk266", GATE_IP_GEN, 1, 0, 0),
 	GATE(jpeg, "jpeg", "aclk166", GATE_IP_GEN, 2, 0, 0),
 	GATE(mdma1, "mdma1", "aclk266", GATE_IP_GEN, 4, 0, 0),
-	GATE(smmu_rotator, "smmu_rotator", "aclk266", GATE_IP_GEN, 6, 0, 0),
-	GATE(smmu_jpeg, "smmu_jpeg", "aclk166", GATE_IP_GEN, 7, 0, 0),
-	GATE(smmu_mdma1, "smmu_mdma1", "aclk266", GATE_IP_GEN, 9, 0, 0),
+	GATE(smmu_rotator, "smmu_rotator", "none", GATE_IP_GEN, 6, 0, 0),
+	GATE(smmu_jpeg, "smmu_jpeg", "jpeg", GATE_IP_GEN, 7, 0, 0),
+	GATE(smmu_mdma1, "smmu_mdma1", "none", GATE_IP_GEN, 9, 0, 0),
 	GATE(pdma0, "pdma0", "aclk200", GATE_IP_FSYS, 1, 0, 0),
 	GATE(pdma1, "pdma1", "aclk200", GATE_IP_FSYS, 2, 0, 0),
 	GATE(sata, "sata", "aclk200", GATE_IP_FSYS, 6, 0, 0),
@@ -462,6 +480,27 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(dp, "dp", "aclk200", GATE_IP_DISP1, 4, 0, 0),
 	GATE(mixer, "mixer", "aclk200", GATE_IP_DISP1, 5, 0, 0),
 	GATE(hdmi, "hdmi", "aclk200", GATE_IP_DISP1, 6, 0, 0),
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
 
 static __initdata struct of_device_id ext_clk_match[] = {
-- 
1.7.2.5


