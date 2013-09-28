Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3I1SWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:22:12 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47108 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3I1SWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:22:10 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 1/5] ARM: Kconfig: Move if ARCH_S3C64XX statement to mach-s3c64xx/Kconfig
Date: Sat, 28 Sep 2013 20:21:33 +0200
Message-Id: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other platforms have this condition checked inside their own Kconfig
files, so for consistency this patch makes it this way for mach-s3c64xx
as well.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/Kconfig              | 2 --
 arch/arm/mach-s3c64xx/Kconfig | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b766dad..dc51f8a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -995,9 +995,7 @@ source "arch/arm/mach-sti/Kconfig"
 
 source "arch/arm/mach-s3c24xx/Kconfig"
 
-if ARCH_S3C64XX
 source "arch/arm/mach-s3c64xx/Kconfig"
-endif
 
 source "arch/arm/mach-s5p64x0/Kconfig"
 
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index bd14e3a..0e23910 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -3,6 +3,8 @@
 #
 # Licensed under GPLv2
 
+if ARCH_S3C64XX
+
 # temporary until we can eliminate all drivers using it.
 config PLAT_S3C64XX
 	bool
@@ -322,3 +324,5 @@ config MACH_S3C64XX_DT
 	  board.
 	  Note: This is under development and not all peripherals can be
 	  supported with this machine file.
+
+endif
-- 
1.8.3.2

