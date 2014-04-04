Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaDDGkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:40:51 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:42967 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaDDGkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 02/36] hrtimer: Fix comment mistake over hrtimer_force_reprogram()
Date: Fri,  4 Apr 2014 12:05:45 +0530
Message-Id: <c07035fe0a563a77f2f3e7d2f3d5b6a31a9c6105.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment was probably added when there were only two clock bases available
for hrtimers, now there are four.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a1120a0..3c05140 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -530,8 +530,7 @@ static inline int hrtimer_hres_active(void)
 }
 
 /*
- * Reprogram the event source with checking both queues for the
- * next event
+ * Reprogram the event source with checking all queues for the next event.
  * Called with interrupts disabled and base->lock held
  */
 static void
-- 
1.7.12.rc2.18.g61b472e

