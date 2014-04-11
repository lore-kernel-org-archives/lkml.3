Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaDKNA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:00:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:38036 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755985AbaDKNAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:00:54 -0400
Date: Fri, 11 Apr 2014 09:00:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH] tracing: Add missing function triggers dump and
 cpudump to README
Message-ID: <20140411090052.312aabdf@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 17a280ea8111c66791c18c0353b7986aafcb24fe


Steven Rostedt (Red Hat) (1):
      tracing: Add missing function triggers dump and cpudump to README

----
 kernel/trace/trace.c | 2 ++
 1 file changed, 2 insertions(+)
---------------------------
commit 17a280ea8111c66791c18c0353b7986aafcb24fe
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Thu Apr 10 22:43:37 2014 -0400

    tracing: Add missing function triggers dump and cpudump to README
    
    The debugfs tracing README file lists all the function triggers except for
    dump and cpudump. These should be added too.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9be67c5..e3e6656 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3611,6 +3611,8 @@ static const char readme_msg[] =
 #ifdef CONFIG_TRACER_SNAPSHOT
 	"\t\t      snapshot\n"
 #endif
+	"\t\t      dump\n"
+	"\t\t      cpudump\n"
 	"\t     example: echo do_fault:traceoff > set_ftrace_filter\n"
 	"\t              echo do_trap:traceoff:3 > set_ftrace_filter\n"
 	"\t     The first one will disable tracing every time do_fault is hit\n"
