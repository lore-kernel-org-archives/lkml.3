Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab3GCTAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:00:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab3GCTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:14 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=GUrRsmxgzQAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mdN7iuTps5sA:10 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=3VMw-uIDAAAA:8 a=QyXUC8HyAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=zv9_9hqRWm8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184108.453852750@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [131/141] x86: Fix typo in kexec register clearing
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0131-x86-Fix-typo-in-kexec-register-clearing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1 ]

Fixes a typo in register clearing code. Thanks to PaX Team for fixing
this originally, and James Troup for pointing it out.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130605184718.GA8396@www.outflux.net
Cc: <stable@vger.kernel.org> v2.6.30+
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/relocate_kernel_64.S |    2 +-
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
1.7.10.4


