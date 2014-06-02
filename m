Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaFBRAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:00:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58747 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFBRAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:00:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 2/2] rcu: Add Josh Triplett as designated reviewer
Date: Mon,  2 Jun 2014 10:00:20 -0700
Message-Id: <1401728420-3572-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060217-9332-0000-0000-000000F8181B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57d681d1d7d1..93054c4864d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7321,6 +7321,7 @@ F:	kernel/rcu/torture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+R:	Josh Triplett <josh@joshtriplett.org>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
@@ -7345,6 +7346,7 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+R:	Josh Triplett <josh@joshtriplett.org>
 L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
@@ -8098,6 +8100,7 @@ F:	mm/sl?b.c
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+R:	Josh Triplett <josh@joshtriplett.org>
 L:	linux-kernel@vger.kernel.org
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
-- 
1.8.1.5

