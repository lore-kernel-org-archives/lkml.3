Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3EZNDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:03:10 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:44134 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab3EZNDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:03:08 -0400
X-Greylist: delayed 2896 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 May 2013 09:03:08 EDT
From: Baruch Siach <baruch@tkos.co.il>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: [PATCH 1/2] clocksource: dw_apb: remove unused header
Date: Sun, 26 May 2013 15:12:46 +0300
Message-Id: <1369570367-994-1-git-send-email-baruch@tkos.co.il>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time.h header seems not to be used by current code. Removing this include
allows the driver to build on other architecture that do not have this header.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/clocksource/dw_apb_timer_of.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index ab09ed3..5a61ebc 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -21,7 +21,6 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
-#include <asm/mach/time.h>
 #include <asm/sched_clock.h>
 
 static void timer_get_base_and_rate(struct device_node *np,
-- 
1.7.10.4

