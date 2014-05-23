Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEWIyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:54:46 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:51832 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaEWIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:54:43 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 4/4] tile: Update comments for generic idle conversion
Date: Fri, 23 May 2014 10:54:25 +0200
Message-Id: <1400835265-21956-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400835265-21956-1-git-send-email-geert+renesas@glider.be>
References: <1400835265-21956-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 0dc8153cfebac68c9523b8852b14f10b31209f08 ("tile: Use generic
idle loop"), this applies to arch_cpu_idle() instead of cpu_idle().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/thread_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 729aa107f64e..80ba7d40ecc0 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -94,7 +94,7 @@ register unsigned long stack_pointer __asm__("sp");
 /* Sit on a nap instruction until interrupted. */
 extern void smp_nap(void);
 
-/* Enable interrupts racelessly and nap forever: helper for cpu_idle(). */
+/* Enable interrupts racelessly and nap forever: helper for arch_cpu_idle(). */
 extern void _cpu_idle(void);
 
 #else /* __ASSEMBLY__ */
-- 
1.9.1

