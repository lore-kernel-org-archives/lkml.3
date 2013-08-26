Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3HZKR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:17:27 -0400
Received: from intranet.asianux.com ([58.214.24.6]:10827 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3HZKRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:17:25 -0400
X-Spam-Score: -101.0
Message-ID: <521B2AF7.6070806@asianux.com>
Date: Mon, 26 Aug 2013 18:16:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>, Arnd Bergmann <arnd@arndb.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, davej@redhat.com,
        David Sharp <dhsharp@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: include: asm: Kbuild: add gpio.h for pass compiling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add default "gpio.h" for h8300, or can not pass compiling.

The related error (allmodconfig for h8300):

  arch/h8300/kernel/h8300_ksyms.c:17:22: fatal error: asm/gpio.h: No such file or directory
   #include <asm/gpio.h>
                        ^

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 8ada3cf..4c627aa 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += gpio.h
 generic-y += linkage.h
 generic-y += mmu.h
 generic-y += module.h
-- 
1.7.7.6
