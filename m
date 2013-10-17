Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208Ab3JQDJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:09:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23402 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761651Ab3JQDJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:09:11 -0400
X-AuditID: cbfee690-b7fa36d00000744b-2a-525f54d572bb
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: [PATCH 1/3 v6] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register
Date: Thu, 17 Oct 2013 08:41:13 +0530
Message-id: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
References: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSq3s1JD7I4MU/PYuGqyEWG2esZ7V4
	eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOXB77Jx1l91j
	8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6MJxf+shS8VKzY2fOOrYHxtUwX
	IyeHhICJxJy925kgbDGJC/fWs3UxcnEICSxllHg56zyQwwFWdGxTEUiNkMAiRom/Rz0ganqY
	JC40H2EHSbAJmEkcXLQazBYRkJGYemU/K0gRs0A3k8T8FedYQBLCAjESk3t3gRWxCKhKfJz6
	CszmFXCR6J3awQpxhaJE97MJbCA2p4CrxLxvyxkhNrtIvLnwgAWiZhe7xKOlBRBzBCS+TT7E
	AnGorMSmA8wQJZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmAknP73
	bMIOxnsHrA8xJgONm8gsJZqcD4ykvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwZnUKqKaEZDCYemx8tl5+znFxXe7OO7+bFRQ4/3+bFdN3sco5
	Yfpqr/6Zp9MSE0rb2RK/HV7gt94xu3ZWQjNDv7fLFZNQvnjl6XEbvj6YLp2WlzA/zFzfOXbl
	j69GBQvteB4+VzU+NeV1e9DbG/GbGl/Yey4N+n93huwWg5wZiXvcFkQZnO5TYinOSDTUYi4q
	TgQAnjDCV5oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd2rIfFBBhemqVg0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzYHbY+esu+we
	i/e8ZPLo27KK0eP4je1MHp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzHhy4S9LwUvFip0979gaGF/LdDFycEgImEgc21TUxcgJZIpJXLi3ng3EFhJYxCjx96hH
	FyMXkN3DJHGh+Qg7SIJNwEzi4KLVYLaIgIzE1Cv7WUGKmAW6mSTmrzjHApIQFoiRmNy7C6yI
	RUBV4uPUV2A2r4CLRO/UDlaIbYoS3c8mgG3jFHCVmPdtOSPEZheJNxcesExg5F3AyLCKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIzjSnkntYFzZYHGIUYCDUYmHd+byuCAh1sSy4srcQ4wS
	HMxKIrwXA+ODhHhTEiurUovy44tKc1KLDzEmA101kVlKNDkfmATySuINjU3MTY1NLU0sTMws
	SRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoExd9/2p7c22i9qlJz5u2paAUek3PFjWu3P
	b3wKjS6a3vre99nWYx4NF6ax3vsqd//uoi9eUxfpZZ+XY2l9Lx2y6M+7mt3JUitL/Vx7r59Y
	M13+Vh/v2Y0rj0x6f49/8ksW3e+XAo7MmPw3Nujwd+vZLKb10eJFq3x2OWnNXGL01/TC3ULD
	xPZLE5VYijMSDbWYi4oTAeoJYqz4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 073c292..09a8a27 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -123,6 +123,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
+	.intclr_fall_shift = EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT,
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
index a1ea19d..9c1e2c8 100644
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
+#define EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT	12
+#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
-- 
1.7.10.4

