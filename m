Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaGNPKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:10:55 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48581 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbaGNPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:35 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 33/38] sparc: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:09:01 +0200
Message-Id: <1405350546-28467-33-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/include/uapi/asm/Kbuild | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/Kbuild b/arch/sparc/include/uapi/asm/Kbuild
index b5843ee..9dcd2d4 100644
--- a/arch/sparc/include/uapi/asm/Kbuild
+++ b/arch/sparc/include/uapi/asm/Kbuild
@@ -5,46 +5,16 @@ include include/uapi/asm-generic/Kbuild.asm
 
 header-y += apc.h
 header-y += asi.h
-header-y += auxvec.h
-header-y += bitsperlong.h
-header-y += byteorder.h
 header-y += display7seg.h
 header-y += envctrl.h
-header-y += errno.h
 header-y += fbio.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
 header-y += jsflash.h
-header-y += kvm_para.h
-header-y += mman.h
-header-y += msgbuf.h
 header-y += openpromio.h
-header-y += param.h
 header-y += perfctr.h
-header-y += poll.h
-header-y += posix_types.h
 header-y += psr.h
 header-y += psrcompat.h
 header-y += pstate.h
-header-y += ptrace.h
-header-y += resource.h
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
 header-y += traps.h
 header-y += uctx.h
-header-y += unistd.h
 header-y += utrap.h
 header-y += watchdog.h
-- 
1.9.3

