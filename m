Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaGNPLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:11:19 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48568 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaGNPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:34 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 31/38] score: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:59 +0200
Message-Id: <1405350546-28467-31-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/include/uapi/asm/Kbuild | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/arch/score/include/uapi/asm/Kbuild b/arch/score/include/uapi/asm/Kbuild
index 040178c..b15bf6b 100644
--- a/arch/score/include/uapi/asm/Kbuild
+++ b/arch/score/include/uapi/asm/Kbuild
@@ -1,34 +1,2 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
-
-header-y += auxvec.h
-header-y += bitsperlong.h
-header-y += byteorder.h
-header-y += errno.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += kvm_para.h
-header-y += mman.h
-header-y += msgbuf.h
-header-y += param.h
-header-y += poll.h
-header-y += posix_types.h
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
-header-y += types.h
-header-y += unistd.h
-- 
1.9.3

