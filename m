Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaLOP70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:59:26 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:32994 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaLOP7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:59:24 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Barry Song <baohua@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] clocksource: sirf: Remove unused variable
Date: Mon, 15 Dec 2014 16:59:20 +0100
Message-Id: <1418659160-2115-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit ef89af1f4380 ("clocksource: sirf: Remove hard-coded clock rate")
removes all uses of the timer_div variable. Since the variable is no
longer used it should be removed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clocksource/timer-marco.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 361a789d4bee..3ddb81f7ee66 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
 /* initialize the kernel jiffy timer source */
 static void __init sirfsoc_marco_timer_init(struct device_node *np)
 {
-	u32 timer_div;
 	struct clk *clk;
 
 	clk = of_clk_get(np, 0);
-- 
2.1.3

