Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaIOODK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:03:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753073AbaIOOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:02:01 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/9] net: pxa168_eth: allow Berlin SoCs to use the pxa168_eth driver
Date: Mon, 15 Sep 2014 16:01:51 +0200
Message-Id: <1410789713-15341-8-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berlin SoCs have an Ethernet controller compatible with the pxa168.
Allow these SoCs to use the pxa168_eth driver.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/net/ethernet/marvell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index 1b4fc7c639e6..48b9466d1781 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -64,7 +64,7 @@ config MVPP2
 
 config PXA168_ETH
 	tristate "Marvell pxa168 ethernet support"
-	depends on CPU_PXA168
+	depends on CPU_PXA168 || ARCH_BERLIN
 	select PHYLIB
 	---help---
 	  This driver supports the pxa168 Ethernet ports.
-- 
1.9.1

