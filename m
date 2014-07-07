Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaGGWmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:42:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53459 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaGGWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:42:13 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: Update RCU maintainership
Date: Mon,  7 Jul 2014 15:42:04 -0700
Message-Id: <1404772924-9423-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707224146.GA9118@linux.vnet.ibm.com>
 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-9332-0000-0000-0000014D73F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Drop Dipankar Sarma at his request (https://lkml.org/lkml/2014/6/2/628),
add Josh Triplett based on long-term review, contributions, and
agreement to take on this role (https://lkml.org/lkml/2014/6/2/554).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 92f2bf91eec1..922661d17083 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7405,6 +7405,7 @@ F:	kernel/rcu/torture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Josh Triplett <josh@joshtriplett.org>
 R:	Steven Rostedt <rostedt@goodmis.org>
 R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 R:	Lai Jiangshan <laijs@cn.fujitsu.com>
@@ -7430,8 +7431,8 @@ S:	Supported
 F:	net/rds/
 
 READ-COPY UPDATE (RCU)
-M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Josh Triplett <josh@joshtriplett.org>
 R:	Steven Rostedt <rostedt@goodmis.org>
 R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 R:	Lai Jiangshan <laijs@cn.fujitsu.com>
@@ -8214,6 +8215,7 @@ F:	mm/sl?b.c
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+M:	Josh Triplett <josh@joshtriplett.org>
 R:	Steven Rostedt <rostedt@goodmis.org>
 R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 L:	linux-kernel@vger.kernel.org
-- 
1.8.1.5

