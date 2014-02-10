Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaBJNbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:31:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaBJNbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:46 -0500
Date: Mon, 10 Feb 2014 05:31:35 -0800
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-6d4989835e5418fdfda764fce7294246f80cf464@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1402042354210.7839@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042354210.7839@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Remove unused function prototypes
Git-Commit-ID: 6d4989835e5418fdfda764fce7294246f80cf464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:31:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d4989835e5418fdfda764fce7294246f80cf464
Gitweb:     http://git.kernel.org/tip/6d4989835e5418fdfda764fce7294246f80cf464
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 4 Feb 2014 23:55:04 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:15:09 +0100

x86/apic: Remove unused function prototypes

Some function prototypes declared in asm/apic.h are never
defined, so remove them.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1402042354210.7839@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c1d3074..b4c561d 100644
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
