Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3KLToK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:44:10 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:46784 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3KLTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:44 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: [PATCH 01/17] alpha: Use Kbuild logic to include <asm-generic/sections.h>
Date: Tue, 12 Nov 2013 20:42:11 +0100
Message-Id: <1384285347-13506-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/include/asm/Kbuild     |    2 +-
 arch/alpha/include/asm/sections.h |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)
 delete mode 100644 arch/alpha/include/asm/sections.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index f01fb505ad52..cd33bcfc49d8 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,6 +1,6 @@
 
 generic-y += clkdev.h
-
 generic-y += exec.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += preempt.h
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
1.7.9.5

