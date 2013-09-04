Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103Ab3IDEYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:24:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58275 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3IDEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:23:52 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-d7-5226b5d0a2ed
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 1/3] thermal: samsung: correct the fall interrupt en,
 status bit fields
Date: Wed, 04 Sep 2013 09:53:47 +0530
Message-id: <1378268629-2886-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
References: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSp3thq1qQwetryhYNV0MsNs5Yz2ox
	/8g5Vos1+38yWfQuuMpmcXnXHDaLz71HGC1mnN/HZLFo239miycP+9gcuDx2zrrL7rF4z0sm
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8b8jlNMBXtlKzZuV21gXCTZxcjJISFg
	IvGj9SI7hC0mceHeerYuRi4OIYGljBL3Jjxggym6+vkzM0RiOqPEhrXToKp6mCSeN90Aa2cT
	MJM4uGg1mC0i4CUx6+FVJpAiZoGTjBKXf91jBEkIC0RK3G2dyARiswioSsxqOAy2glfAReLO
	nyssXYwcQOsUJOZMsgEJcwq4Ssz7thysVQio5M2FBywgMyUEtrFL/F/ZwggxR0Di2+RDUL2y
	EpsOMENcLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBMbA6X/PJu5g
	vH/A+hBjMtC4icxSosn5wBjKK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAPj6l+1j31bNgTIfvJee67EpTyXu2uv5YQ0gVUyjJe16kLrtab83N69
	6fuPWdzb5p1qrHCIeG7+7dLp6+FKpi+PTky02C5WIcxQ/CBEh02m/HaGfdOqbR9/vz79hCH1
	7S+FDTdkfAtkFvMfSUhwyDqzLTHrksEPC/8DHvkuBwP9tVL+rN6+trxZiaU4I9FQi7moOBEA
	3Ph+a5cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQd0LW9WCDNY+lbBouBpisXHGelaL
	+UfOsVqs2f+TyaJ3wVU2i8u75rBZfO49wmgx4/w+JotF2/4zWzx52MfmwOWxc9Zddo/Fe14y
	efRtWcXocfzGdiaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	zO84xVSwV7Zi43bVBsZFkl2MnBwSAiYSVz9/ZoawxSQu3FvP1sXIxSEkMJ1RYsPaaVBOD5PE
	86Yb7CBVbAJmEgcXrQazRQS8JGY9vMoEUsQscJJR4vKve4wgCWGBSIm7rROZQGwWAVWJWQ2H
	2UBsXgEXiTt/rrB0MXIArVOQmDPJBiTMKeAqMe/bcrBWIaCSNxcesExg5F3AyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzjCnkntYFzZYHGIUYCDUYmHd8Mz1SAh1sSy4srcQ4wSHMxK
	IrwJPmpBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjP68knhDYxNzU2NTSxMLEzNL0oSV
	xHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamBk+rbGYqnhNLvLW0+2+umy6G/uVWY7un7i9XL2
	jmW+7wVveO64sNPthM5Vrf3HYrkV4j1lnZevqDBS/cvc22CSVeQh8/fMp2tLljH+nBz5KMD4
	M/9WlujSR3KtwXPXS802OF5gely9RiSA2Xn13ZAHB6SCzy2vDE5uf7uz/8lamTkd6lremquU
	WIozEg21mIuKEwHLgvcx9AIAAA==
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

Changes since v1:
  None

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

