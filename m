Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaGNPKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:10:35 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48607 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbaGNPJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:37 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 36/38] x86: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:09:04 +0200
Message-Id: <1405350546-28467-36-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/uapi/asm/Kbuild | 34 +---------------------------------
 1 file changed, 1 insertion(+), 33 deletions(-)

diff --git a/arch/x86/include/uapi/asm/Kbuild b/arch/x86/include/uapi/asm/Kbuild
index 09409c4..a8f72f4 100644
--- a/arch/x86/include/uapi/asm/Kbuild
+++ b/arch/x86/include/uapi/asm/Kbuild
@@ -4,61 +4,29 @@ include include/uapi/asm-generic/Kbuild.asm
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
-header-y += a.out.h
-header-y += auxvec.h
-header-y += bitsperlong.h
+
 header-y += boot.h
 header-y += bootparam.h
-header-y += byteorder.h
 header-y += debugreg.h
 header-y += e820.h
-header-y += errno.h
-header-y += fcntl.h
 header-y += hw_breakpoint.h
 header-y += hyperv.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
 header-y += ist.h
-header-y += kvm.h
-header-y += kvm_para.h
 header-y += ldt.h
 header-y += mce.h
-header-y += mman.h
-header-y += msgbuf.h
 header-y += msr-index.h
 header-y += msr.h
 header-y += mtrr.h
-header-y += param.h
 header-y += perf_regs.h
-header-y += poll.h
-header-y += posix_types.h
 header-y += posix_types_32.h
 header-y += posix_types_64.h
 header-y += posix_types_x32.h
 header-y += prctl.h
 header-y += processor-flags.h
 header-y += ptrace-abi.h
-header-y += ptrace.h
-header-y += resource.h
-header-y += sembuf.h
-header-y += setup.h
-header-y += shmbuf.h
-header-y += sigcontext.h
 header-y += sigcontext32.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += socket.h
-header-y += sockios.h
-header-y += stat.h
-header-y += statfs.h
 header-y += svm.h
-header-y += swab.h
-header-y += termbits.h
-header-y += termios.h
-header-y += types.h
 header-y += ucontext.h
-header-y += unistd.h
 header-y += vm86.h
 header-y += vmx.h
 header-y += vsyscall.h
-- 
1.9.3

