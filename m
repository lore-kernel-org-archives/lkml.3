Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaAUFfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:35:37 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48819 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaAUFf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:35:29 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
Date: Tue, 21 Jan 2014 13:33:19 +0800
Message-Id: <1390282399-17091-2-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful to track this value in debug mode.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1e43e70..f5c529a 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -315,6 +315,7 @@ do {									\
 	P(sched_goidle);
 #ifdef CONFIG_SMP
 	P64(avg_idle);
+	p64(max_idle_balance_cost);
 #endif
 
 	P(ttwu_count);
-- 
1.8.1.2

