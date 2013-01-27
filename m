Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3A0AaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:30:05 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40677 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3A0AaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:30:01 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/10] rcu: Remove obsolete Kconfig option from comment
Date: Sat, 26 Jan 2013 16:15:11 -0800
Message-Id: <1359245712-3843-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
 <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-7606-0000-0000-000007C87942
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 275aa3f..7e12dba 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -749,7 +749,7 @@ static inline void rcu_preempt_sleep_check(void)
  * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
  * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
  * be preempted, but explicit blocking is illegal.  Finally, in preemptible
- * RCU implementations in real-time (CONFIG_PREEMPT_RT) kernel builds,
+ * RCU implementations in real-time (with -rt patchset) kernel builds,
  * RCU read-side critical sections may be preempted and they may also
  * block, but only when acquiring spinlocks that are subject to priority
  * inheritance.
-- 
1.7.8

