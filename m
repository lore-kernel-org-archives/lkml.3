Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaJ1WEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:04:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53169 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbaJ1WET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:04:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/5] documentation: Document RCU self test boot params
Date: Tue, 28 Oct 2014 15:00:14 -0700
Message-Id: <1414533617-25933-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215937.GA25095@linux.vnet.ibm.com>
 <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F4F2A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Document the RCU self test boot parameters in kernel-parameters.txt.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7dbe5ec9d9cd..4e2ae0e55474 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3071,6 +3071,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			messages.  Disable with a value less than or equal
 			to zero.
 
+	rcupdate.rcu_self_test= [KNL]
+			Run the RCU early boot self tests
+
+	rcupdate.rcu_self_test_bh= [KNL]
+			Run the RCU bh early boot self tests
+
+	rcupdate.rcu_self_test_sched= [KNL]
+			Run the RCU sched early boot self tests
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
-- 
1.8.1.5

