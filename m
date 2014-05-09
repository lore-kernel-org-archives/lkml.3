Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbaEIQbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:31:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985AbaEIQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:31:48 -0400
Date: Fri, 9 May 2014 09:31:29 -0700
From: tip-bot for Andres Freund <tipbot@zytor.com>
Message-ID: <tip-c45f77364ba060395b7eff1bf45e6c537f913380@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andres@anarazel.de, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andres@anarazel.de, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1399598957-7011-3-git-send-email-andres@anarazel.de>
References: <1399598957-7011-3-git-send-email-andres@anarazel.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID macro
Git-Commit-ID: c45f77364ba060395b7eff1bf45e6c537f913380
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c45f77364ba060395b7eff1bf45e6c537f913380
Gitweb:     http://git.kernel.org/tip/c45f77364ba060395b7eff1bf45e6c537f913380
Author:     Andres Freund <andres@anarazel.de>
AuthorDate: Fri, 9 May 2014 03:29:17 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 May 2014 08:42:47 -0700

x86: Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID macro

The spuriously added semicolon didn't have any effect because the
macro isn't currently in use.

c0a639ad0bc6b178b46996bd1f821a04643e2bde

Signed-off-by: Andres Freund <andres@anarazel.de>
Link: http://lkml.kernel.org/r/1399598957-7011-3-git-send-email-andres@anarazel.de
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
