Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3CFOfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:35:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44241 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3CFOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:35:12 -0500
Date: Wed, 6 Mar 2013 06:32:55 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-19a37d1cd5465c10d669a296a2ea24b4c985363b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A748.3050206@huawei.com>
References: <5135A748.3050206@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove some dummy functions
Git-Commit-ID: 19a37d1cd5465c10d669a296a2ea24b4c985363b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:33:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19a37d1cd5465c10d669a296a2ea24b4c985363b
Gitweb:     http://git.kernel.org/tip/19a37d1cd5465c10d669a296a2ea24b4c985363b
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:05:28 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:28 +0100

sched: Remove some dummy functions

No one will call those functions if CONFIG_SCHED_DEBUG=n.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A748.3050206@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..2715fbb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -127,18 +127,6 @@ extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m);
 extern void proc_sched_set_task(struct task_struct *p);
 extern void
 print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
-#else
-static inline void
-proc_sched_show_task(struct task_struct *p, struct seq_file *m)
-{
-}
-static inline void proc_sched_set_task(struct task_struct *p)
-{
-}
-static inline void
-print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
-{
-}
 #endif
 
 /*
