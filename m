Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3CFJwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:52:40 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50007 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab3CFJwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:52:38 -0500
Message-ID: <1362563553.16460.166.camel@x61.thuisdomein>
Subject: [PATCH] ARM: mach-bcm: drop "select GENERIC_TIME"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Mar 2013 10:52:33 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2013 09:52:33.0789 (UTC) FILETIME=[5351AAD0:01CE1A50]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol GENERIC_TIME was removed from the kernel in v2.6.36,
with commit 592913ecb87a9e06f98ddb55b298f1a66bf94c6b ("time: Kill off
CONFIG_GENERIC_TIME"). Somehow this select statement still popped up
recently. It's a nop so we can drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

 arch/arm/mach-bcm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index bf02471..be4a0a1 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -7,7 +7,6 @@ config ARCH_BCM
 	select ARM_GIC
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	select GPIO_BCM
 	select SPARSE_IRQ
 	select TICK_ONESHOT
-- 
1.7.11.7

