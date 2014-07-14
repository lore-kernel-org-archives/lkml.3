Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbaGNPQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:16:40 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48433 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaGNPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:27 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 20/38] ia64: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:48 +0200
Message-Id: <1405350546-28467-20-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/include/uapi/asm/Kbuild | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/arch/ia64/include/uapi/asm/Kbuild b/arch/ia64/include/uapi/asm/Kbuild
index 1b3f5eb..f05bc97 100644
--- a/arch/ia64/include/uapi/asm/Kbuild
+++ b/arch/ia64/include/uapi/asm/Kbuild
@@ -1,50 +1,20 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-generic-y += kvm_para.h
 
-header-y += auxvec.h
-header-y += bitsperlong.h
 header-y += break.h
-header-y += byteorder.h
 header-y += cmpxchg.h
-header-y += errno.h
-header-y += fcntl.h
 header-y += fpu.h
 header-y += gcc_intrin.h
 header-y += ia64regs.h
 header-y += intel_intrin.h
 header-y += intrinsics.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += kvm.h
-header-y += kvm_para.h
-header-y += mman.h
-header-y += msgbuf.h
-header-y += param.h
 header-y += perfmon.h
 header-y += perfmon_default_smpl.h
-header-y += poll.h
-header-y += posix_types.h
-header-y += ptrace.h
 header-y += ptrace_offsets.h
-header-y += resource.h
 header-y += rse.h
-header-y += sembuf.h
-header-y += setup.h
-header-y += shmbuf.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += socket.h
-header-y += sockios.h
-header-y += stat.h
-header-y += statfs.h
-header-y += swab.h
-header-y += termbits.h
-header-y += termios.h
-header-y += types.h
 header-y += ucontext.h
-header-y += unistd.h
 header-y += ustack.h
+
+# Wrappers from asm-generic
+generic-y += kvm_para.h
-- 
1.9.3

