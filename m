Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaBHGSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 01:18:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:50926 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaBHGSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 01:18:48 -0500
Message-ID: <52F5CC09.1080502@huawei.com>
Date: Sat, 8 Feb 2014 14:17:45 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] sched/rt: Make init_sched_rt_calss() __init
References: <52F5CBF6.4060901@huawei.com>
In-Reply-To: <52F5CBF6.4060901@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a bootstrap function.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1c40655..e45ec9a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1825,7 +1825,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		resched_task(rq->curr);
 }
 
-void init_sched_rt_class(void)
+void __init init_sched_rt_class(void)
 {
 	unsigned int i;
 
-- 
1.8.0.2
