Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbaDKKcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:32:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40347 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbaDKK0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 05/15] arm64: add renameat2 syscall
Date: Fri, 11 Apr 2014 12:25:41 +0200
Message-Id: <1397211951-20549-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/unistd32.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index faa0e1ce59df..c8d8fc17bd5a 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -403,8 +403,9 @@ __SYSCALL(378, sys_kcmp)
 __SYSCALL(379, sys_finit_module)
 __SYSCALL(380, sys_sched_setattr)
 __SYSCALL(381, sys_sched_getattr)
+__SYSCALL(382, sys_renameat2)
 
-#define __NR_compat_syscalls		382
+#define __NR_compat_syscalls		383
 
 /*
  * Compat syscall numbers used by the AArch64 kernel.
-- 
1.8.1.4

