Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBQVim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:38:42 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57924 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaBQVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Paul Bolle <pebolle@tiscali.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/12] rcu: Disambiguate CONFIG_RCU_NOCB_CPUs
Date: Mon, 17 Feb 2014 13:35:54 -0800
Message-Id: <1392672959-6386-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-000006267599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

This commit fixes a grammar issue in the rcu_nohz_full_cpu() comment
header, so that it is clear that the plural is CPUs not Kconfig options.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f9b9cdd36c8d..fffe4178a23d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2893,7 +2893,7 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
  * CPU unless the grace period has extended for too long.
  *
  * This code relies on the fact that all NO_HZ_FULL CPUs are also
- * CONFIG_RCU_NOCB_CPUs.
+ * CONFIG_RCU_NOCB_CPU CPUs.
  */
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 {
-- 
1.8.1.5

