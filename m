Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3KFN0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:26:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52432 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3KFN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:26:02 -0500
X-AuditID: cbfee68f-b7f836d000001b39-cc-527a436837ac
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: [PATCH 1/3 v7] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register
Date: Wed, 06 Nov 2013 18:57:39 +0530
Message-id: <1383744459-22745-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
References: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSo5vhXBVksG2igUXD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHLg9ds66y+6x
	eM9LJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfG1TWN7AUNyhW/V31hbmB8IdvF
	yMkhIWAi8bD1GwuELSZx4d56ti5GLg4hgaWMEtvn3WeEKTo2Yw9UYhGjxJmOR1BOD5PE2/4m
	dpAqNgEziYOLVoPZIgIyElOv7GcFKWIW6GaSmL/iHNgOYYEYiSm7NoMVsQioSsyYu4qpi5GD
	g1fAVWLCXDWIbYoS3c8msIHYnEDhb6/7WEBKhARcJLbfZAYZKSGwjV1i+cqzbBBjBCS+TT4E
	ViMhICux6QAzxBhJiYMrbrBMYBRewMiwilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwFk7/
	e9a/g/HuAetDjMlA4yYyS4km5wNjKa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1ME6MTDeeWnJrgawy25/P22fML5/2yr3mw9OIvN+3D33Jkzy8
	X/uF71e3Z0vtFxf/nTdb1Sfy3tv6tg8O4s1WkTbrjU2+5xie9vJWfzuh2nBtj8WddNv8fPPk
	Cfa/pil0LlhVvLDo/QzLY3vc5hQs1SyY8kNHjvfaFkG2bNPVe88k+59Yq7c2/q8SS3FGoqEW
	c1FxIgB5/qUlmwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd0M56ogg7VnVC0aroZYbJyxntXi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjH5sDtsXPWXXaP
	xXteMnn0bVnF6HH8xnYmj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYwZlxd08he0KBc8XvVF+YGxheyXYycHBICJhLHZuxhg7DFJC7cWw9kc3EICSxilDjT8QjK
	6WGSeNvfxA5SxSZgJnFw0WowW0RARmLqlf2sIEXMAt1MEvNXnGMBSQgLxEhM2bUZrIhFQFVi
	xtxVTF2MHBy8Aq4SE+aqQWxTlOh+NgFsMydQ+NvrPhaQEiEBF4ntN5knMPIuYGRYxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcac+kdjCubLA4xCjAwajEw5sgXxkkxJpYVlyZe4hRgoNZ
	SYTXyqAqSIg3JbGyKrUoP76oNCe1+BBjMtBNE5mlRJPzgUkgryTe0NjE3NTY1NLEwsTMkjRh
	JXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYs1P07x7YXxl4wqZecUMXj2vMr1XvJOt3HL5/
	TZPdLe71l/hr7bE9jxIVLm45ffRnwHSeZydStPrOxeZ+mdp9bPut2ClHON5w5FT2Vzjwe094
	dt2GzfKHHYux4Bwu5dlZc26cfyv055xtW6B4UZXGOyX7wzcLHCTdQrXtqnems3QoSuf7/1JT
	YinOSDTUYi4qTgQAlN7ewfgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct

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

This patch introduces a new bit field intclr_fall_shift to handle the
offset for exyns5250 and exynos5440

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
Changes since v2:
Changes since v3:
  None
Changes since v4:
 Correct the CLEAR_FALL_INT_SHIFT for Exynos5250/Exynos5440
Changes since v5:
 Modify the commit message
Changes since v6:
 - Use EXYNOS_TMU_CLEAR_FALL_INT_SHIFT instead of EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT
 as the same is being used for Exynos4412

 drivers/thermal/samsung/exynos_tmu.c      |    2 +-
 drivers/thermal/samsung/exynos_tmu.h      |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.h |    4 +++-
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 32f38b9..b2202fa 100644
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
index 3fb6554..5f4fe6c 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -136,6 +136,7 @@ enum soc_type {
  * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
+ * @intclr_fall_shift: shift bits for interrupt clear fall 0
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
@@ -207,6 +208,7 @@ struct exynos_tmu_registers {
 	u32	tmu_intstat;
 
 	u32	tmu_intclear;
+	u32	intclr_fall_shift;
 
 	u32	emul_con;
 	u32	emul_temp_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 073c292..c6e67e9 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -123,6 +123,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
@@ -228,6 +229,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
 	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index a1ea19d..bb412bb 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -69,9 +69,11 @@
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-#define EXYNOS_TMU_FALL_INT_SHIFT	12
+#define EXYNOS_TMU_FALL_INT_SHIFT	16
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
 #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
+#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
+#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
-- 
1.7.10.4

