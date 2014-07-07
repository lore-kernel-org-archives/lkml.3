Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaGGWmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:42:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46275 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaGGWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:42:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Date: Mon,  7 Jul 2014 15:42:03 -0700
Message-Id: <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707224146.GA9118@linux.vnet.ibm.com>
 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-7164-0000-0000-000002F48320
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Adding Steven Rostedt, Mathieu Desnoyers, and Lai Jiangshan as designated
RCU reviewers based on recent emails:

o	https://lkml.org/lkml/2014/6/2/578 (Steven)
o	https://lkml.org/lkml/2014/6/2/621 (Mathieu)
o	https://lkml.org/lkml/2014/6/3/897 (Lai)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1814075c0e74..92f2bf91eec1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7405,6 +7405,9 @@ F:	kernel/rcu/torture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+R:	Lai Jiangshan <laijs@cn.fujitsu.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -7429,6 +7432,9 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+R:	Lai Jiangshan <laijs@cn.fujitsu.com>
 L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
@@ -8208,6 +8214,8 @@ F:	mm/sl?b.c
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+R:	Steven Rostedt <rostedt@goodmis.org>
+R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
-- 
1.8.1.5

