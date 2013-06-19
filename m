Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab3FSSk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:40:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935123Ab3FSSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:40:23 -0400
Date: Wed, 19 Jun 2013 11:39:51 -0700
From: tip-bot for Michael Wang <tipbot@zytor.com>
Message-ID: <tip-8404c90d050733b3404dc36c500f63ccb0c972ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <51AD8808.7020608@linux.vnet.ibm.com>
References: <51AD8808.7020608@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Femove the useless declaration in kernel/
 sched/fair.c
Git-Commit-ID: 8404c90d050733b3404dc36c500f63ccb0c972ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:39:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8404c90d050733b3404dc36c500f63ccb0c972ce
Gitweb:     http://git.kernel.org/tip/8404c90d050733b3404dc36c500f63ccb0c972ce
Author:     Michael Wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Tue, 4 Jun 2013 14:24:08 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:41 +0200

sched: Femove the useless declaration in kernel/sched/fair.c

default_cfs_period(), do_sched_cfs_period_timer(), do_sched_cfs_slack_timer()
already defined previously, no need to declare again.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51AD8808.7020608@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 47a30be..c0ac2c3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2618,10 +2618,6 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	throttle_cfs_rq(cfs_rq);
 }
 
-static inline u64 default_cfs_period(void);
-static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
-static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
-
 static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
 {
 	struct cfs_bandwidth *cfs_b =
