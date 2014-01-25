Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaAYOXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:23:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaAYOXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:23:32 -0500
Date: Sat, 25 Jan 2014 06:22:46 -0800
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-e9a2eb403bd953788cd2abfd0d2646d43bd22671@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        john.stultz@linaro.org, fweisbec@gmail.com, rostedt@goodmis.org,
        khilman@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        john.stultz@linaro.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, khilman@linaro.org
In-Reply-To: <1386074112-30754-2-git-send-email-alex.shi@linaro.org>
References: <1386074112-30754-2-git-send-email-alex.shi@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] nohz_full:
  fix code style issue of tick_nohz_full_stop_tick
Git-Commit-ID: e9a2eb403bd953788cd2abfd0d2646d43bd22671
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:22:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9a2eb403bd953788cd2abfd0d2646d43bd22671
Gitweb:     http://git.kernel.org/tip/e9a2eb403bd953788cd2abfd0d2646d43bd22671
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Thu, 28 Nov 2013 14:27:11 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 15 Jan 2014 23:07:11 +0100

nohz_full: fix code style issue of tick_nohz_full_stop_tick

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
 
