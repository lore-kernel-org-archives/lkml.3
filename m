Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaDKKbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:31:37 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58689 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbaDKK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:19 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 08/15] ia64: add renameat2 syscall
Date: Fri, 11 Apr 2014 12:25:44 +0200
Message-Id: <1397211951-20549-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/include/asm/unistd.h      | 2 +-
 arch/ia64/include/uapi/asm/unistd.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index ae763d8bf55a..fb13dc5e8f8c 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -11,7 +11,7 @@
 
 
 
-#define NR_syscalls			314 /* length of syscall table */
+#define NR_syscalls			315 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/include/uapi/asm/unistd.h b/arch/ia64/include/uapi/asm/unistd.h
index 715e85f858de..7de0a2d65da4 100644
--- a/arch/ia64/include/uapi/asm/unistd.h
+++ b/arch/ia64/include/uapi/asm/unistd.h
@@ -327,5 +327,6 @@
 #define __NR_finit_module		1335
 #define __NR_sched_setattr		1336
 #define __NR_sched_getattr		1337
+#define __NR_renameat2			1338
 
 #endif /* _UAPI_ASM_IA64_UNISTD_H */
-- 
1.8.1.4

