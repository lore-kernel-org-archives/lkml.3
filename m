Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3EGJ4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:56:54 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:39468 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3EGJ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:56:53 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] cris: Switch to asm-generic/linkage.h
Date: Tue,  7 May 2013 11:56:51 +0200
Message-Id: <1367920611-18586-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/include/asm/Kbuild    |    1 +
 arch/cris/include/asm/linkage.h |    6 ------
 2 files changed, 1 insertions(+), 6 deletions(-)
 delete mode 100644 arch/cris/include/asm/linkage.h

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 7478488..1e7dfad 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -6,5 +6,6 @@ header-y += arch-v32/
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
+generic-y += linkage.h
 generic-y += module.h
 generic-y += trace_clock.h
diff --git a/arch/cris/include/asm/linkage.h b/arch/cris/include/asm/linkage.h
deleted file mode 100644
index 291c2d0..0000000
--- a/arch/cris/include/asm/linkage.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_LINKAGE_H
-#define __ASM_LINKAGE_H
-
-/* Nothing to see here... */
-
-#endif
-- 
1.7.0.4

