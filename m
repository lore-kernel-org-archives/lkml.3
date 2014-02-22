Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaBVSFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:05:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaBVSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:05:06 -0500
Date: Sat, 22 Feb 2014 10:04:31 -0800
From: tip-bot for Morten Rasmussen <tipbot@zytor.com>
Message-ID: <tip-de91b9cb97fe68cb6ef0cfe9bee09d015c152af8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        morten.rasmussen@arm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392732864-10927-1-git-send-email-morten.rasmussen@arm.com>
References: <1392732864-10927-1-git-send-email-morten.rasmussen@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix select_task_rq_fair()
  description comments
Git-Commit-ID: de91b9cb97fe68cb6ef0cfe9bee09d015c152af8
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

Commit-ID:  de91b9cb97fe68cb6ef0cfe9bee09d015c152af8
Gitweb:     http://git.kernel.org/tip/de91b9cb97fe68cb6ef0cfe9bee09d015c152af8
Author:     Morten Rasmussen <morten.rasmussen@arm.com>
AuthorDate: Tue, 18 Feb 2014 14:14:24 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:17:04 +0100

sched: Fix select_task_rq_fair() description comments

Brings select_task_rq_fair() description comments up-to-date.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392732864-10927-1-git-send-email-morten.rasmussen@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e884e45..7982faf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4397,13 +4397,14 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
+ * select_task_rq_fair: Select target runqueue for the waking task in domains
+ * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
+ * SD_BALANCE_FORK, or SD_BALANCE_EXEC.
  *
- * Balance, ie. select the least loaded group.
+ * Balances load by selecting the idlest cpu in the idlest group, or under
+ * certain conditions an idle sibling cpu if the domain has SD_WAKE_AFFINE set.
  *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
+ * Returns the target cpu number.
  *
  * preempt must be disabled.
  */
