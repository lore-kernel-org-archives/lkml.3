Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435Ab3DKR3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:29:13 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49005 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765541Ab3DKR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:29:11 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH v2] include:linux: task_struct personality comment
Date: Thu, 11 Apr 2013 20:30:29 +0300
Message-Id: <1365701429-4721-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 include/linux/sched.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..c6b2119 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1274,8 +1274,10 @@ struct task_struct {
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
-	/* ??? */
+
+	/* used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
+
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
-- 
1.7.9.5

