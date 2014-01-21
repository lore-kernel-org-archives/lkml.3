Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaAUQWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:22:17 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47809 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAUQWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:22:15 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, mingo@redhat.com,
        peterz@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] sched: Fix warning on make htmldocs caused by wait.h
Date: Wed, 22 Jan 2014 01:22:06 +0900
Message-Id: <1390321326-23120-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing "@" in include/linux/wait.h cause "make htmldocs" failed
with following warning messages.

Warning(/home/iida/Repo/linux-next//include/linux/wait.h:304):
No description found for parameter 'cmd1'
Warning(/home/iida/Repo/linux-next//include/linux/wait.h:304):
No description found for parameter 'cmd2'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 include/linux/wait.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index eaa00b1..559044c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -286,8 +286,8 @@ do {									\
  * wait_event_cmd - sleep until a condition gets true
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * cmd1: the command will be executed before sleep
- * cmd2: the command will be executed after sleep
+ * @cmd1: the command will be executed before sleep
+ * @cmd2: the command will be executed after sleep
  *
  * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
  * @condition evaluates to true. The @condition is checked each time
-- 
1.9.rc0

