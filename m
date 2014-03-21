Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbaCUDW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 23:22:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076AbaCUDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 23:22:24 -0400
Date: Thu, 20 Mar 2014 20:21:51 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-3c1b63b9e4862fb16352a0646439c2dd6d9e0e5c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de
In-Reply-To: <2ce2ce18447d8a0b78d44a278a066b6c0af06b32.1395366931.git.luto@amacapital.net>
References: <2ce2ce18447d8a0b78d44a278a066b6c0af06b32.1395366931.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Finish removing VDSO32_PRELINK
Git-Commit-ID: 3c1b63b9e4862fb16352a0646439c2dd6d9e0e5c
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

Commit-ID:  3c1b63b9e4862fb16352a0646439c2dd6d9e0e5c
Gitweb:     http://git.kernel.org/tip/3c1b63b9e4862fb16352a0646439c2dd6d9e0e5c
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 20 Mar 2014 18:57:19 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 20 Mar 2014 20:20:18 -0700

x86, vdso: Finish removing VDSO32_PRELINK

It's a declaration of a nonexistent symbol.  We can get rid of the
64-bit versions, too, but that's more intrusive.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/2ce2ce18447d8a0b78d44a278a066b6c0af06b32.1395366931.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/vdso.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 7622a65..d1dc554 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -41,8 +41,6 @@ DECLARE_VDSO_IMAGE(vdso32_syscall);
 #endif
 DECLARE_VDSO_IMAGE(vdso32_sysenter);
 
-extern const char VDSO32_PRELINK[];
-
 /*
  * Given a pointer to the vDSO image, find the pointer to VDSO32_name
  * as that symbol is defined in the vDSO sources or linker script.
