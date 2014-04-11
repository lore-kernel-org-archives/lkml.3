Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbaDKK1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:27:50 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:38884 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201AbaDKK01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:27 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Chris Zankel <chris@zankel.net>
Subject: [PATCH 14/15] xtensa: add renameat2 syscall
Date: Fri, 11 Apr 2014 12:25:50 +0200
Message-Id: <1397211951-20549-15-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/include/uapi/asm/unistd.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
index b9395529f02d..8883fc877c5c 100644
--- a/arch/xtensa/include/uapi/asm/unistd.h
+++ b/arch/xtensa/include/uapi/asm/unistd.h
@@ -739,7 +739,10 @@ __SYSCALL(334, sys_sched_setattr, 2)
 #define __NR_sched_getattr			335
 __SYSCALL(335, sys_sched_getattr, 3)
 
-#define __NR_syscall_count			336
+#define __NR_renameat2				336
+__SYSCALL(336, sys_renameat2, 5)
+
+#define __NR_syscall_count			337
 
 /*
  * sysxtensa syscall handler
-- 
1.8.1.4

