Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaEELQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:16:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54784 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbaEELQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:16:55 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-65-53677326195c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 01/10] thermal: exynos: remove unused struct
 exynos_tmu_registers entries
Date: Mon, 05 May 2014 13:15:30 +0200
Message-id: <1399288539-1793-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAV214vRgg5UfpS0aroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8a7bX1sBUeNKh4tvcPewLheq4uRk0NC
	wESi/84RVghbTOLCvfVsXYxcHEICixglTj/YxgzhdDFJ/D7RyQxSxSZgJTGxfRUjiC0ioCdx
	48UTJpAiZoHjTBI/f58HaufgEBaIltj5PBWkhkVAVWLW5h+sIGFeAXeJpz3iEMsUJbqfTWAD
	sTkFPCT2v3wMNl4IqOTg48nMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDrhn
	UjsYVzZYHGIU4GBU4uFNYE4PFmJNLCuuzD3EKMHBrCTCm50IFOJNSaysSi3Kjy8qzUktPsQo
	zcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cBYKN0eYiwpUV7UqcHCF3T404asX9O8lkWs
	fnR8CW/cIvFOm2mc5esOzXi0y7ovpT9S+lueQntC+bEC659yZ7Ob9+pJrFuzc2/yzx3xJ6aK
	fTRl5Da/Xbj6do9x3Pk8Lp0pRRu2VO/M5mP79l5n194fvz3KJltUS9x+tyep/8pkZj825qsW
	vnuVWIozEg21mIuKEwHR+JIcNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.h      | 40 -------------------------------
 drivers/thermal/samsung/exynos_tmu_data.c |  2 --
 drivers/thermal/samsung/exynos_tmu_data.h |  1 -
 3 files changed, 43 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 3fb6554..80dc899 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -82,8 +82,6 @@ enum soc_type {
  * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
  * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
- * @triminfo_reload_shift: shift of triminfo reload enable bit in triminfo_ctrl
-	reg.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
  * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl register.
@@ -98,27 +96,13 @@ enum soc_type {
 	register.
  * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
 	register.
- * @therm_trip_tq_en_shift: shift bits of thermal trip enable by TQ pin in
-	tmu_ctrl register.
  * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
  * @tmu_status: register drescribing the TMU status.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
- * @tmu_cur_temp_shift: shift bits of current temp value in tmu_cur_temp
-	register.
  * @threshold_temp: register containing the base threshold level.
  * @threshold_th0: Register containing first set of rising levels.
- * @threshold_th0_l0_shift: shift bits of level0 threshold temperature.
- * @threshold_th0_l1_shift: shift bits of level1 threshold temperature.
- * @threshold_th0_l2_shift: shift bits of level2 threshold temperature.
- * @threshold_th0_l3_shift: shift bits of level3 threshold temperature.
  * @threshold_th1: Register containing second set of rising levels.
- * @threshold_th1_l0_shift: shift bits of level0 threshold temperature.
- * @threshold_th1_l1_shift: shift bits of level1 threshold temperature.
- * @threshold_th1_l2_shift: shift bits of level2 threshold temperature.
- * @threshold_th1_l3_shift: shift bits of level3 threshold temperature.
  * @threshold_th2: Register containing third set of rising levels.
- * @threshold_th2_l0_shift: shift bits of level0 threshold temperature.
- * @threshold_th3: Register containing fourth set of rising levels.
  * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
  * @tmu_inten: register containing the different threshold interrupt
 	enable bits.
@@ -131,15 +115,11 @@ enum soc_type {
  * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
  * @inten_rise3_shift: shift bits of rising 3 interrupt bits.
  * @inten_fall0_shift: shift bits of falling 0 interrupt bits.
- * @inten_fall1_shift: shift bits of falling 1 interrupt bits.
- * @inten_fall2_shift: shift bits of falling 2 interrupt bits.
- * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
  * @emul_con: TMU emulation controller register.
  * @emul_temp_shift: shift bits of emulation temperature.
  * @emul_time_shift: shift bits of emulation time.
- * @emul_time_mask: mask bits of emulation time.
  * @tmu_irqstatus: register to find which TMU generated interrupts.
  * @tmu_pmin: register to get/set the Pmin value.
  */
@@ -149,7 +129,6 @@ struct exynos_tmu_registers {
 	u32	triminfo_85_shift;
 
 	u32	triminfo_ctrl;
-	u32	triminfo_reload_shift;
 
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
@@ -162,32 +141,17 @@ struct exynos_tmu_registers {
 	u32	buf_slope_sel_mask;
 	u32	calib_mode_shift;
 	u32	calib_mode_mask;
-	u32	therm_trip_tq_en_shift;
 	u32	core_en_shift;
 
 	u32	tmu_status;
 
 	u32	tmu_cur_temp;
-	u32	tmu_cur_temp_shift;
 
 	u32	threshold_temp;
 
 	u32	threshold_th0;
-	u32	threshold_th0_l0_shift;
-	u32	threshold_th0_l1_shift;
-	u32	threshold_th0_l2_shift;
-	u32	threshold_th0_l3_shift;
-
 	u32	threshold_th1;
-	u32	threshold_th1_l0_shift;
-	u32	threshold_th1_l1_shift;
-	u32	threshold_th1_l2_shift;
-	u32	threshold_th1_l3_shift;
-
 	u32	threshold_th2;
-	u32	threshold_th2_l0_shift;
-
-	u32	threshold_th3;
 	u32	threshold_th3_l0_shift;
 
 	u32	tmu_inten;
@@ -200,9 +164,6 @@ struct exynos_tmu_registers {
 	u32	inten_rise2_shift;
 	u32	inten_rise3_shift;
 	u32	inten_fall0_shift;
-	u32	inten_fall1_shift;
-	u32	inten_fall2_shift;
-	u32	inten_fall3_shift;
 
 	u32	tmu_intstat;
 
@@ -211,7 +172,6 @@ struct exynos_tmu_registers {
 	u32	emul_con;
 	u32	emul_temp_shift;
 	u32	emul_time_shift;
-	u32	emul_time_mask;
 
 	u32	tmu_irqstatus;
 	u32	tmu_pmin;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 476b768..36d64d6 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -96,7 +96,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
 	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
-	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -126,7 +125,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.emul_con = EXYNOS_EMUL_CON,
 	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
 	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
-	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
 };
 
 #define EXYNOS4412_TMU_DATA \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index a1ea19d..06c4345 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -63,7 +63,6 @@
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
 
-#define EXYNOS_TRIMINFO_RELOAD_SHIFT	1
 #define EXYNOS_TRIMINFO_25_SHIFT	0
 #define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
-- 
1.8.2.3

