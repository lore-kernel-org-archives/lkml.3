Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbbA2PNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:13:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45490 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbbA2PNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:13:21 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux@arm.linux.org.uk>, <ssantosh@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] ARM: keystone: defconfig: add DEVTMPFS option by default.
Date: Thu, 29 Jan 2015 10:12:48 -0500
Message-ID: <1422544368-15861-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using network driver on keystone and nfs rootfs is used following
error displayed and device halts.

Missing devtmpfs, which is required for udev to run
Halting...

Add the DEVTMPFS option by default to fix this

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/configs/keystone_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index 4446621..f9ebe61 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -209,3 +209,4 @@ CONFIG_KEYSTONE_IRQ=y
 CONFIG_GPIO_SYSCON=y
 CONFIG_TI_DAVINCI_MDIO=y
 CONFIG_MARVELL_PHY=y
+CONFIG_DEVTMPFS=y
-- 
1.7.9.5

