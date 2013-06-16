Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3FPW1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:27:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734Ab3FPWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "PaX Team" <pageexec@freemail.hu>,
        "Kees Cook" <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.304236824@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [80/83] x86: Fix typo in kexec register clearing
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1 upstream.

Fixes a typo in register clearing code. Thanks to PaX Team for fixing
this originally, and James Troup for pointing it out.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130605184718.GA8396@www.outflux.net
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/relocate_kernel_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

