Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab3FRQWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:22:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933128Ab3FRQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:00 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 31/48] x86: Fix typo in kexec register clearing
Date: Tue, 18 Jun 2013 09:17:57 -0700
Message-Id: <20130618161730.404067234@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1 upstream.

Fixes a typo in register clearing code. Thanks to PaX Team for fixing
this originally, and James Troup for pointing it out.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130605184718.GA8396@www.outflux.net
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


