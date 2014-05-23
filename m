Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaEWIzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:55:06 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:51871 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaEWIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:54:45 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/4] powerpc: Update comments for generic idle conversion
Date: Fri, 23 May 2014 10:54:24 +0200
Message-Id: <1400835265-21956-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400835265-21956-1-git-send-email-geert+renesas@glider.be>
References: <1400835265-21956-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 799fef06123f86ff69cf754f996219e6ad1678f8 ("powerpc: Use
generic idle loop"), this applies to arch_cpu_idle() instead of cpu_idle().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index ca1cd7459c4a..248ee7e5bebd 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -304,7 +304,7 @@ void notrace restore_interrupts(void)
  * being re-enabled and generally sanitized the lazy irq state,
  * and in the latter case it will leave with interrupts hard
  * disabled and marked as such, so the local_irq_enable() call
- * in cpu_idle() will properly re-enable everything.
+ * in arch_cpu_idle() will properly re-enable everything.
  */
 bool prep_irq_for_idle(void)
 {
-- 
1.9.1

