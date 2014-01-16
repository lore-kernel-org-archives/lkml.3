Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaAPPnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:43:12 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59139 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaAPPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:42:05 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/4] nohz_full: fix code style issue of tick_nohz_full_stop_tick
Date: Thu, 16 Jan 2014 16:41:51 +0100
Message-Id: <1389886912-4783-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
References: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@linaro.org>

Code usually starts with 'tab' instead of 7 'space' in kernel

Signed-off-by: Alex Shi <alex.shi@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
Link: http://lkml.kernel.org/r/1386074112-30754-2-git-send-email-alex.shi@linaro.org
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 68331d1..d603bad 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -679,18 +679,18 @@ out:
 static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 {
 #ifdef CONFIG_NO_HZ_FULL
-       int cpu = smp_processor_id();
+	int cpu = smp_processor_id();
 
-       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
-               return;
+	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+		return;
 
-       if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
-	       return;
+	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+		return;
 
-       if (!can_stop_full_tick())
-               return;
+	if (!can_stop_full_tick())
+		return;
 
-       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
 #endif
 }
 
-- 
1.8.3.1

