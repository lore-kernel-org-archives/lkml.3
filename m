Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3FGHab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:30:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:11064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab3FGHa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="325673109"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>
Subject: [RFC patch 4/4] sched/tg: remove tg.load_weight
Date: Fri,  7 Jun 2013 15:29:29 +0800
Message-Id: <1370590169-24804-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since no one use it.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/sched.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 874731f..09e2719 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -148,7 +148,6 @@ struct task_group {
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
 
-	atomic_t load_weight;
 #ifdef	CONFIG_SMP
 	atomic_long_t load_avg;
 	atomic_t runnable_avg;
-- 
1.7.12

