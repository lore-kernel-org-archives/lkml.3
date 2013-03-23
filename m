Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab3CWPHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 11:07:18 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51259 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3CWPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 11:07:03 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dove: fix Dove cpu type from V7 to PJ4
Date: Sat, 23 Mar 2013 16:06:51 +0100
Message-Id: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will also allow to enable
iWMMXt extensions on Dove.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3bdce..4fc9bca 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -556,7 +556,7 @@ config ARCH_IXP4XX
 config ARCH_DOVE
 	bool "Marvell Dove"
 	select ARCH_REQUIRE_GPIOLIB
-	select CPU_V7
+	select CPU_PJ4
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
 	select PINCTRL
-- 
1.7.10.4

