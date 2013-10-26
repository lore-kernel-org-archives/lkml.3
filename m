Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3JZNwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:52:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3JZNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:52:00 -0400
Date: Sat, 26 Oct 2013 06:51:06 -0700
From: tip-bot for Li Bin <tipbot@zytor.com>
Message-ID: <tip-e9aa39bb7c4415ca26484239cc3a6686d549bf4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, xiexiuqi@huawei.com,
        tglx@linutronix.de, guohanjun@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, xiexiuqi@huawei.com,
        tglx@linutronix.de, guohanjun@huawei.com
In-Reply-To: <1382357743-54136-1-git-send-email-huawei.libin@huawei.com>
References: <1382357743-54136-1-git-send-email-huawei.libin@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Fix task_tick_rt() comment
Git-Commit-ID: e9aa39bb7c4415ca26484239cc3a6686d549bf4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:51:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9aa39bb7c4415ca26484239cc3a6686d549bf4f
Gitweb:     http://git.kernel.org/tip/e9aa39bb7c4415ca26484239cc3a6686d549bf4f
Author:     Li Bin <huawei.libin@huawei.com>
AuthorDate: Mon, 21 Oct 2013 20:15:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 12:25:21 +0200

sched/rt: Fix task_tick_rt() comment

This issue was introduced by 454c79999f7e ("sched/rt: Fix SCHED_RR
across cgroups") that missed the word 'not'. Fix it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
Cc: <guohanjun@huawei.com>
Cc: <xiexiuqi@huawei.com>
Cc: <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1382357743-54136-1-git-send-email-huawei.libin@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a848f52..7d57275 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1935,8 +1935,8 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	p->rt.time_slice = sched_rr_timeslice;
 
 	/*
-	 * Requeue to the end of queue if we (and all of our ancestors) are the
-	 * only element on the queue
+	 * Requeue to the end of queue if we (and all of our ancestors) are not
+	 * the only element on the queue
 	 */
 	for_each_sched_rt_entity(rt_se) {
 		if (rt_se->run_list.prev != rt_se->run_list.next) {
