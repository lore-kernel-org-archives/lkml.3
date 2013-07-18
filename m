Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab3GRCjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:39:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59050 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3GRCjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:39:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/3] ARM: clps711x: Use linux/sched_clock.h
Date: Wed, 17 Jul 2013 19:39:20 -0700
Message-Id: <1374115161-675-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
References: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sched_clock.h include is under include/linux now.

Cc: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-clps711x/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index 4ca2f3c..134641d 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -29,12 +29,12 @@
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/clk-provider.h>
+#include <linux/sched_clock.h>
 
 #include <asm/exception.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 #include <asm/system_misc.h>
 
 #include <mach/hardware.h>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

