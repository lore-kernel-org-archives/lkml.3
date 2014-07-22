Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaGVLAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:00:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbaGVK5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:38 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/28] phy: Remove ARCH_KIRKWOOD dependency
Date: Tue, 22 Jul 2014 16:26:41 +0530
Message-ID: <1406026611-30493-19-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

mach-kirkwood has been removed, now that kirkwood lives in mach-mvebu.
Depend on MACH_KIRKWOOD, which will be set when these SoCs are built
as part of mach-mvebv.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 6911152..261ad18 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -27,7 +27,7 @@ config PHY_EXYNOS_MIPI_VIDEO
 
 config PHY_MVEBU_SATA
 	def_bool y
-	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE || MACH_KIRKWOOD
+	depends on ARCH_DOVE || MACH_DOVE || MACH_KIRKWOOD
 	depends on OF
 	select GENERIC_PHY
 
-- 
1.7.9.5

