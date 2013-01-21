Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3AUMKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:10:10 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53971 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3AUMKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:10:05 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/2] clocksource: dbx500-prcmu: comment cleanup
Date: Mon, 21 Jan 2013 13:09:32 +0100
Message-Id: <1358770172-30125-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove references to the deprecated DB5500 platform.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 159f54a..6879a74 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -10,7 +10,7 @@
  * DBx500-PRCMU Timer
  * The PRCMU has 5 timers which are available in a always-on
  * power domain.  We use the Timer 4 for our always-on clock
- * source on DB8500 and Timer 3 on DB5500.
+ * source on DB8500.
  */
 #include <linux/clockchips.h>
 #include <linux/clksrc-dbx500-prcmu.h>
-- 
1.7.12.1

