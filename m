Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3IXUVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:21:08 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1998 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab3IXUVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:21:06 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Christian Daudt" <csd@broadcom.com>
To: "Russell King" <linux@arm.linux.org.uk>,
        "Christian Daudt" <csd@broadcom.com>
cc: "Matt Porter" <matt.porter@linaro.org>,
        "Alex Elder" <alex.elder@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>
Subject: [PATCH] ARM: bcm281xx: Add ARCH Timers to config
Date: Tue, 24 Sep 2013 13:20:52 -0700
Message-ID: <1380054052-11527-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E5F2E232L888125546-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HAVE_ARM_ARCH_TIMER to Broadcom Kconfig as it is
required for some Mobile SoCs.

Signed-off-by: Christian Daudt <bcm@fixthebug.org>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Mark Hambleton <mahamble@broadcom.com>
Reviewed-by: James King <jamesk@broadcom.com>

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 69d67f7..635537b 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -13,6 +13,7 @@ config ARCH_BCM
 	select SPARSE_IRQ
 	select TICK_ONESHOT
 	select CACHE_L2X0
+	select HAVE_ARM_ARCH_TIMER
 	help
 	  This enables support for system based on Broadcom SoCs.
 	  It currently supports the 'BCM281XX' family, which includes
-- 
1.7.10.4


