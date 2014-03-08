Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaCHJ3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:29:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42980 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaCHJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:45 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/28] phy: mvebu-sata: prepare new Dove DT Kconfig variable
Date: Sat, 8 Mar 2014 14:59:09 +0530
Message-ID: <1394270969-11851-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
DT-only MACH_DOVE Kconfig.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index e677ee0..dc1756c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -27,7 +27,7 @@ config PHY_EXYNOS_MIPI_VIDEO
 
 config PHY_MVEBU_SATA
 	def_bool y
-	depends on ARCH_KIRKWOOD || ARCH_DOVE
+	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
 	depends on OF
 	select GENERIC_PHY
 
-- 
1.7.9.5

