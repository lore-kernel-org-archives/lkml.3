Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3KPALI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:11:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43112 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3KPAKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:10:38 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] rcu: Fix formatting blows in kernel-parameters.txt
Date: Fri, 15 Nov 2013 16:10:28 -0800
Message-Id: <1384560630-28719-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116001005.GA28191@linux.vnet.ibm.com>
 <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DCB2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3dc13e90a40..3f2f0d04d35c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2604,7 +2604,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			for RCU-preempt, and "s" for RCU-sched, and "N"
 			is the CPU number.  This reduces OS jitter on the
 			offloaded CPUs, which can be useful for HPC and
-
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
@@ -2620,8 +2619,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			periodically wake up to do the polling.
 
 	rcutree.blimit=	[KNL]
-			Set maximum number of finished RCU callbacks to process
-			in one batch.
+			Set maximum number of finished RCU callbacks to
+			process in one batch.
 
 	rcutree.rcu_fanout_leaf= [KNL]
 			Increase the number of CPUs assigned to each
@@ -2640,8 +2639,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			value is one, and maximum value is HZ.
 
 	rcutree.qhimark= [KNL]
-			Set threshold of queued
-			RCU callbacks over which batch limiting is disabled.
+			Set threshold of queued RCU callbacks beyond which
+			batch limiting is disabled.
 
 	rcutree.qlowmark= [KNL]
 			Set threshold of queued RCU callbacks below which
-- 
1.8.1.5

