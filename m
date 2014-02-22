Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaBVSDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:03:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaBVSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:03:46 -0500
Date: Sat, 22 Feb 2014 10:03:13 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-11c785b79ef2a669e4bf7be5cf2c3904b8fed015@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <52F5CC09.1080502@huawei.com>
References: <52F5CC09.1080502@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Make init_sched_rt_calss() __init
Git-Commit-ID: 11c785b79ef2a669e4bf7be5cf2c3904b8fed015
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

Commit-ID:  11c785b79ef2a669e4bf7be5cf2c3904b8fed015
Gitweb:     http://git.kernel.org/tip/11c785b79ef2a669e4bf7be5cf2c3904b8fed015
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Sat, 8 Feb 2014 14:17:45 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:11:10 +0100

sched/rt: Make init_sched_rt_calss() __init

It's a bootstrap function.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/52F5CC09.1080502@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3e488ca..4d4b386 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1849,7 +1849,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		resched_task(rq->curr);
 }
 
-void init_sched_rt_class(void)
+void __init init_sched_rt_class(void)
 {
 	unsigned int i;
 
