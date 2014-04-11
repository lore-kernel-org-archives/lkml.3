Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaDKK0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:26:16 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34230 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbaDKK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:11 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 02/15] arm: __NR_syscalls fix
Date: Fri, 11 Apr 2014 12:25:38 +0200
Message-Id: <1397211951-20549-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/unistd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 43876245fc57..c4cd2060cac2 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -15,7 +15,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define __NR_syscalls  (384)
+#define __NR_syscalls  (382)
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
 #define __ARCH_WANT_STAT64
-- 
1.8.1.4

