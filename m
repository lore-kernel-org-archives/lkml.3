Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaEIB3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:29:36 -0400
Received: from mail.anarazel.de ([217.115.131.40]:33631 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbaEIB3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:29:34 -0400
From: Andres Freund <andres@anarazel.de>
To: Borislav Petkov <bp@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] x86: Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID macro
Date: Fri,  9 May 2014 03:29:17 +0200
Message-Id: <1399598957-7011-3-git-send-email-andres@anarazel.de>
X-Mailer: git-send-email 2.0.0.rc2.4.g1dc51c6.dirty
In-Reply-To: <1399598957-7011-1-git-send-email-andres@anarazel.de>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spuriously added semicolon didn't have any effect because the
macro isn't currently in use.

c0a639ad0bc6b178b46996bd1f821a04643e2bde

Signed-off-by: Andres Freund <andres@anarazel.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/uapi/asm/msr-index.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index c827ace..fcf2b3a 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -384,7 +384,7 @@
 #define MSR_IA32_MISC_ENABLE_MWAIT_BIT			18
 #define MSR_IA32_MISC_ENABLE_MWAIT			(1ULL << MSR_IA32_MISC_ENABLE_MWAIT_BIT)
 #define MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT		22
-#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT);
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT)
 #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE_BIT		23
 #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_XTPR_DISABLE_BIT)
 #define MSR_IA32_MISC_ENABLE_XD_DISABLE_BIT		34
-- 
2.0.0.rc2.4.g1dc51c6.dirty

