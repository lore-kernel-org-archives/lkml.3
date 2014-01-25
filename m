Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaAYOYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:24:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaAYOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:24:04 -0500
Date: Sat, 25 Jan 2014 06:23:52 -0800
From: tip-bot for Masanari Iida <tipbot@zytor.com>
Message-ID: <tip-b78f4c7c4402d1070dc7ccaca6001abb4ab4053a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, standby24x7@gmail.com
In-Reply-To: <1390321326-23120-1-git-send-email-standby24x7@gmail.com>
References: <1390321326-23120-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix docbook parameter annotation error in wait.h
Git-Commit-ID: b78f4c7c4402d1070dc7ccaca6001abb4ab4053a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:23:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b78f4c7c4402d1070dc7ccaca6001abb4ab4053a
Gitweb:     http://git.kernel.org/tip/b78f4c7c4402d1070dc7ccaca6001abb4ab4053a
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Wed, 22 Jan 2014 01:22:06 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:52:22 +0100

sched: Fix docbook parameter annotation error in wait.h

Missing "@" in include/linux/wait.h causes "make htmldocs" to fail
with the following warning messages:

  Warning(/home/iida/Repo/linux-next//include/linux/wait.h:304):
  No description found for parameter 'cmd1'
  Warning(/home/iida/Repo/linux-next//include/linux/wait.h:304):
  No description found for parameter 'cmd2'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1390321326-23120-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
