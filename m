Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3KDIus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:50:48 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755Ab3KDIur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:50:47 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: iop3xx: remove unused MACH_EP80219 Kconfig parameter
Date: Mon,  4 Nov 2013 09:50:42 +0100
Message-Id: <1383555042-4135-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the MACH_EP80219 Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-iop32x/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-iop32x/Kconfig b/arch/arm/mach-iop32x/Kconfig
index 5e8c6f7dfabb..65f3500258e5 100644
--- a/arch/arm/mach-iop32x/Kconfig
+++ b/arch/arm/mach-iop32x/Kconfig
@@ -4,9 +4,6 @@ menu "IOP32x Implementation Options"
 
 comment "IOP32x Platform Types"
 
-config MACH_EP80219
-	bool
-
 config MACH_GLANTANK
 	bool "Enable support for the IO-Data GLAN Tank"
 	help
@@ -22,7 +19,6 @@ config ARCH_IQ80321
 
 config ARCH_IQ31244
 	bool "Enable support for EP80219/IQ31244"
-	select MACH_EP80219
 	help
 	  Say Y here if you want to run your kernel on the Intel EP80219
 	  evaluation kit for the Intel 80219 processor (a IOP321 variant)
-- 
1.8.1.2

