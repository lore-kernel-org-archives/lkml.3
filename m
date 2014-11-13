Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaKMNng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:43:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58537 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaKMNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:43:35 -0500
From: Alex Shi <alex.shi@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched/nohz: remove unused varible nohz_stamp in rq
Date: Thu, 13 Nov 2014 21:43:07 +0800
Message-Id: <1415886187-17161-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/sched.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..63b4f99 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -533,7 +533,6 @@ struct rq {
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ_COMMON
-	u64 nohz_stamp;
 	unsigned long nohz_flags;
 #endif
 #ifdef CONFIG_NO_HZ_FULL
-- 
1.9.1

