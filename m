Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3EJOfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:35:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57154 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab3EJOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Arnd Bergmann" <arnd@arndb.de>,
        "Olof Johansson" <olof@lixom.net>,
        "Linus Walleij" <linus.walleij@linaro.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.793237080@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [064/118] ARM: u300: fix ages old copy/paste bug
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 0259d9eb30d003af305626db2d8332805696e60d upstream.

The UART1 is on the fast AHB bridge, not on the slow bus.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-u300/include/mach/u300-regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-u300/include/mach/u300-regs.h
+++ b/arch/arm/mach-u300/include/mach/u300-regs.h
@@ -102,7 +102,7 @@
 
 #ifdef CONFIG_MACH_U300_BS335
 /* Fast UART1 on U335 only */
-#define U300_UART1_BASE			(U300_SLOW_PER_PHYS_BASE+0x7000)
+#define U300_UART1_BASE			(U300_FAST_PER_PHYS_BASE+0x7000)
 #endif
 
 /*

