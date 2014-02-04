Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaBDUQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:16:10 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:47186 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaBDUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:16:03 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] m68k: Sort arch/m68k/include/asm/Kbuild
Date: Tue,  4 Feb 2014 21:15:52 +0100
Message-Id: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/Kbuild |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 7cc8c364924d..df4d46fc321b 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,4 +1,3 @@
-
 generic-y += bitsperlong.h
 generic-y += clkdev.h
 generic-y += cputime.h
@@ -6,6 +5,7 @@ generic-y += device.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
@@ -18,6 +18,7 @@ generic-y += local.h
 generic-y += mman.h
 generic-y += mutex.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -31,5 +32,3 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
-- 
1.7.9.5

