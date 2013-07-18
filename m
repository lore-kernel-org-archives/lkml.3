Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3GRCju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:39:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59041 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab3GRCjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:39:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 1/3] clocksource: orion: Use linux/sched_clock.h
Date: Wed, 17 Jul 2013 19:39:19 -0700
Message-Id: <1374115161-675-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
References: <1374115161-675-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sched_clock.h include is under include/linux now.

Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/time-orion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
index ecbeb68..9c7f018 100644
--- a/drivers/clocksource/time-orion.c
+++ b/drivers/clocksource/time-orion.c
@@ -19,7 +19,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/spinlock.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 #define TIMER_CTRL		0x00
 #define  TIMER0_EN		BIT(0)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

