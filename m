Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaH1S1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:27:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50700 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaH1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/15] rcu: Update tiny.c references to tree.c
Date: Thu, 28 Aug 2014 11:26:28 -0700
Message-Id: <1409250394-25159-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-1542-0000-0000-0000045F4E05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

This commit updates the references to rcutree.c which is now rcu/tree.c

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index d9efcc13008c..6bd785c34add 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -51,7 +51,7 @@ static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 #include "tiny_plugin.h"
 
-/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
+/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcu/tree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
 	if (newval) {
@@ -114,7 +114,7 @@ void rcu_irq_exit(void)
 }
 EXPORT_SYMBOL_GPL(rcu_irq_exit);
 
-/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
+/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcu/tree.c. */
 static void rcu_idle_exit_common(long long oldval)
 {
 	if (oldval) {
-- 
1.8.1.5

