Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbbAQGRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 01:17:00 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53192 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbAQGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 01:16:58 -0500
From: tolga ceylan <tolga.ceylan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ganesan Ramalingam <ganesanr@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Iulia Manda <iulia.manda21@gmail.com>, Toby Smith <toby@tismith.id.au>,
        devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, tolga ceylan <tolga.ceylan@gmail.com>
Subject: [PATCH] Staging: NetLogic: Coding style correction
Date: Fri, 16 Jan 2015 22:16:13 -0800
Message-Id: <1421475373-6328-1-git-send-email-tolga.ceylan@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misspelled comment corrected

Signed-off-by: tolga ceylan <tolga.ceylan@gmail.com>
---
 drivers/staging/netlogic/xlr_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index 5ecb3e6..e8aae09 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -788,7 +788,7 @@ void xlr_set_gmac_speed(struct xlr_net_priv *priv)
 			xlr_nae_wreg(priv->base_addr, R_MAC_CONFIG_2, 0x7117);
 			priv->phy_speed = speed;
 		}
-		/* Set SGMII speed in Interface controll reg */
+		/* Set SGMII speed in Interface control reg */
 		if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 			if (speed == SPEED_10)
 				xlr_nae_wreg(priv->base_addr,
-- 
1.9.1

