Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab3FRLuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:50:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56274 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3FRLpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 81/93] x86: Fix typo in kexec register clearing
Date: Tue, 18 Jun 2013 12:43:29 +0100
Message-Id: <1371555821-12820-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1 upstream.

Fixes a typo in register clearing code. Thanks to PaX Team for fixing
this originally, and James Troup for pointing it out.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130605184718.GA8396@www.outflux.net
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
-- 
1.8.1.2

