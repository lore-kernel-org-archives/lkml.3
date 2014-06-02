Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaFBRAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:00:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60830 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaFBRAe (ORCPT
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
Subject: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Date: Mon,  2 Jun 2014 10:00:19 -0700
Message-Id: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060217-7164-0000-0000-0000022A472A
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
index 6dc67b1fdb50..57d681d1d7d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -73,6 +73,8 @@ Descriptions of section entries:
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
+	R: Designated reviewer, who should be CCed on patches,
+	   format: FullName <address@domain>
 	T: SCM tree type and location.
 	   Type is one of: git, hg, quilt, stgit, topgit
 	S: Status, one of the following:
-- 
1.8.1.5

