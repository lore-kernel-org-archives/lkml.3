Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaH2Toy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:44:54 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:37842 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaH2Tov (ORCPT
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
Subject: [PATCH 5/5] score: Use Kbuild logic to include <asm-generic/sections.h>
Date: Fri, 29 Aug 2014 21:44:43 +0200
Message-Id: <1409341483-3451-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
References: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/include/asm/Kbuild     | 1 +
 arch/score/include/asm/sections.h | 6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)
 delete mode 100644 arch/score/include/asm/sections.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index aad209199f7e..6fc350390063 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -9,5 +9,6 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff --git a/arch/score/include/asm/sections.h b/arch/score/include/asm/sections.h
deleted file mode 100644
index 9441d23af005..000000000000
--- a/arch/score/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SECTIONS_H
-#define _ASM_SCORE_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif /* _ASM_SCORE_SECTIONS_H */
-- 
1.9.1

