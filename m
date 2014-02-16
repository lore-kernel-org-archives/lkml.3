Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaBPReo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:34:44 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:63794 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbaBPRem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:34:42 -0500
Message-ID: <1392572080.28866.19.camel@x220>
Subject: [PATCH] arm: msm: remove MACH_MSM7X30_SURF
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 18:34:40 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 17:34:40.0581 (UTC) FILETIME=[5F1D9F50:01CF2B3D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MACH_MSM7X30_SURF was added in v2.6.35. It has never
been used. Setting it has no effect. There are no calls for
machine_is_mach_msm7x30(). This symbol can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only with "git grep".

 arch/arm/mach-msm/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 9625cf3..dab941a 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -62,7 +62,6 @@ config ARCH_MSM7X30
 	select ARCH_MSM_SCORPION
 	select CPU_V7
 	select GPIO_MSM_V1
-	select MACH_MSM7X30_SURF # if !
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select MSM_SMD
@@ -115,12 +114,6 @@ config MACH_TROUT
 	help
 	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
 
-config MACH_MSM7X30_SURF
-	depends on ARCH_MSM7X30
-	bool "MSM7x30 SURF"
-	help
-	  Support for the Qualcomm MSM7x30 SURF eval board.
-
 config MACH_QSD8X50_SURF
 	depends on ARCH_QSD8X50
 	bool "QSD8x50 SURF"
-- 
1.8.5.3

