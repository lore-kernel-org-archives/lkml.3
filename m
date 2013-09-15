Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3IOJ6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:58:14 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:50989 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3IOJ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:58:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] init.h: Document the existence of __initconst
Date: Sun, 15 Sep 2013 11:58:09 +0200
Message-Id: <1379239089-6111-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initdata can be const since more than 5 years, using the __initconst
keyword.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/init.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index f1c27a7..8e68a64 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -26,8 +26,8 @@
  * extern int initialize_foobar_device(int, int, int) __init;
  *
  * For initialized data:
- * You should insert __initdata between the variable name and equal
- * sign followed by value, e.g.:
+ * You should insert __initdata or __initconst between the variable name
+ * and equal sign followed by value, e.g.:
  *
  * static int init_variable __initdata = 0;
  * static const char linux_logo[] __initconst = { 0x32, 0x36, ... };
@@ -35,8 +35,6 @@
  * Don't forget to initialize data not at file scope, i.e. within a function,
  * as gcc otherwise puts the data into the bss section and not into the init
  * section.
- * 
- * Also note, that this data cannot be "const".
  */
 
 /* These are for everybody (although not all archs will actually
-- 
1.7.9.5

