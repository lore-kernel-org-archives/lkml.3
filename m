Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaIIVtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:49:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaIIVtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:49:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: fix typo in pr_warning() message
Date: Tue,  9 Sep 2014 22:49:29 +0100
Message-Id: <1410299369-20029-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace 'produciton' by 'production'

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a528392b1f4..f3ef80c8914c 100644
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
1.9.1

