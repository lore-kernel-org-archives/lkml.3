Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaH2To6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:44:58 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:57011 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbaH2Tov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:44:51 -0400
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
Subject: [PATCH 1/5] alpha: Use Kbuild logic to include <asm-generic/sections.h>
Date: Fri, 29 Aug 2014 21:44:39 +0200
Message-Id: <1409341483-3451-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
References: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/Kbuild     | 1 +
 arch/alpha/include/asm/sections.h | 7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)
 delete mode 100644 arch/alpha/include/asm/sections.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index e858aa0ad8af..f53010234ff8 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
diff --git a/arch/alpha/include/asm/sections.h b/arch/alpha/include/asm/sections.h
deleted file mode 100644
index 43b40edd6e44..000000000000
--- a/arch/alpha/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ALPHA_SECTIONS_H
-#define _ALPHA_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
-- 
1.9.1

