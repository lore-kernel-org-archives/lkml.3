Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaH2TqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:46:19 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41680 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaH2Tow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:44:52 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        David Howells <dhowells@redhat.com>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/5] m32r: Use Kbuild logic to include <asm-generic/sections.h>
Date: Fri, 29 Aug 2014 21:44:41 +0200
Message-Id: <1409341483-3451-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
References: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m32r/include/asm/Kbuild     | 1 +
 arch/m32r/include/asm/sections.h | 7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)
 delete mode 100644 arch/m32r/include/asm/sections.h

diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index accc10a3dc78..761eb79eff4d 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
diff --git a/arch/m32r/include/asm/sections.h b/arch/m32r/include/asm/sections.h
deleted file mode 100644
index 5e5d21c4908a..000000000000
--- a/arch/m32r/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _M32R_SECTIONS_H
-#define _M32R_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif	/* _M32R_SECTIONS_H */
-- 
1.9.1

