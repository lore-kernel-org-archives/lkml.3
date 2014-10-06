Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaJFJZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:25:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:8851 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbaJFJZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:25:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,662,1406563200"; 
   d="scan'208";a="36858857"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] sched: updated comments of CLONE_NEWNS
Date: Mon, 6 Oct 2014 17:24:53 +0800
Message-ID: <1412587493-10547-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 include/uapi/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..db765b4 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -13,7 +13,7 @@
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
 #define CLONE_THREAD	0x00010000	/* Same thread group? */
-#define CLONE_NEWNS	0x00020000	/* New namespace group? */
+#define CLONE_NEWNS	0x00020000	/* New mount namespace group? */
 #define CLONE_SYSVSEM	0x00040000	/* share system V SEM_UNDO semantics */
 #define CLONE_SETTLS	0x00080000	/* create a new TLS for the child */
 #define CLONE_PARENT_SETTID	0x00100000	/* set the TID in the parent */
-- 
1.9.0

