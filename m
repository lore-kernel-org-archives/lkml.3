Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab3EFVSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:18:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab3EFUp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:45:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [ 005/115] ARM: u300: fix ages old copy/paste bug
Date: Mon,  6 May 2013 13:44:01 -0700
Message-Id: <20130506203056.142147647@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 0259d9eb30d003af305626db2d8332805696e60d upstream.

The UART1 is on the fast AHB bridge, not on the slow bus.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-u300/include/mach/u300-regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-u300/include/mach/u300-regs.h
+++ b/arch/arm/mach-u300/include/mach/u300-regs.h
@@ -95,7 +95,7 @@
 #define U300_SPI_BASE			(U300_FAST_PER_PHYS_BASE+0x6000)
 
 /* Fast UART1 on U335 only */
-#define U300_UART1_BASE			(U300_SLOW_PER_PHYS_BASE+0x7000)
+#define U300_UART1_BASE			(U300_FAST_PER_PHYS_BASE+0x7000)
 
 /*
  * SLOW peripherals


