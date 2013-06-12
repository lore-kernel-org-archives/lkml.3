Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3FLWXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:23:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3FLWXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:23:00 -0400
Date: Wed, 12 Jun 2013 15:21:39 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, pageexec@freemail.hu, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, pageexec@freemail.hu, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130605184718.GA8396@www.outflux.net>
References: <20130605184718.GA8396@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix typo in kexec register clearing
Git-Commit-ID: c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Jun 2013 15:21:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1
Gitweb:     http://git.kernel.org/tip/c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Wed, 5 Jun 2013 11:47:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 12 Jun 2013 15:16:18 -0700

x86: Fix typo in kexec register clearing

Fixes a typo in register clearing code. Thanks to PaX Team for fixing
this originally, and James Troup for pointing it out.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130605184718.GA8396@www.outflux.net
Cc: <stable@vger.kernel.org> v2.6.30+
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/relocate_kernel_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 7a6f3b3..f2bb9c9 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -160,7 +160,7 @@ identity_mapped:
 	xorq    %rbp, %rbp
 	xorq	%r8,  %r8
 	xorq	%r9,  %r9
-	xorq	%r10, %r9
+	xorq	%r10, %r10
 	xorq	%r11, %r11
 	xorq	%r12, %r12
 	xorq	%r13, %r13
