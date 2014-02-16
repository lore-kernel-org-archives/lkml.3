Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaBPR0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:26:05 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61848 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbaBPR0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:26:04 -0500
Message-ID: <1392571560.28866.16.camel@x220>
Subject: [PATCH] arm: omap3: cm-t35: remove MACH_CM_T3730
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 18:26:00 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 17:26:01.0546 (UTC) FILETIME=[29BF2AA0:01CF2B3C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MACH_CM_T3730 was added in v3.1. It has never been
used. Setting it has no effect. There are no calls for
machine_is_cm_t3730(). This symbol can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only with "git grep".

 arch/arm/mach-omap2/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 66da3f5..7d4934e 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -292,7 +292,6 @@ config MACH_CM_T35
 	bool "CompuLab CM-T35/CM-T3730 modules"
 	depends on ARCH_OMAP3
 	default y
-	select MACH_CM_T3730
 	select OMAP_PACKAGE_CUS
 
 config MACH_CM_T3517
@@ -301,9 +300,6 @@ config MACH_CM_T3517
 	default y
 	select OMAP_PACKAGE_CBB
 
-config MACH_CM_T3730
-       bool
-
 config MACH_SBC3530
 	bool "OMAP3 SBC STALKER board"
 	depends on ARCH_OMAP3
-- 
1.8.5.3

