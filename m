Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaESNL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:11:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaESNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:11:54 -0400
Date: Mon, 19 May 2014 06:10:47 -0700
From: "tip-bot for xiaofeng.yan" <tipbot@zytor.com>
Message-ID: <tip-6e9a8b9d6a9257bc124a1609f25597064ef9c167@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, xiaofeng.yan@huawei.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, xiaofeng.yan@huawei.com
In-Reply-To: <1399880477-23376-1-git-send-email-xiaofeng.yan@huawei.com>
References: <1399880477-23376-1-git-send-email-xiaofeng.yan@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Fix a comment in deadline.c
Git-Commit-ID: 6e9a8b9d6a9257bc124a1609f25597064ef9c167
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e9a8b9d6a9257bc124a1609f25597064ef9c167
Gitweb:     http://git.kernel.org/tip/6e9a8b9d6a9257bc124a1609f25597064ef9c167
Author:     xiaofeng.yan <xiaofeng.yan@huawei.com>
AuthorDate: Mon, 12 May 2014 07:41:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:42 +0900

sched/rt: Fix a comment in deadline.c

EDF use sched_setattr() instead of sched_setscheduler().

Cc: mingo@redhat.com
Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399880477-23376-1-git-send-email-xiaofeng.yan@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e0a04ae..f9ca7d1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -520,7 +520,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
 	 * different from SCHED_DEADLINE or changed its reservation
-	 * parameters (through sched_setscheduler()).
+	 * parameters (through sched_setattr()).
 	 */
 	if (!dl_task(p) || dl_se->dl_new)
 		goto unlock;
