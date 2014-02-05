Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaBEHzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 02:55:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46959 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaBEHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 02:55:06 -0500
Date: Tue, 4 Feb 2014 23:55:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [patch 3/4] x86, apic: Remove unused function prototypes
In-Reply-To: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402042354210.7839@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some function prototypes declared in asm/apic.h are never defined, so
remove them.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/apic.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -93,9 +93,6 @@ static inline int is_vsmp_box(void)
 	return 0;
 }
 #endif
-extern void xapic_wait_icr_idle(void);
-extern u32 safe_xapic_wait_icr_idle(void);
-extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
@@ -184,7 +181,6 @@ extern int x2apic_phys;
 extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
-extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
 	u64 msr;
