Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3JUMRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:17:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62008 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3JUMRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:17:39 -0400
From: Libin <huawei.libin@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        <xiexiuqi@huawei.com>, <huawei.libin@huawei.com>
Subject: [PATCH] sched/rt: Fix comment of task_tick_rt()
Date: Mon, 21 Oct 2013 20:15:43 +0800
Message-ID: <1382357743-54136-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

This issue was introduced by 454c7999(sched/rt: Fix SCHED_RR across
cgroups) that missing the word 'not'. Fix it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/sched/rt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..fa4cf84 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1931,8 +1931,8 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	p->rt.time_slice = sched_rr_timeslice;
 
 	/*
-	 * Requeue to the end of queue if we (and all of our ancestors) are the
-	 * only element on the queue
+	 * Requeue to the end of queue if we (and all of our ancestors) are not
+	 * the only element on the queue
 	 */
 	for_each_sched_rt_entity(rt_se) {
 		if (rt_se->run_list.prev != rt_se->run_list.next) {
-- 
1.8.2.1


