Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab3FIQ4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:56:20 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42888 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3FIQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:56:19 -0400
Date: Sun, 9 Jun 2013 09:56:16 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] MAINTAINERS: Update email address for Anton Vorontsov
Message-ID: <20130609165616.GA22741@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old email addresses seem to gradually stop working so people are getting
bounces. This patch updates my email address.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
---

I'm about to merge this patch via battery-2.6.git tree.

 MAINTAINERS | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f35a259..9e63f91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -742,7 +742,7 @@ S:	Maintained
 F:	arch/arm/mach-highbank/
 
 ARM/CAVIUM NETWORKS CNS3XXX MACHINE SUPPORT
-M:	Anton Vorontsov <avorontsov@mvista.com>
+M:	Anton Vorontsov <anton@enomsg.org>
 S:	Maintained
 F:	arch/arm/mach-cns3xxx/
 T:	git git://git.infradead.org/users/cbou/linux-cns3xxx.git
@@ -6314,7 +6314,7 @@ F:	include/linux/timer*
 F:	kernel/*timer*
 
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
-M:	Anton Vorontsov <cbou@mail.ru>
+M:	Anton Vorontsov <anton@enomsg.org>
 M:	David Woodhouse <dwmw2@infradead.org>
 T:	git git://git.infradead.org/battery-2.6.git
 S:	Maintained
@@ -6424,7 +6424,7 @@ S:	Maintained
 F:	drivers/block/ps3vram.c
 
 PSTORE FILESYSTEM
-M:	Anton Vorontsov <cbouatmailru@gmail.com>
+M:	Anton Vorontsov <anton@enomsg.org>
 M:	Colin Cross <ccross@android.com>
 M:	Kees Cook <keescook@chromium.org>
 M:	Tony Luck <tony.luck@intel.com>
@@ -7122,7 +7122,7 @@ F:	drivers/mmc/host/sdhci.*
 F:	drivers/mmc/host/sdhci-pltfm.[ch]
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
-M:	Anton Vorontsov <avorontsov@ru.mvista.com>
+M:	Anton Vorontsov <anton@enomsg.org>
 L:	linuxppc-dev@lists.ozlabs.org
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
-- 
1.7.11.7
