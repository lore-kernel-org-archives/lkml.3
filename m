Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaKGOyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:54:25 -0500
Received: from filter1.ibarracuda.nl ([83.247.7.10]:59788 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaKGOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:54:23 -0500
X-ASG-Debug-ID: 1415372061-0759e711ce2936c0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Jiri Kosina <trivial@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH trivial] kernel: trace: fix typo
Date: Fri, 7 Nov 2014 15:53:44 +0100
X-ASG-Orig-Subj: [PATCH trivial] kernel: trace: fix typo
Message-ID: <1415372024-16708-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1415372061
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.11334
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s,produciton,production

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a52839..f3ef80c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2028,7 +2028,7 @@ void trace_printk_init_buffers(void)
 	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
 	pr_warning("**                                                      **\n");
 	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
-	pr_warning("** unsafe for produciton use.                           **\n");
+	pr_warning("** unsafe for production use.                           **\n");
 	pr_warning("**                                                      **\n");
 	pr_warning("** If you see this message and you are not debugging    **\n");
 	pr_warning("** the kernel, report this immediately to your vendor!  **\n");
-- 
2.1.0

