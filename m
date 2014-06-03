Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbaFCPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:35:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44870 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbaFCPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:35:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 RFC 1/3] MAINTAINERS: Add "R:" designated-reviewers tag
Date: Tue,  3 Jun 2014 08:35:34 -0700
Message-Id: <1401809736-12023-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060315-8236-0000-0000-000002D3075C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A ksummit-discuss email thread looked at the difficulty recruiting
and retaining reviewers.  Paul Walmsley also noted the need for patch
submitters to know who the key reviewers are and suggested adding an
"R:" tag to the MAINTAINERS file to record this information on a
per-subsystem basis.  This commit does just that, and a subsequent
commit tags the designated reviewer for the RCU-related subsystems.

http://lists.linuxfoundation.org/pipermail/ksummit-discuss/2014-May/000830.html

Suggested-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1fdb50..8513adb1135d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -70,6 +70,8 @@ Descriptions of section entries:
 
 	P: Person (obsolete)
 	M: Mail patches to: FullName <address@domain>
+	R: Designated reviewer, who should be CCed on patches,
+	   format: FullName <address@domain>
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
-- 
1.8.1.5

