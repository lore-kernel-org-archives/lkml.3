Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaAXLzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:55:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44365 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXLzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:55:23 -0500
From: Kang Hu <hukangustc@gmail.com>
To: akpm@linux-foundation.org, tglx@linutronix.de, rostedt@goodmis.org,
        geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, Kang Hu <hukangustc@gmail.com>
Subject: [PATCH 1/1] init/main.c: remove unused declaractions of mca_init() and sbus_init()
Date: Fri, 24 Jan 2014 19:54:37 +0800
Message-Id: <1390564477-7009-1-git-send-email-hukangustc@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mca_init() no longer exists.
sbus_init() is defined in arch/sparc/kernel/sbus.c and is a subsys_initcall.
both are not needed in main.c any more.

Signed-off-by: Kang Hu <hukangustc@gmail.com>
---
 init/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index f333385..09f4bfc 100644
--- a/init/main.c
+++ b/init/main.c
@@ -92,8 +92,6 @@ static int kernel_init(void *);
 
 extern void init_IRQ(void);
 extern void fork_init(unsigned long);
-extern void mca_init(void);
-extern void sbus_init(void);
 extern void radix_tree_init(void);
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
-- 
1.8.5.3

