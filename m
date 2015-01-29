Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbbA2NIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:08:32 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64839 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbA2NIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:08:31 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, baruch@tkos.co.il, linux@rempel-privat.de,
        rob.herring@linaro.org, thierry.reding@gmail.com
Subject: [PATCH 1/9] clocksource: sirf: Remove unused variable
Date: Thu, 29 Jan 2015 14:08:11 +0100
Message-Id: <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54CA3044.6070501@linaro.org>
References: <54CA3044.6070501@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit ef89af1f4380 ("clocksource: sirf: Remove hard-coded clock rate")
removes all uses of the timer_div variable. Since the variable is no
longer used it should be removed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/timer-marco.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 361a789..3ddb81f 100644
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
1.9.1

