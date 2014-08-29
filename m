Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaH2USm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:18:42 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:41015 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaH2USj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:18:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4] ia64: Remove duplicate declarations of __per_cpu_start[] and __per_cpu_end[]
Date: Fri, 29 Aug 2014 22:18:34 +0200
Message-Id: <1409343516-5132-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
References: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're already provided by <asm/sections.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/ia64/include/asm/sections.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/sections.h b/arch/ia64/include/asm/sections.h
index 1a873b36a4a1..2ab2003698ef 100644
--- a/arch/ia64/include/asm/sections.h
+++ b/arch/ia64/include/asm/sections.h
@@ -10,7 +10,7 @@
 #include <linux/uaccess.h>
 #include <asm-generic/sections.h>
 
-extern char __per_cpu_start[], __per_cpu_end[], __phys_per_cpu_start[];
+extern char __phys_per_cpu_start[];
 #ifdef	CONFIG_SMP
 extern char __cpu0_per_cpu[];
 #endif
-- 
1.9.1

