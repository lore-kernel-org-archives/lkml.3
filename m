Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3EGJ4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:56:00 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:39468 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab3EGJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:55:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] sparc: Switch to asm-generic/linkage.h
Date: Tue,  7 May 2013 11:55:55 +0200
Message-Id: <1367920555-18544-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/include/asm/Kbuild    |    1 +
 arch/sparc/include/asm/linkage.h |    6 ------
 2 files changed, 1 insertions(+), 6 deletions(-)
 delete mode 100644 arch/sparc/include/asm/linkage.h

diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index ff18e3c..7e4a97f 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -6,6 +6,7 @@ generic-y += cputime.h
 generic-y += div64.h
 generic-y += emergency-restart.h
 generic-y += exec.h
+generic-y += linkage.h
 generic-y += local64.h
 generic-y += mutex.h
 generic-y += irq_regs.h
diff --git a/arch/sparc/include/asm/linkage.h b/arch/sparc/include/asm/linkage.h
deleted file mode 100644
index 291c2d0..0000000
--- a/arch/sparc/include/asm/linkage.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_LINKAGE_H
-#define __ASM_LINKAGE_H
-
-/* Nothing to see here... */
-
-#endif
-- 
1.7.0.4

