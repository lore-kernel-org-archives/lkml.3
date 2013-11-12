Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3KLTfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:35:00 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:41006 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3KLTew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:34:52 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] init: Remove unused declaration of tc_init()
Date: Tue, 12 Nov 2013 20:21:56 +0100
Message-Id: <1384284116-12678-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its user was removed in v2.5.2.4.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 init/main.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index 67ee8ef0a669..15ed159b681b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -99,10 +99,6 @@ extern void radix_tree_init(void);
 static inline void mark_rodata_ro(void) { }
 #endif
 
-#ifdef CONFIG_TC
-extern void tc_init(void);
-#endif
-
 /*
  * Debug helper: via this flag we know that we are in 'early bootup code'
  * where only the boot processor is running with IRQ disabled.  This means
-- 
1.7.9.5

