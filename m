Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030305AbaDKK2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:28:45 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39743 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965159AbaDKK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:26:23 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 11/15] s390: NR_syscalls fix
Date: Fri, 11 Apr 2014 12:25:47 +0200
Message-Id: <1397211951-20549-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/uapi/asm/unistd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 5eb5c9ddb120..57194268fe63 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -282,7 +282,7 @@
 #define __NR_finit_module	344
 #define __NR_sched_setattr	345
 #define __NR_sched_getattr	346
-#define NR_syscalls 345
+#define NR_syscalls 347
 
 /* 
  * There are some system calls that are not present on 64 bit, some
-- 
1.8.1.4

