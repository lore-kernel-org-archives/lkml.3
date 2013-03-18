Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3CVNm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:42:27 -0400
Received: from swissweb.swissdisk.com ([174.129.12.238]:52787 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3CVNjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:39:37 -0400
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 09:39:35 EDT
From: Ben Collins <ben.c@servergy.com>
Date: Mon, 18 Mar 2013 19:53:42 -0400
Subject: [PATCH] phy: Add XGMII phy interface type
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Message-Id: <E1UJ1fR-0004hy-AI@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used by systems based on certain Freescale SoCs (specifically the
Servergy CTS-1000 system).

Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: netdev@vger.kernel.org
---
 include/linux/phy.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 33999ad..5a94ec7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -64,6 +64,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_RGMII_TXID,
 	PHY_INTERFACE_MODE_RTBI,
 	PHY_INTERFACE_MODE_SMII,
+	PHY_INTERFACE_MODE_XGMII,
 } phy_interface_t;
 
 
-- 
1.8.1.2

