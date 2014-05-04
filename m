Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaEDQex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:34:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaEDPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.14 100/158] arm64: __NR_compat_syscalls fix
Date: Sun,  4 May 2014 11:40:09 -0400
Message-Id: <20140504154043.539198942@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 838977f0178334bf3d7f3e974ea3154b68979be0 upstream.

This fixes commit 6290b53de025 (arm64: compat: Wire up new AArch32 syscalls)
which did not update __NR_compat_syscalls accordingly.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/unistd32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -404,7 +404,7 @@ __SYSCALL(379, sys_finit_module)
 __SYSCALL(380, sys_sched_setattr)
 __SYSCALL(381, sys_sched_getattr)
 
-#define __NR_compat_syscalls		379
+#define __NR_compat_syscalls		382
 
 /*
  * Compat syscall numbers used by the AArch64 kernel.


