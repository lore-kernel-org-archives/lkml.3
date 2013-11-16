Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3KPAKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:10:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43105 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3KPAKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:10:37 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] rcu: Fix typo in Documentation/RCU/trace.txt
Date: Fri, 15 Nov 2013 16:10:27 -0800
Message-Id: <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20131116001005.GA28191@linux.vnet.ibm.com>
References: <20131116001005.GA28191@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DCB29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index f3778f8952da..7f5c57d78f3a 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -443,7 +443,7 @@ The output of "cat rcu/rcuboost" looks as follows:
     balk: nt=0 egt=6541 bt=0 nb=0 ny=126 nos=0
 
 This information is output only for rcu_preempt.  Each two-line entry
-corresponds to a leaf rcu_node strcuture.  The fields are as follows:
+corresponds to a leaf rcu_node structure.  The fields are as follows:
 
 o	"n:m" is the CPU-number range for the corresponding two-line
 	entry.  In the sample output above, the first entry covers
-- 
1.8.1.5

