Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaCYJcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:32:47 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:46901 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaCYJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:32:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] tick: fix spelling mistake in tick_handle_periodic()
Date: Tue, 25 Mar 2014 15:02:38 +0530
Message-Id: <8af4518de872a12afe063edd72e209fe60423280.1395739927.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the comments in tick_handle_periodic() had 'when' instead of 'which' (My
guess :)). Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 20b2fe3..791a3a2 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -118,7 +118,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
 		 * to be sure we're using a real hardware clocksource.
 		 * Otherwise we could get trapped in an infinite
 		 * loop, as the tick_periodic() increments jiffies,
-		 * when then will increment time, posibly causing
+		 * which then will increment time, posibly causing
 		 * the loop to trigger again and again.
 		 */
 		if (timekeeping_valid_for_hres())
-- 
1.7.12.rc2.18.g61b472e

