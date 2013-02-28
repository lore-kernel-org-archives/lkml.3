Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3B1KBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:01:47 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42371 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3B1KBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:01:44 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH RESEND 2/2] clocksource: dbx500-prcmu: comment cleanup
Date: Thu, 28 Feb 2013 11:01:07 +0100
Message-Id: <1362045667-23891-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362045667-23891-1-git-send-email-fabio.baltieri@linaro.org>
References: <1362045667-23891-1-git-send-email-fabio.baltieri@linaro.org>
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

