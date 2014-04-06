Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaDFKMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 06:12:46 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62826 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbaDFKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 06:12:44 -0400
Message-ID: <1396779162.30640.14.camel@x220>
Subject: [PATCH] ARM: SAMSUNG: remove two unused S3C boot options
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 12:12:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 10:12:42.0907 (UTC) FILETIME=[BF976EB0:01CF5180]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 19a964644f1e ("ARM: SAMSUNG: remove all custom uncompress.h")
removed the only users of S3C_BOOT_ERROR_RESET and
S3C_BOOT_UART_FORCE_FIFO. Remove their Kconfig entries too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/plat-samsung/Kconfig | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index b57e922f1614..f615c0e7b226 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -40,20 +40,6 @@ if PLAT_SAMSUNG
 
 comment "Boot options"
 
-config S3C_BOOT_ERROR_RESET
-	bool "S3C Reboot on decompression error"
-	help
-	  Say y here to use the watchdog to reset the system if the
-	  kernel decompressor detects an error during decompression.
-
-config S3C_BOOT_UART_FORCE_FIFO
-       bool "Force UART FIFO on during boot process"
-       default y
-       help
-         Say Y here to force the UART FIFOs on during the kernel
-	 uncompressor
-
-
 config S3C_LOWLEVEL_UART_PORT
 	int "S3C UART to use for low-level messages"
 	default 0
-- 
1.9.0

