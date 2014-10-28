Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaJ1LE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:04:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaJ1LEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:04:23 -0400
Date: Tue, 28 Oct 2014 04:03:29 -0700
From: tip-bot for Chen Hanxiao <tipbot@zytor.com>
Message-ID: <tip-fcd964dda5ece2fa77f78f843bc3455348787282@git.kernel.org>
Cc: peterz@infradead.org, serge.hallyn@ubuntu.com, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        chenhanxiao@cn.fujitsu.com, torvalds@linux-foundation.org
Reply-To: peterz@infradead.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, chenhanxiao@cn.fujitsu.com,
        hpa@zytor.com
In-Reply-To: <1412674147-8941-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1412674147-8941-1-git-send-email-chenhanxiao@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update comments for CLONE_NEWNS
Git-Commit-ID: fcd964dda5ece2fa77f78f843bc3455348787282
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

Commit-ID:  fcd964dda5ece2fa77f78f843bc3455348787282
Gitweb:     http://git.kernel.org/tip/fcd964dda5ece2fa77f78f843bc3455348787282
Author:     Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
AuthorDate: Tue, 7 Oct 2014 17:29:07 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:08 +0100

sched: Update comments for CLONE_NEWNS

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-api@vger.kernel.org
Link: http://lkml.kernel.org/r/1412674147-8941-1-git-send-email-chenhanxiao@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..b932be9 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -13,7 +13,7 @@
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
 #define CLONE_THREAD	0x00010000	/* Same thread group? */
-#define CLONE_NEWNS	0x00020000	/* New namespace group? */
+#define CLONE_NEWNS	0x00020000	/* New mount namespace group */
 #define CLONE_SYSVSEM	0x00040000	/* share system V SEM_UNDO semantics */
 #define CLONE_SETTLS	0x00080000	/* create a new TLS for the child */
 #define CLONE_PARENT_SETTID	0x00100000	/* set the TID in the parent */
