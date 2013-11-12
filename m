Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3KLGep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:34:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27682 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3KLGej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:34:39 -0500
X-AuditID: cbfee68f-b7f836d000001b39-0b-5281cbfd2d93
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 1/4 v9] thermal: samsung: replace inten_ bit fields with intclr_
Date: Tue, 12 Nov 2013 12:06:08 +0530
Message-id: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
References: <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSp/v3dGOQwcdz2hYNV0MsNs5Yz2rx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjs1g/4zWLA4/H
	zll32T0W73nJ5NG3ZRWjx/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4MrYtaaLqeCSS8XhSc+Z
	Gxh/WHUxcnJICJhIHDp1nQ3CFpO4cG89kM3FISSwlFGiaetbdpiihx/XsUAkpjNKbG5+wwzh
	9DBJbGuYD9bOJmAmcXDRarAOEQEZialX9rOCFDELzGeSOPRnLVhCWCBA4uK1F0wgNouAqsSh
	B8dZQGxeAVeJL5N/MUGsU5TofjYBaCgHB6eAm8TJn9UgYSGgkittP8DOkxA4xC6x5MR3Nog5
	AhLfJh9iAamXEJCV2HSAGWKMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtcmpeul5yf
	u4kRGBen/z3r38F494D1IcZkoHETmaVEk/OBcZVXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhhXbzxqsuXfvbgHivLcVZdPr54tkmOxTzZ2RsN6
	30WLNp1/86RuppPNpnt3yjOPMRyXsDvcuGLn7DURyqx1/fEla7w7tq7fqZphqXnu318GLhGO
	aab1egc58p8rXZJYnf9o6jbzH1tePp+xb4lX1YQDd5s0Tj2SXBuZHZ86aYFe8ZbSrqrYOBlz
	JZbijERDLeai4kQAEZuLy6ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd2/pxuDDGYcVbJouBpisXHGelaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjF1rupgKLrlUHJ70nLmB8YdVFyMnh4SAicTDj+tYIGwxiQv31rN1MXJxCAlM
	Z5TY3PyGGcLpYZLY1jCfDaSKTcBM4uCi1ewgtoiAjMTUK/tZQYqYBeYzSRz6sxYsISwQIHHx
	2gsmEJtFQFXi0IPjYCt4BVwlvkz+xQSxTlGi+9kEoKEcHJwCbhInf1aDhIWASq60/WCbwMi7
	gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw1D2T2sG4ssHiEKMAB6MSD+8OrsYgIdbE
	suLK3EOMEhzMSiK84YuBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPTAh5JfGGxibmpsam
	liYWJmaWpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDYy92WNe8Cy0pmR++Ui2lGwY3+
	AR8YPrjO95+VZmruZGW/L+zCGqOYSzv3H3iQaHBKKZTx0pKXEf/9mZwu1JX3fDmyZnnV6Wgb
	X3PTyzNCJj3208zN3rg/TdFf1t1bf82iinClPoNpybsUnQrdHkavl55gpnblxoWFc9ju9Olq
	vzm56czzlL9KLMUZiYZazEXFiQBlrjve/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the inten_rise_shift/mask and inten_fall_shift/mask
with intclr_rise_shift/mask and intclr_fall_shift/mask respectively.
Currently, inten_rise_shift/mask and inten_fall_shift/mask bits are only used
to configure intclr related registers.

Description of H/W:
The offset for the bits in the CLEAR register are not consistent across TMU
modules in Exynso5250, 5420 and 5440.

On Exynos5250, the FALL interrupt related en, status and clear bits are
available at an offset of
16 in INTEN, INTSTAT registers and at an offset of
12 in INTCLEAR register.

On Exynos5420, the FALL interrupt related en, status and clear bits are
available at an offset of
16 in INTEN, INTSTAT and INTCLEAR registers.

On Exynos5440,
the FALL_IRQEN bits are at an offset of 4
and the RISE_IRQEN bits are at an offset of 0

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v8:
1. Modified the patch description,
2. replaces the inten_rise/fall_shift/mask with intclr_rise/fall_shift/mask

 drivers/thermal/samsung/exynos_tmu.c      |    6 +++---
 drivers/thermal/samsung/exynos_tmu.h      |   16 ++++++++--------
 drivers/thermal/samsung/exynos_tmu_data.c |   18 +++++++++---------
 drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 32f38b9..c493245 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -237,7 +237,7 @@ skip_calib_data:
 			writeb(pdata->trigger_levels[i], data->base +
 			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
 
-		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
+		writel(reg->intclr_rise_mask, data->base + reg->tmu_intclear);
 	} else {
 		/* Write temperature code for rising and falling threshold */
 		for (i = 0;
@@ -264,8 +264,8 @@ skip_calib_data:
 		writel(falling_threshold,
 				data->base + reg->threshold_th1);
 
-		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
-			(reg->inten_fall_mask << reg->inten_fall_shift),
+		writel((reg->intclr_rise_mask << reg->intclr_rise_shift) |
+			(reg->intclr_fall_mask << reg->intclr_fall_shift),
 				data->base + reg->tmu_intclear);
 
 		/* if last threshold limit is also present */
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 3fb6554..980859a 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -122,10 +122,6 @@ enum soc_type {
  * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
  * @tmu_inten: register containing the different threshold interrupt
 	enable bits.
- * @inten_rise_shift: shift bits of all rising interrupt bits.
- * @inten_rise_mask: mask bits of all rising interrupt bits.
- * @inten_fall_shift: shift bits of all rising interrupt bits.
- * @inten_fall_mask: mask bits of all rising interrupt bits.
  * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
  * @inten_rise1_shift: shift bits of rising 1 interrupt bits.
  * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
@@ -136,6 +132,10 @@ enum soc_type {
  * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
+ * @intclr_fall_shift: shift bits for interrupt clear fall 0
+ * @intclr_rise_shift: shift bits of all rising interrupt bits.
+ * @intclr_rise_mask: mask bits of all rising interrupt bits.
+ * @intclr_fall_mask: mask bits of all rising interrupt bits.
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
@@ -191,10 +191,6 @@ struct exynos_tmu_registers {
 	u32	threshold_th3_l0_shift;
 
 	u32	tmu_inten;
-	u32	inten_rise_shift;
-	u32	inten_rise_mask;
-	u32	inten_fall_shift;
-	u32	inten_fall_mask;
 	u32	inten_rise0_shift;
 	u32	inten_rise1_shift;
 	u32	inten_rise2_shift;
@@ -207,6 +203,10 @@ struct exynos_tmu_registers {
 	u32	tmu_intstat;
 
 	u32	tmu_intclear;
+	u32	intclr_fall_shift;
+	u32	intclr_rise_shift;
+	u32	intclr_fall_mask;
+	u32	intclr_rise_mask;
 
 	u32	emul_con;
 	u32	emul_temp_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 073c292..7cdb04e 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -40,13 +40,13 @@ static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
 	.threshold_th0 = EXYNOS4210_TMU_REG_TRIG_LEVEL0,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
 	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
 };
 
 struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
@@ -112,10 +112,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
-	.inten_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
-	.inten_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
-	.inten_fall_shift = EXYNOS_TMU_FALL_INT_SHIFT,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
@@ -123,6 +119,10 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
+	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
+	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
+	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
@@ -217,10 +217,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
 	.threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
 	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
-	.inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
-	.inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
-	.inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
-	.inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
 	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
 	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
@@ -228,6 +224,10 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
+	.intclr_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
+	.intclr_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
+	.intclr_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
 	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index a1ea19d..d9495a4 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -69,9 +69,10 @@
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_FALL_INT_SHIFT	12
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
+#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
+#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
@@ -119,7 +120,6 @@
 #define EXYNOS5440_TMU_RISE_INT_MASK		0xf
 #define EXYNOS5440_TMU_RISE_INT_SHIFT		0
 #define EXYNOS5440_TMU_FALL_INT_MASK		0xf
-#define EXYNOS5440_TMU_FALL_INT_SHIFT		4
 #define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
 #define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
 #define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
-- 
1.7.10.4

