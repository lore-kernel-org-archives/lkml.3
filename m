Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaKPMcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:32:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35502 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:32:22 -0500
Date: Sun, 16 Nov 2014 04:31:43 -0800
From: tip-bot for Chen Hanxiao <tipbot@zytor.com>
Message-ID: <tip-f622b429dadf83c3cc2d70f57f407ad85684eb36@git.kernel.org>
Cc: serge.hallyn@ubuntu.com, tglx@linutronix.de, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        trivial@kernel.org, hpa@zytor.com, chenhanxiao@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Reply-To: torvalds@linux-foundation.org, serge.hallyn@ubuntu.com,
        mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        trivial@kernel.org, peterz@infradead.org, chenhanxiao@cn.fujitsu.com,
        hpa@zytor.com
In-Reply-To: <1415091082-15093-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1415091082-15093-1-git-send-email-chenhanxiao@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Update comments about CLONE_NEWUTS and CLONE_NEWIPC
Git-Commit-ID: f622b429dadf83c3cc2d70f57f407ad85684eb36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f622b429dadf83c3cc2d70f57f407ad85684eb36
Gitweb:     http://git.kernel.org/tip/f622b429dadf83c3cc2d70f57f407ad85684eb36
Author:     Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
AuthorDate: Tue, 4 Nov 2014 16:51:22 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:53 +0100

sched: Update comments about CLONE_NEWUTS and CLONE_NEWIPC

Remove question mark:

 s/New utsname group?/New utsname namespace

Unified style for IPC:

 s/New ipcs/New ipc namespace

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-api@vger.kernel.org
Link: http://lkml.kernel.org/r/1415091082-15093-1-git-send-email-chenhanxiao@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index b932be9..cc89dde 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -23,8 +23,8 @@
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
 /* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
    and is now available for re-use. */
-#define CLONE_NEWUTS		0x04000000	/* New utsname group? */
-#define CLONE_NEWIPC		0x08000000	/* New ipcs */
+#define CLONE_NEWUTS		0x04000000	/* New utsname namespace */
+#define CLONE_NEWIPC		0x08000000	/* New ipc namespace */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
 #define CLONE_NEWPID		0x20000000	/* New pid namespace */
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
