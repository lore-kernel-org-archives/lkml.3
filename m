Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3KDIkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:40:33 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:41033 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3KDIkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:40:33 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] init/main.c: Remove prototype for softirq_init()
Date: Mon,  4 Nov 2013 09:40:12 +0100
Message-Id: <1383554412-13529-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's already available in <linux/interrupt.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 init/main.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 63d3e8f2970c..7e89f7cc2ac5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -124,7 +124,6 @@ EXPORT_SYMBOL(system_state);
 extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
 void (*__initdata late_time_init)(void);
-extern void softirq_init(void);
 
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
-- 
1.7.9.5

