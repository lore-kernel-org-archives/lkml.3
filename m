Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3KCHZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 02:25:39 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58888 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630Ab3KCHZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 02:25:38 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: S3C24XX: remove unused Kconfig parameter
Date: Sun,  3 Nov 2013 08:25:29 +0100
Message-Id: <1383463529-3113-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the MACH_S3C2413 Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-s3c24xx/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index dba2173e70f3..9d90dd06cf2f 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -415,13 +415,6 @@ config MACH_JIVE_SHOW_BOOTLOADER
 	bool "Allow access to bootloader partitions in MTD"
 	depends on MACH_JIVE
 
-config MACH_S3C2413
-	bool
-	help
-	  Internal node for S3C2413 version of SMDK2413, so that
-	  machine_is_s3c2413() will work when MACH_SMDK2413 is
-	  selected
-
 config MACH_SMDK2412
 	bool "SMDK2412"
 	select MACH_SMDK2413
-- 
1.8.1.2

