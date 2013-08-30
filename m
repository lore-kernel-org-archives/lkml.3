Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3H3Xxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:53:42 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42932 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3H3XwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:52:15 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        "David S. Miller" <davem@davemloft.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 7/8] Drop remaining references to H8/300 architecture
Date: Fri, 30 Aug 2013 16:51:33 -0700
Message-Id: <1377906694-9578-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377906694-9578-1-git-send-email-linux@roeck-us.net>
References: <1377906694-9578-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the architecture gone, any references to it are no longer needed.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/uapi/linux/audit.h  |    1 -
 include/uapi/linux/elf-em.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75cef3f..db0b825 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -329,7 +329,6 @@ enum {
 #define AUDIT_ARCH_ARMEB	(EM_ARM)
 #define AUDIT_ARCH_CRIS		(EM_CRIS|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_FRV		(EM_FRV)
-#define AUDIT_ARCH_H8300	(EM_H8_300)
 #define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_IA64		(EM_IA_64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
 #define AUDIT_ARCH_M32R		(EM_M32R)
diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
index 8e2b7ba..dcca7ed 100644
--- a/include/uapi/linux/elf-em.h
+++ b/include/uapi/linux/elf-em.h
@@ -30,7 +30,6 @@
 #define EM_CRIS		76	/* Axis Communications 32-bit embedded processor */
 #define EM_V850		87	/* NEC v850 */
 #define EM_M32R		88	/* Renesas M32R */
-#define EM_H8_300	46	/* Renesas H8/300,300H,H8S */
 #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
 #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
 #define EM_TI_C6000	140	/* TI C6X DSPs */
-- 
1.7.9.7

