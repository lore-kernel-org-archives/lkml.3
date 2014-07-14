Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaGNPLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:11:30 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48552 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbaGNPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:34 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 29/38] powerpc: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:57 +0200
Message-Id: <1405350546-28467-29-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/uapi/asm/Kbuild | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/Kbuild b/arch/powerpc/include/uapi/asm/Kbuild
index 7a3f795..74d14f3 100644
--- a/arch/powerpc/include/uapi/asm/Kbuild
+++ b/arch/powerpc/include/uapi/asm/Kbuild
@@ -1,46 +1,14 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += auxvec.h
-header-y += bitsperlong.h
 header-y += bootx.h
-header-y += byteorder.h
 header-y += cputable.h
 header-y += elf.h
 header-y += epapr_hcalls.h
-header-y += errno.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += kvm.h
-header-y += kvm_para.h
-header-y += mman.h
-header-y += msgbuf.h
 header-y += nvram.h
-header-y += param.h
 header-y += perf_event.h
-header-y += poll.h
-header-y += posix_types.h
 header-y += ps3fb.h
-header-y += ptrace.h
-header-y += resource.h
 header-y += seccomp.h
-header-y += sembuf.h
-header-y += setup.h
-header-y += shmbuf.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += socket.h
-header-y += sockios.h
 header-y += spu_info.h
-header-y += stat.h
-header-y += statfs.h
-header-y += swab.h
-header-y += termbits.h
-header-y += termios.h
 header-y += tm.h
-header-y += types.h
 header-y += ucontext.h
-header-y += unistd.h
-- 
1.9.3

