Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3ETLU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:20:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3ETKwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 028/115] ARM: u300: fix ages old copy/paste bug
Date: Mon, 20 May 2013 11:50:28 +0100
Message-Id: <1369047116-9378-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 0259d9eb30d003af305626db2d8332805696e60d upstream.

The UART1 is on the fast AHB bridge, not on the slow bus.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-u300/include/mach/u300-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-u300/include/mach/u300-regs.h b/arch/arm/mach-u300/include/mach/u300-regs.h
index 65f87c5..cacb2af 100644
--- a/arch/arm/mach-u300/include/mach/u300-regs.h
+++ b/arch/arm/mach-u300/include/mach/u300-regs.h
@@ -101,7 +101,7 @@
 
 #ifdef CONFIG_MACH_U300_BS335
 /* Fast UART1 on U335 only */
-#define U300_UART1_BASE			(U300_SLOW_PER_PHYS_BASE+0x7000)
+#define U300_UART1_BASE			(U300_FAST_PER_PHYS_BASE+0x7000)
 #endif
 
 /*
-- 
1.8.1.2

