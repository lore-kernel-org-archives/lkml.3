Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3FZBYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:24:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64454 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3FZBYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:24:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-78-51ca42da3d1d
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>,
        linux-pm@vger.kernel.org, "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Eduardo Valentin'" <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, "'Kukjin Kim'" <kgene.kim@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
 <1372071051-3167-24-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1372071051-3167-24-git-send-email-amit.daniel@samsung.com>
Subject: RE: [PATCH V7 23/30] thermal: exynos: Add thermal configuration data
 for exynos5440 TMU sensor
Date: Wed, 26 Jun 2013 10:24:42 +0900
Message-id: <007b01ce720b$ef1cc590$cd5650b0$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5wyV61VkaWxBMkTnS9QjIWdt5WwQBQZHpA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zA91bTqcCDda91rNouBpi8evdTHaL
	Nft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2Tx5GEfmwOHx85Zd9k9Fu95yeTRt2UVo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DKeLfsDVvBd82Kd6fXMTUw7lLpYuTkkBAwkTjUeo8dwhaT
	uHBvPVsXIxeHkMAyRokH3bOZuhg5wIq2t2dAxBcxSpxesZ0JwvnNKHHj3WlWkG42AU2JR3d7
	2EESIgILGCUur38ENopZoJlRYu6K34wQLS2MEr9WfmACaeEU8JBY23KUBWSHsECmRPNMOZAw
	i4CqxOVVzWBTeQVsJeYs/8sGYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIU9UlHv3VBQmL
	CBhJ7N21kR2iRERi34t3YCdICPxkl9i47SkbxC4BiW+TD7FA9MpKbDrADAkKSYmDK26wTGCU
	mIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUIiuW8H480D1ocY
	k4HWT2SWEk3OByaCvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNS
	iw8xMnFwSjUwToibps1b2ieuXrf84CWriMXRrypDDPesO3cg8vcTIy+vtyznk3rMLW/uu2Nx
	gkm5ibWRg5mhhv3DqwQxCbZpWjeyA4ymPdkbuF3yaVmUVuuVo1MDZVkP7vkZOrXx+saWqI+K
	B8yd5W7PUPT02cK90LdxPo/K5bwnFv+cXzx5drD1o/a86RduKLEUZyQaajEXFScCADz/ObD6	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd1bTqcCDfZf0rRouBpi8evdTHaL
	Nft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2Tx5GEfmwOHx85Zd9k9Fu95yeTRt2UVo8fxG9uZ
	PD5vkgtgjWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFu2Ru2gu+aFe9O
	r2NqYNyl0sXIwSEhYCKxvT2ji5ETyBSTuHBvPVsXIxeHkMAiRonTK7YzQTi/GSVuvDvNClLF
	JqAp8ehuDztIQkRgAaPE5fWPwFqYBZoZJeau+M0I0dLCKPFr5QcmkBZOAQ+JtS1HWUD2CQtk
	SjTPlAMJswioSlxe1Qw2lVfAVmLO8r9sELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGOFtd
	4tFfXZCwiICRxN5dG9khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEp4lnUjsYVzZYHGIU4GBU4uFV2HoyUIg1say4MvcQowQHs5IIb/4N
	oBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA1NYXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qt
	A4UE0hNLUrNTUwtSi2C2MHFwSjUwnoli0TM3Xnf/wu7li38yNzp8ULJinqmropr2bJko1xyf
	I15P+4pnbpvlrZX01EXLaLbe1w015pL7IkuPfbxlXVi/4AFDlrlt1EHNsLWOGTMubEr7uzRW
	9pLcos/PcrpPrTuyRtE1SHCV0i3bm8bScdMLD1vGFt3ZVHL0Fs+Dg9yJhQoTr9TkK7EUZyQa
	ajEXFScCADfbyrJXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 7:51 PM, Amit Daniel Kachhap wrote:
>This patch adds configuration data for exynos5440 soc. Also register
>definations for the controller are added.
>
>Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>---
> drivers/thermal/samsung/exynos_tmu.c      |    4 ++
> drivers/thermal/samsung/exynos_tmu_data.c |   71 +++++++++++++++++++++++++++++
> drivers/thermal/samsung/exynos_tmu_data.h |    7 +++
> 3 files changed, 82 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>index 6bc86f6..651f460 100644
>--- a/drivers/thermal/samsung/exynos_tmu.c
>+++ b/drivers/thermal/samsung/exynos_tmu.c
>@@ -456,6 +456,10 @@ static const struct of_device_id exynos_tmu_match[] = {
> 		.compatible = "samsung,exynos5250-tmu",
> 		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
> 	},
>+	{
>+		.compatible = "samsung,exynos5440-tmu",
>+		.data = (void *)EXYNOS5440_TMU_DRV_DATA,
>+	},
> 	{},
> };
> MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>index 2612b45..5952915 100644
>--- a/drivers/thermal/samsung/exynos_tmu_data.c
>+++ b/drivers/thermal/samsung/exynos_tmu_data.c
>@@ -175,3 +175,74 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
> 	.tmu_count = 1,
> };
> #endif
>+
>+#if defined(CONFIG_SOC_EXYNOS5440)
>+static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>+	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
>+	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>+	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
>+	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
>+	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
>+	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
>+	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
>+	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
>+	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
>+	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
>+	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
>+	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
>+	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
>+	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
>+	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
>+	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
>+	.threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
>+	.threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
>+	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
>+	.inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
>+	.inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
>+	.inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
>+	.inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
>+	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
>+	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
>+	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
>+	.inten_rise3_shift = EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
>+	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>+	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>+	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
>+	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>+	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>+	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>+	.tmu_pmin = EXYNOS5440_TMU_PMIN,
>+};
>+
>+#define EXYNOS5440_TMU_DATA \
>+	.trigger_levels[0] = 100, \
>+	.trigger_levels[4] = 105, \
>+	.trigger_enable[0] = 1, \
>+	.trigger_type[0] = SW_TRIP, \
>+	.trigger_type[4] = HW_TRIP, \
>+	.max_trigger_level = 5, \
>+	.gain = 5, \
>+	.reference_voltage = 16, \
>+	.noise_cancel_mode = 4, \
>+	.cal_type = TYPE_ONE_POINT_TRIMMING, \
>+	.cal_mode = 0, \

.cal_mode = SW_MODE is a clearer expression.

>+	.efuse_value = 0x5b2d, \

.efuse_value should be incremented by one.

Thanks,
Jungseok Lee
>+	.min_efuse_value = 16, \
>+	.max_efuse_value = 76, \
>+	.first_point_trim = 25, \
>+	.second_point_trim = 70, \
>+	.default_temp_offset = 25, \
>+	.type = SOC_ARCH_EXYNOS5440, \
>+	.registers = &exynos5440_tmu_registers, \
>+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
>+			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
>+
>+struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
>+	.tmu_data = {
>+		{ EXYNOS5440_TMU_DATA } ,
>+		{ EXYNOS5440_TMU_DATA } ,
>+		{ EXYNOS5440_TMU_DATA } ,
>+	},
>+	.tmu_count = 3,
>+};
>+#endif
>diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>index ad263e9..43ce5fb 100644
>--- a/drivers/thermal/samsung/exynos_tmu_data.h
>+++ b/drivers/thermal/samsung/exynos_tmu_data.h
>@@ -143,4 +143,11 @@ extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
> #define EXYNOS5250_TMU_DRV_DATA (NULL)
> #endif
>
>+#if defined(CONFIG_SOC_EXYNOS5440)
>+extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
>+#define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
>+#else
>+#define EXYNOS5440_TMU_DRV_DATA (NULL)
>+#endif
>+
> #endif /*_EXYNOS_TMU_DATA_H*/
>--
>1.7.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

