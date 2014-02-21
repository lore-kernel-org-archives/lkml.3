Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbaBUVdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:33:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaBUVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:33:19 -0500
Date: Fri, 21 Feb 2014 13:32:47 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-6bd5d275ea039721f6fd382a15dc6adc949c77ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <52F5CC09.1080502@huawei.com>
References: <52F5CC09.1080502@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Make init_sched_rt_calss() __init
Git-Commit-ID: 6bd5d275ea039721f6fd382a15dc6adc949c77ec
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

Commit-ID:  6bd5d275ea039721f6fd382a15dc6adc949c77ec
Gitweb:     http://git.kernel.org/tip/6bd5d275ea039721f6fd382a15dc6adc949c77ec
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Sat, 8 Feb 2014 14:17:45 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:19 +0100

sched/rt: Make init_sched_rt_calss() __init

It's a bootstrap function.

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/52F5CC09.1080502@huawei.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b22a090..0160887 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1857,7 +1857,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		resched_task(rq->curr);
 }
 
-void init_sched_rt_class(void)
+void __init init_sched_rt_class(void)
 {
 	unsigned int i;
 
