Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaKDIx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:53:29 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:16237 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbaKDIx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:53:27 -0500
X-IronPort-AV: E=Sophos;i="5.04,845,1406563200"; 
   d="scan'208";a="42816034"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <trivial@kernel.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [PATCH] sched: updated comments of CLONE_NEWUTS and CLONE_NEWIPC
Date: Tue, 4 Nov 2014 16:51:22 +0800
Message-ID: <1415091082-15093-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove question mark:
s/New utsname group?/New utsname namespace

Unified style for IPC:
s/New ipcs/New ipc namespace

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
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
-- 
1.9.3

