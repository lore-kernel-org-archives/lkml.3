Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaHSL54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:57:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30942 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaHSL5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:57:53 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-0e-53f33bbee17e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: kgene.kim@samsung.com, b.zolnierkie@samsung.com, amit.daniel@samsung.com,
        t.figa@samsung.com, l.majewski@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
Date: Tue, 19 Aug 2014 20:57:43 +0900
Message-id: <1408449463-3987-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSqLvP+nOwwY6J2hYNV0MsNs5Yz2px
	9/lhRovrX56zWsw/co7VYs3+n0wW869cY7XoXXCVzeJs0xt2izcPNzNabHoMFLu8aw6bxefe
	I4wWM87vY7J48rCPzWL9jNcsDgIeO2fdZfdYvOclk8fmJfUefVtWMXocv7GdyePzJrkAtigu
	m5TUnMyy1CJ9uwSujLNPlzIVrFCp6Jtl0MDYJ9/FyMkhIWAicfPaHSYIW0ziwr31bF2MXBxC
	AksZJa62b2GBKTq75gErRGI6o8Tf+WugqpqYJLbcX80IUsUmoCWx/8UNNhBbRMBAouPKDGYQ
	m1lgPrPE61YPEFtYIFRiV9N3dhCbRUBVYurq52D1vAIuEhPWnmaF2CYn8WHPI3aQBRICh9gl
	Lt9ZzALRICDxbfIhIJsDKCErsekAM0S9pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kpFecmFtc
	mpeul5yfu4kRGBen/z3r28F484D1IcZkoHETmaVEk/OBcZVXEm9obGZkYWpiamxkbmlGmrCS
	OO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgzvZ1f67fGij7l+sCjN+W/rN7VvX6+
	DouqD2z4EmFlMVXyp9HyI/cO2W4U4Ft1ue1ug4OxVOFJv97PP+s6z5+9s/Eg/95rrSY+Cwoi
	91s+qLyxNFfuxHzpKAGrlF0L94lXv1ywp+7r3D91LBNDX2k9SsoO65ovYquyMtCI/8X3XSFl
	rP+tU/WUWIozEg21mIuKEwEzZv1KoQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jQd191p+DDZZPULRouBpisXHGelaL
	u88PM1pc//Kc1WL+kXOsFmv2/2SymH/lGqtF74KrbBZnm96wW7x5uJnRYtNjoNjlXXPYLD73
	HmG0mHF+H5PFk4d9bBbrZ7xmcRDw2DnrLrvH4j0vmTw2L6n36NuyitHj+I3tTB6fN8kFsEU1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2tpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4+3QpU8EKlYq+WQYNjH3yXYyc
	HBICJhJn1zxghbDFJC7cW8/WxcjFISQwnVHi7/w1UE4Tk8SW+6sZQarYBLQk9r+4wQZiiwgY
	SHRcmcEMYjMLzGeWeN3qAWILC4RK7Gr6zg5iswioSkxd/RysnlfARWLC2tNQ2+QkPux5xD6B
	kXsBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCoeya1g3Flg8UhRgEORiUeXoUvH4OF
	WBPLiitzDzFKcDArifB2SH8OFuJNSaysSi3Kjy8qzUktPsRoCrR9IrOUaHI+MCHklcQbGpuY
	GVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgZNhT9D75SrrR7AUH9nPozVfi
	TPK5O3+uP1/4rLLKruLjc3Ud9/O92CShev6UTblJekaj82GX9GcP1hx7epy9UONT+o1PXA8t
	eU/us7Ke3WFwvKL+1SOZxwH/H928mvMrYsNzj7CoMgWRs07ZPbuC2fYFacpOKfjXu7qdm/8K
	h2hVubPX3NMrlViKMxINtZiLihMBohmoOtACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for TRIM_RELOAD feature at Exynos3250. The TMU of
Exynos3250 has two TRIMINFO_CON register.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 7 +++++--
 drivers/thermal/samsung/exynos_tmu.h      | 5 +++--
 drivers/thermal/samsung/exynos_tmu_data.c | 9 ++++++++-
 drivers/thermal/samsung/exynos_tmu_data.h | 7 +++++--
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index acbff14..ed01606 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -164,8 +164,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 
-	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
-		__raw_writel(1, data->base + reg->triminfo_ctrl);
+	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
+		for (i = 0; i < pdata->triminfo_reload_count; i++)
+			__raw_writel(pdata->triminfo_reload[i],
+					data->base + reg->triminfo_ctrl[i]);
+	}
 
 	if (pdata->cal_mode == HW_MODE)
 		goto skip_calib_data;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 1b4a644..72cb54e 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -151,8 +151,7 @@ struct exynos_tmu_registers {
 	u32	triminfo_25_shift;
 	u32	triminfo_85_shift;
 
-	u32	triminfo_ctrl;
-	u32	triminfo_ctrl1;
+	u32	triminfo_ctrl[2];
 	u32	triminfo_reload_shift;
 
 	u32	tmu_ctrl;
@@ -295,6 +294,8 @@ struct exynos_tmu_platform_data {
 	u8 second_point_trim;
 	u8 default_temp_offset;
 	u8 test_mux;
+	u8 triminfo_reload[2];
+	u8 triminfo_reload_count;
 
 	enum calibration_type cal_type;
 	enum calibration_mode cal_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index aa8e0de..25f9890 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -95,6 +95,8 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
+	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -160,6 +162,9 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = 0x1, \
+	.triminfo_reload[1] = 0x11, \
+	.triminfo_reload_count = 2, \
 	.registers = &exynos3250_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
@@ -184,7 +189,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
-	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
+	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
 	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
@@ -252,6 +257,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
+	.triminfo_reload[0] = 0x1, \
+	.triminfo_reload_count = 1, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index f0979e5..e0536c3 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -57,8 +57,11 @@
 #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
 #define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
 
-/* Exynos5250 and Exynos4412 specific registers */
-#define EXYNOS_TMU_TRIMINFO_CON	0x14
+/* Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON1	0x10
+
+/* Exynos5250, Exynos4412 and Exynos3250 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON2	0x14
 #define EXYNOS_THD_TEMP_RISE		0x50
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
-- 
1.8.0

