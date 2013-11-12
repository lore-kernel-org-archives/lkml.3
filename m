Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3KLTnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:43:25 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:60498 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3KLTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
Subject: [PATCH 03/17] m32r: Use Kbuild logic to include <asm-generic/sections.h>
Date: Tue, 12 Nov 2013 20:42:13 +0100
Message-Id: <1384285347-13506-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org
---
 arch/m32r/include/asm/Kbuild     |    1 +
 arch/m32r/include/asm/sections.h |    7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)
 delete mode 100644 arch/m32r/include/asm/sections.h

diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 2b58c5f0bc38..e03862db9b75 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -2,5 +2,6 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += preempt.h
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
1.7.9.5

