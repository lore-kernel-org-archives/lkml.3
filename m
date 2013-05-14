Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3ENJet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:34:49 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64876 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637Ab3ENJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:34:48 -0400
Message-ID: <1368524085.1350.102.camel@x61.thuisdomein>
Subject: [PATCH] ARM: mach-bcm: drop "select GPIO_BCM"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Christian Daudt <csd@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 May 2013 11:34:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2013 09:34:46.0203 (UTC) FILETIME=[457DB8B0:01CE5086]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A select statement for the Kconfig symbol GPIO_BCM was added in v3.8.
But there's no symbol with that name. It's a nop so we can drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Patch assumes that https://lkml.org/lkml/2013/3/6/182 ("ARM:
mach-bcm: drop "select GENERIC_TIME""), which got a Reviewed-by tag from
Christian, was applied first.

 arch/arm/mach-bcm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 764273e..322620d 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -8,7 +8,6 @@ config ARCH_BCM
 	select CPU_V7
 	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
-	select GPIO_BCM
 	select SPARSE_IRQ
 	select TICK_ONESHOT
 	help
-- 
1.7.11.7

