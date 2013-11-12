Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3KLTnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:43:02 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:60492 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3KLTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 05/17] score: Use Kbuild logic to include <asm-generic/sections.h>
Date: Tue, 12 Nov 2013 20:42:15 +0100
Message-Id: <1384285347-13506-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/include/asm/Kbuild     |    1 +
 arch/score/include/asm/sections.h |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)
 delete mode 100644 arch/score/include/asm/sections.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index f3414ade77a3..32cd967c19a4 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -2,6 +2,7 @@
 header-y +=
 
 generic-y += clkdev.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
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
1.7.9.5

