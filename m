Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3CUVgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:36:13 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54094 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab3CUVgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:36:11 -0400
Message-ID: <1363901769.1390.159.camel@x61.thuisdomein>
Subject: [PATCH] ARM: OMAP1: remove "config MACH_OMAP_HTCWIZARD"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 22:36:09 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 21:36:09.0838 (UTC) FILETIME=[1A3DC8E0:01CE267C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MACH_OMAP_HTCWIZARD got added in v2.6.30. It has
never been used. Its entry can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/mach-omap1/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 903da8e..cdd05f2 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -55,12 +55,6 @@ config MACH_OMAP_H3
 	  TI OMAP 1710 H3 board support. Say Y here if you have such
 	  a board.
 
-config MACH_OMAP_HTCWIZARD
-	bool "HTC Wizard"
-	depends on ARCH_OMAP850
-	help
-	  HTC Wizard smartphone support (AKA QTEK 9100, ...)
-
 config MACH_HERALD
 	bool "HTC Herald"
 	depends on ARCH_OMAP850
-- 
1.7.11.7

