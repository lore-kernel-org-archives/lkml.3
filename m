Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaH2Toz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:44:55 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:43613 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaH2Tov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:44:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        David Howells <dhowells@redhat.com>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/5] mn10300: Use Kbuild logic to include <asm-generic/sections.h>
Date: Fri, 29 Aug 2014 21:44:42 +0200
Message-Id: <1409341483-3451-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
References: <1409341483-3451-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/mn10300/include/asm/Kbuild     | 1 +
 arch/mn10300/include/asm/sections.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 arch/mn10300/include/asm/sections.h

diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index ecbd6676bd33..8504ac52357b 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
diff --git a/arch/mn10300/include/asm/sections.h b/arch/mn10300/include/asm/sections.h
deleted file mode 100644
index 2b8c5160388f..000000000000
--- a/arch/mn10300/include/asm/sections.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sections.h>
-- 
1.9.1

