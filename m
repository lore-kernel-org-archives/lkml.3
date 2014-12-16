Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaLPXq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:46:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47655 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLPXq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:46:26 -0500
X-AuditID: cbfee691-f79b86d000004a5a-7d-5490c45002a9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de, kgene.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3] clocksource: exynos_mct: Add the support for Exynos 64bit SoC
Date: Wed, 17 Dec 2014 08:46:11 +0900
Message-id: <1418773571-10834-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkSDfgyIQQg56zIhbXvzxntZj3Wdai
	d8FVNotNj6+xWlzeNYfNYsb5fUwWS69fZLLYvGkqswOHx5p5axg97lzbw+bx7tw5do/NS+o9
	+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PUkT1MBYcEKnrWTGVrYPzK28XIySEhYCJxY/Ik
	RghbTOLCvfVsXYxcHEICSxkldt75xghTdGjiO2aIxCJGibbOfywQThOTxLHjy5lBqtgEtCT2
	v7jBBmKLCHhIvG7+xQRSxCywg1Fixc/DTCAJYYEAicXHzoPZLAKqEhfmvmYFsXkFXCUOXH7P
	DrFOQWLZ8pmsIM0SAt3sEquOvGOGaBCQ+Db5ENBqDqCErMSmA8wQ9ZISB1fcYJnAKLiAkWEV
	o2hqQXJBcVJ6kalecWJucWleul5yfu4mRmAon/73bOIOxvsHrA8xCnAwKvHwBhT2hwixJpYV
	V+YeYjQF2jCRWUo0OR8YMXkl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTBOVZk0pcEgd47ec+3ZqyoCOQuM4739bzpUTLvwJfLBp+17FLunfgo2FJrx
	6P1SPT61nQc0PFMd2mZKvm160xtq2/70vsucRzfr1zJv7t9h1XXxceOKtT81++WLXnhc4JwX
	6Ghc+MLQnodx7Z+6rz897CqaP5YbCzwpmvhl/tbInL+aE+49j3qjxFKckWioxVxUnAgAmVVg
	UmACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAd2AIxNCDHY18Fpc//Kc1WLeZ1mL
	3gVX2Sw2Pb7GanF51xw2ixnn9zFZLL1+kcli86apzA4cHmvmrWH0uHNtD5vHu3Pn2D02L6n3
	6NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
	F58AXbfMHKB7lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZp47sYSo4
	JFDRs2YqWwPjV94uRk4OCQETiUMT3zFD2GISF+6tZ+ti5OIQEljEKNHW+Y8Fwmlikjh2fDlY
	FZuAlsT+FzfYQGwRAQ+J182/mECKmAV2MEqs+HmYCSQhLBAgsfjYeTCbRUBV4sLc16wgNq+A
	q8SBy+/ZIdYpSCxbPpN1AiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBkfJMegfj
	qgaLQ4wCHIxKPLyBhf0hQqyJZcWVuYcYJTiYlUR4LRZNCBHiTUmsrEotyo8vKs1JLT7EaAq0
	fSKzlGhyPjCK80riDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGK13
	sJRt8/u49+zJ2LRZdw8slDGc/rXfL6PjoQVPWtaZK+eeTVYL8GK2+WH6Y/lnt3TGI7e/XjNO
	OFMdl37nBX/S0jSftU5KkQyX3jwTbT1/uf6HqJ7Q65aQgD1Rj2PSFi69xXP3Wr+ga7M3w+L2
	Lktzm+1WutlrJHrWd9xZ/F9nZ4DSkpcdUkosxRmJhlrMRcWJAKhCTqyqAgAA
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
index 9042060..27ef3fa 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -134,7 +134,6 @@ config CLKSRC_METAG_GENERIC
 
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

