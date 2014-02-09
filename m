Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaBIPL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:11:29 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:65427 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbaBIPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:11:28 -0500
Message-ID: <1391958088.25424.17.camel@x220>
Subject: [PATCH] ARM: OMAP2+: Remove MACH_NOKIA_N800
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 16:01:28 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 15:01:29.0484 (UTC) FILETIME=[CFE744C0:01CF25A7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last caller of machine_is_nokia_n800() was removed in commit
5a87cde490e1 ("ARM: OMAP2+: Remove legacy booting support for n8x0").
That means that the Kconfig symbol MACH_NOKIA_N800 is now unused. It can
safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/mach-omap2/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 653b489..66da3f5 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -268,9 +268,6 @@ config MACH_OMAP_3430SDP
 	default y
 	select OMAP_PACKAGE_CBB
 
-config MACH_NOKIA_N800
-       bool
-
 config MACH_NOKIA_N810
        bool
 
@@ -281,7 +278,6 @@ config MACH_NOKIA_N8X0
 	bool "Nokia N800/N810"
 	depends on SOC_OMAP2420
 	default y
-	select MACH_NOKIA_N800
 	select MACH_NOKIA_N810
 	select MACH_NOKIA_N810_WIMAX
 	select OMAP_PACKAGE_ZAC
-- 
1.8.5.3

