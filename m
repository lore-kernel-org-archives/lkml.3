Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3CQNrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 09:47:14 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55802 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab3CQNrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 09:47:11 -0400
From: Alexandre Courbot <gnurou@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 2/3] m68k: coldfire: use gpiolib
Date: Sun, 17 Mar 2013 22:42:02 +0900
Message-Id: <1363527723-32713-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1363527723-32713-1-git-send-email-acourbot@nvidia.com>
References: <1363527723-32713-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force use of gpiolib for Coldfire, as a step towards the deprecation of
GENERIC_GPIO.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/m68k/Kconfig.cpu | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index b1cfff8..d266787 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -22,8 +22,7 @@ config M68KCLASSIC
 
 config COLDFIRE
 	bool "Coldfire CPU family support"
-	select GENERIC_GPIO
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
 	select CPU_HAS_NO_MULDIV64
-- 
1.8.2

