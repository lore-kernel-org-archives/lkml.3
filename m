Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab3GZL17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:27:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50970 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3GZL14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:27:56 -0400
X-AuditID: cbfee68e-b7f276d000002279-65-51f25d3a8a1a
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
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: [PATCH v8 05/12] clk: exynos5250: add gate clock descriptions of
 System MMU
Date: Fri, 26 Jul 2013 20:27:54 +0900
Message-id: <003b01ce89f3$2be4db80$83ae9280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8aUC2ezIfhEaTWaj52z2mFlC6w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zka5V7KdAg1sTLS3u3D3HavHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFl8PHWc3WLT42usFpd3zWGzmHF+H5PFhRUb2S2m
	LDrManHyTy+jRcv1XiaLYzOWMDoIeDw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0
	bVnF6PF5k5zHlaNnmAI4o7hsUlJzMstSi/TtErgydvcfYyw4YlBxYVInUwPjfI0uRk4OCQET
	ibYbV5khbDGJC/fWs3UxcnEICSxjlHj18jsrTNHZvX+ZIRLTGSW2bO9ignD+MkrMaZ7DCFLF
	JqAlsXrucTBbROAuo8TL8zwgRcwC3SwSm972sYMkhAXCJM4tfQE2lkVAVeLR9cdgNq+ApcT6
	ax3MELagxI/J91hAbGagoet3HmeCsOUlNq95C3WrgsSOs6+hlulJ7Px+CapeRGLfi3eMIIsl
	BFZySEz99YUNYpmAxLfJh4CKOIASshKbDkDNkZQ4uOIGywRGsVlIVs9CsnoWktWzkKxYwMiy
	ilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkIfTtYLx5wPoQYzLQ+onMUqLJ+cCEklcSb2hs
	ZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRsX1fOXrDgu3
	3/n3MDPZf9cy2Q/RNxdsiHTrkzXSTFp+3ffkScNq6Un9p2uPnksWvujon3Xm6vuW3Hs/oj+d
	f7V3Csejv10L5O42bF28TJ6le1HGz/erbhTxTP52RUD52KKfDZ0nBTemxeomJd0MeGB8ofzZ
	2z021rrX8hf9K3tky6SUm59xZYkSS3FGoqEWc1FxIgD6s1pGHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQV2r2E+BBg9uGFvcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwWx2YsYXQQ8HhycB6Tx+yGiywed67tYfM4v2kNs8fmJfUek28sZ/To
	27KK0ePzJjmPK0fPMAVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl
	5qbaKrn4BOi6ZeYAvaGkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjd
	f4yx4IhBxYVJnUwNjPM1uhg5OSQETCTO7v3LDGGLSVy4t56ti5GLQ0hgOqPElu1dTBDOX0aJ
	Oc1zGEGq2AS0JFbPPQ5miwjcZZR4eZ4HpIhZoJtFYtPbPnaQhLBAmMS5pS9YQWwWAVWJR9cf
	g9m8ApYS6691MEPYghI/Jt9jAbGZgYau33mcCcKWl9i85i3USQoSO86+hlqmJ7Hz+yWoehGJ
	fS/eMU5gFJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB6eaZ
	9A7GVQ0WhxgFOBiVeHgVnD4GCrEmlhVX5h5ilOBgVhLhve79KVCINyWxsiq1KD++qDQntfgQ
	YzLQpxOZpUST84GpMK8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4
	OKUaGLV2XWB3yPhRfuDtoU2sm+tY/Lm610pc8/mzdJJDl/zZpovdrxTEa05YX+fjDXy1nXeG
	ddiNi3+/1YpdNfu4T+lX6DT9czqCJg86vT5sMHzB9Ntg/Zoo5pAUftutq9pz1j9ybJsdft3z
	zzbbCzZLTj1JzlAucNnJ1f+VJaU1XGxi2zRB/S2mtkosxRmJhlrMRcWJAHbicX97AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds gate clocks of all System MMUs and their master IPs
that are not apeared in clk-exynos5250.c

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
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
index 22d7699..e242bde 100644
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


