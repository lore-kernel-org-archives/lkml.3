Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3H1FpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:45:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3H1FpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:45:13 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-a3-521d8e642df5
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH 1/3] thermal: samsung: correct the fall interrupt en,
 status bit fields
Date: Wed, 28 Aug 2013 11:15:17 +0530
Message-id: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
 <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWjelTzbIYMNuUYuGqyEW84+cY7VY
	s/8nk0XvgqtsFpd3zWGz+Nx7hNFixvl9TBaLtv1ntnjysI/NgdNj56y77B6L97xk8ujbsorR
	4/iN7UwenzfJBbBGcdmkpOZklqUW6dslcGVM6LrIVDBPtuLb26OMDYz9kl2MHBwSAiYSK54l
	dTFyApliEhfurWfrYuTiEBJYyijxZlYHM0xN7+5yiPgiRom7y2cxQjg9TBLL3yxhBelmEzCT
	OLhoNTuILSLgJTHr4VUmkCJmgfWMEoe2r2UGSQgLRErcbZ3IBDKVRUBVYvNOIZAwr4CLxKrm
	L4wQyxQk5kyyAQlzCrhKTF/yEmpXA6PEgp+XwRwJgXXsEhtWPgNbzCIgIPFt8iEWiGZZiU0H
	mCG+kZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAsP+9L9n/TsY7x6w
	PsSYDDRuIrOUaHI+MG7ySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8q
	zUktPsTIxMEp1cC4NvfUSqPlxhfjBTlWiln3/bQWPDyB/e/vC0w9Ee2rWm//0e42FLwZePFo
	RqlHZ3B/jv0cReUr8bzbX6bfXXSdy4h/6qTv5W9+3M5bsF6C7ZTK3bPXElNWKfnM0NX8tCz5
	+Cz/mdFVL7u5N1eedj6/u4XNK3ye/ty2VVc+VBgYvL3xY/4H9QMhSizFGYmGWsxFxYkAk5sU
	MZECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAd2UPtkgg//TeSwaroZYzD9yjtVi
	zf6fTBa9C66yWVzeNYfN4nPvEUaLGef3MVks2vaf2eLJwz42B06PnbPusnss3vOSyaNvyypG
	j+M3tjN5fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY0LXRaaC
	ebIV394eZWxg7JfsYuTgkBAwkejdXd7FyAlkiklcuLeerYuRi0NIYBGjxN3lsxghnB4mieVv
	lrCCVLEJmEkcXLSaHcQWEfCSmPXwKhNIEbPAekaJQ9vXMoMkhAUiJe62TmQC2cAioCqxeacQ
	SJhXwEViVfMXRojFChJzJtmAhDkFXCWmL3kJtauBUWLBz8uMExh5FzAyrGIUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQIjqtnUjsYVzZYHGIU4GBU4uG12CwTJMSaWFZcmXuIUYKDWUmEt+Q/
	UIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgTGfVxJvaGxibmpsamliYWJmSZqwkjjvgVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2McZ6WB36pX5U3bryRabE2L/jw3TV7BO2KzzauEfl2UUb3
	pGnPw4+pF7jjWidc2Gz9V9r63fwlNlwbDfM+JVxsObo92fZOOWPvdJbpFiHJqaFbpvtzhB/s
	zJwwXf4Bh29y9P3ZcrcWT193zj/4YSF7fFdNdr5Ht1+WkN5FZVbXrVE7AyZ4/5ymxFKckWio
	xVxUnAgAh2Nzy+8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FALL interrupt related en, status bits are available at an offset of
16 on INTEN, INTSTAT registers and at an offset of
12 on INTCLEAR register.

This patch corrects the same for exyns5250 and exynos5440

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    2 +-
 drivers/thermal/samsung/exynos_tmu.h      |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index ec01dfe..d201ed8 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -265,7 +265,7 @@ skip_calib_data:
 				data->base + reg->threshold_th1);
 
 		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
-			(reg->inten_fall_mask << reg->inten_fall_shift),
+			(reg->inten_fall_mask << reg->intclr_fall_shift),
 				data->base + reg->tmu_intclear);
 
 		/* if last threshold limit is also present */
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index b364c9e..7c6c34a 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -134,6 +134,7 @@ enum soc_type {
  * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
+ * @intclr_fall_shift: shift bits for interrupt clear fall 0
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
@@ -204,6 +205,7 @@ struct exynos_tmu_registers {
 	u32	tmu_intstat;
 
 	u32	tmu_intclear;
+	u32	intclr_fall_shift;
 
 	u32	emul_con;
 	u32	emul_temp_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 9002499..23fea23 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
@@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
 	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index dc7feb5..8788a87 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -69,9 +69,10 @@
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_FALL_INT_SHIFT	12
+#define EXYNOS_TMU_FALL_INT_SHIFT	16
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
+#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
-- 
1.7.9.5

