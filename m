Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3LDBsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:48:52 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60403 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3LDBst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:48:49 -0500
Message-ID: <529E89F3.3020508@linaro.org>
Date: Wed, 04 Dec 2013 09:48:35 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] nohz_full: fix code sytle issue of tick_nohz_full_stop_tick
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org> <1386074112-30754-2-git-send-email-alex.shi@linaro.org> <20131203150038.GE10134@e103034-lin>
In-Reply-To: <20131203150038.GE10134@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 11:00 PM, Morten Rasmussen wrote:
> In subject: s/sytle/style/
> 

Thanks for this catch. updated.

===
>From 8d430d26c06c31d536c5ad38b8711d738fc25eff Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Thu, 28 Nov 2013 14:27:11 +0800
Subject: [PATCH v2 1/3] nohz_full: fix code style issue of
 tick_nohz_full_stop_tick

Code usually starts with 'tab' instead of 7 'space' in kernel

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/time/tick-sched.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..b55d1c0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -681,18 +681,18 @@ out:
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
1.8.1.2


-- 
Thanks
    Alex
