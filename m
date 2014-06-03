Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaFCNOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:14:52 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51293 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaFCNOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:14:51 -0400
Date: Tue, 3 Jun 2014 15:14:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups change for v3.16
Message-ID: <20140603131446.GA28127@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   # HEAD: 79a51b25badae79d2da6f7b54530adf56697f669 x86/irq: Clean up VECTOR_UNDEFINED and VECTOR_RETRIGGERED definition

A single, trivial cleanup.

 Thanks,

	Ingo

------------------>
Prarit Bhargava (1):
      x86/irq: Clean up VECTOR_UNDEFINED and VECTOR_RETRIGGERED definition


 arch/x86/include/asm/hw_irq.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a307b75..4615906 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -190,8 +190,8 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 #define trace_interrupt interrupt
 #endif
 
-#define VECTOR_UNDEFINED	-1
-#define VECTOR_RETRIGGERED	-2
+#define VECTOR_UNDEFINED	(-1)
+#define VECTOR_RETRIGGERED	(-2)
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
