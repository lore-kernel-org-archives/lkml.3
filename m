Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaGNPOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:14:31 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48454 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbaGNPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:28 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 22/38] m68k: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:50 +0200
Message-Id: <1405350546-28467-22-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/uapi/asm/Kbuild | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/arch/m68k/include/uapi/asm/Kbuild b/arch/m68k/include/uapi/asm/Kbuild
index 6a2d257..e09f91d 100644
--- a/arch/m68k/include/uapi/asm/Kbuild
+++ b/arch/m68k/include/uapi/asm/Kbuild
@@ -1,16 +1,6 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-generic-y += auxvec.h
-generic-y += msgbuf.h
-generic-y += sembuf.h
-generic-y += shmbuf.h
-generic-y += socket.h
-generic-y += sockios.h
-generic-y += termbits.h
-generic-y += termios.h
-
-header-y += a.out.h
 header-y += bootinfo.h
 header-y += bootinfo-amiga.h
 header-y += bootinfo-apollo.h
@@ -19,17 +9,14 @@ header-y += bootinfo-hp300.h
 header-y += bootinfo-mac.h
 header-y += bootinfo-q40.h
 header-y += bootinfo-vme.h
-header-y += byteorder.h
 header-y += cachectl.h
-header-y += fcntl.h
-header-y += ioctls.h
-header-y += param.h
-header-y += poll.h
-header-y += posix_types.h
-header-y += ptrace.h
-header-y += setup.h
-header-y += sigcontext.h
-header-y += signal.h
-header-y += stat.h
-header-y += swab.h
-header-y += unistd.h
+
+# Wrappers from asm-generic
+generic-y += auxvec.h
+generic-y += msgbuf.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += termbits.h
+generic-y += termios.h
-- 
1.9.3

