Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbbAGST4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:19:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53607 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbbAGSTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/12] rcu: Remove redundant rcu_batches_completed() declaration
Date: Wed,  7 Jan 2015 10:19:33 -0800
Message-Id: <1420654779-11213-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-8236-0000-0000-0000086A7729
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 1a07d7379ac6..69eb422445f9 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -546,7 +546,6 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
-unsigned long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(void);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.8.1.5

