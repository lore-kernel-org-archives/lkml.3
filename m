Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbbANFdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 00:33:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30097 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbANFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 00:33:31 -0500
X-AuditID: cbfee691-f79b86d000004a5a-2e-54b5ffa54382
From: Chanwoo Choi <cw00.choi@samsung.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: kgene@kernel.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for Exynos
 64bit SoC
Date: Wed, 14 Jan 2015 14:33:23 +0900
Message-id: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkRHfp/60hBhsuylhc//Kc1WLeZ1mL
	SfcnsFj0LrjKZtH/+DWzxabH11gtLu+aw2Yx4/w+Joul1y8yWWzeNJXZgctjzbw1jB6bVnWy
	edy5tofN4925c+wem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfGy7O3WAsOCVTs27eN
	sYHxK28XIyeHhICJxKJtJ5kgbDGJC/fWs3UxcnEICSxllFh+9i0LTNG39W1QiemMEh8W/2eB
	cJqYJLZefc8GUsUmoCWx/8UNMFtEwFBiz4oOZpAiZoHvjBLnX/xjBUkIC0RJbJt0hBHEZhFQ
	lXhzax1YnFfARWLHnX/sEOsUJJYtn8kK0iwhsIhd4sib6WwQDQIS3yYfAlrNAZSQldh0gBmi
	XlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECAz00/+eTdzBeP+A9SFG
	AQ5GJR5ehyNbQ4RYE8uKK3MPMZoCbZjILCWanA+Mp7ySeENjMyMLUxNTYyNzSzMlcV4d6Z/B
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhjD+fxsdtVuYwt3dg5XiHDYf43nhYe3SVWYzOYz
	O8tLAm9e/Pp3X83H4scXPzPPXb/heGNVlYxjt+1X98V+75jDtr6LbDB6tnSai7L6T43TsnkN
	DLJuV7jk9Z3jfR+qHihbkfuQ102p/Yz65bhkNc2t+4xvdU2OZ7lvcqDrr8JC4/yXWa+0biux
	FGckGmoxFxUnAgCRs+IQbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jQd2l/7eGGHReEbG4/uU5q8W8z7IW
	k+5PYLHoXXCVzaL/8Wtmi02Pr7FaXN41h81ixvl9TBZLr19ksti8aSqzA5fHmnlrGD02repk
	87hzbQ+bx7tz59g9Ni+p9+jbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
	MwNDXUNLC3MlhbzE3FRbJRefAF23zByg85QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYE
	wfUYGaCBhDWMGS/P3mItOCRQsW/fNsYGxq+8XYycHBICJhLf1rexQdhiEhfurQeyuTiEBKYz
	SnxY/J8Fwmlikth69T1YFZuAlsT+FzfAbBEBQ4k9KzqYQYqYBb4zSpx/8Y8VJCEsECWxbdIR
	RhCbRUBV4s2tdWBxXgEXiR13/rFDrFOQWLZ8JusERu4FjAyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYLj6Jn0DsZVDRaHGAU4GJV4eB2ObA0RYk0sK67MPcQowcGsJMK7aSpQiDclsbIq
	tSg/vqg0J7X4EKMp0PaJzFKiyfnAGM8riTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5N
	LUgtgulj4uCUamA0kv8t/fl6YibvuUbzyROmhJX13Huj+cI8b+WP1fuCvq66qf1C6+mr9Oh3
	BRcqzbv/eFusXKlhmtGaccHEzJdxh26keaFkDPcRqbDVXA2ev6eecl10/VjqjuyvEobPRTsy
	dzVNX1rws5Fp7ZbNUqeEnUUla3/sfcPuKCH/tM/WLEtM+Q2HlbkSS3FGoqEWc1FxIgAymQOX
	uQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
for Exynos 32bit SoC.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
This patch set is tested on 64-bit Exynos SoC. I send only this patch from
following patchst[1].
[1] https://lkml.org/lkml/2014/12/2/134

Changes from v2:
- None
Changes from v1:
- Use CONFIG_ARM instead of CONFIG_ARM64

 drivers/clocksource/Kconfig      | 1 -
 drivers/clocksource/exynos_mct.c | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fc01ec2..be38119 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -135,7 +135,6 @@ config CLKSRC_METAG_GENERIC
 
 config CLKSRC_EXYNOS_MCT
 	def_bool y if ARCH_EXYNOS
-	depends on !ARM64
 	help
 	  Support for Multi Core Timer controller on Exynos SoCs.
 
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 9403061..b840ea1 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
 	return exynos4_read_count_32();
 }
 
+#if defined(CONFIG_ARM)
 static struct delay_timer exynos4_delay_timer;
 
 static cycles_t exynos4_read_current_timer(void)
@@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
 			 "cycles_t needs to move to 32-bit for ARM64 usage");
 	return exynos4_read_count_32();
 }
+#endif
 
 static void __init exynos4_clocksource_init(void)
 {
 	exynos4_mct_frc_start();
 
+#if defined(CONFIG_ARM)
 	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
 	exynos4_delay_timer.freq = clk_rate;
 	register_current_timer_delay(&exynos4_delay_timer);
+#endif
 
 	if (clocksource_register_hz(&mct_frc, clk_rate))
 		panic("%s: can't register clocksource\n", mct_frc.name);
-- 
1.8.5.5

