Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3HBEQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:16:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30218 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3HBEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:16:18 -0400
X-Spam-Score: -100.8
Message-ID: <51FB3251.5090603@asianux.com>
Date: Fri, 02 Aug 2013 12:15:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Arnd Bergmann <arnd@arndb.de>, "dhowells@redhat.com" <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, davej@redhat.com,
        David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: include: asm: add "vga.h" in Kbuild
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add "vga.h" in Kbuild, or can not pass compiling, the related
error is:

    CC      drivers/tty/tty_io.o
  In file included from include/linux/selection.h:11:0,
                   from drivers/tty/tty_io.c:103:
  include/linux/vt_buffer.h:18:21: fatal error: asm/vga.h: No such file or directory
   #include <asm/vga.h>
                       ^

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 8ada3cf..f10523e 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -5,4 +5,5 @@ generic-y += linkage.h
 generic-y += mmu.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += vga.h
 generic-y += xor.h
-- 
1.7.7.6
