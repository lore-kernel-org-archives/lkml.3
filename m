Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3L3JGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:06:43 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:51687 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3L3JGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:06:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] asm-generic: uaccess: Spelling s/a ny/any/
Date: Mon, 30 Dec 2013 10:06:33 +0100
Message-Id: <1388394393-25743-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-generic/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index dc1269c74a52..72d8803832ff 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -3,7 +3,7 @@
 
 /*
  * User space memory access functions, these should work
- * on a ny machine that has kernel and user data in the same
+ * on any machine that has kernel and user data in the same
  * address space, e.g. all NOMMU machines.
  */
 #include <linux/sched.h>
-- 
1.7.9.5

