Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaAJH4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:56:32 -0500
Received: from [207.46.163.26] ([207.46.163.26]:35829 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbaAJH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:56:30 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21a7h1fc6hzdchz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <davem@davemloft.net>, <jg1.han@samsung.com>, <mugunthanvnm@ti.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <Shaohui.Xie@freescale.com>, Andy Fleming <afleming@gmail.com>
Subject: [PATCH 2/6] [v6] phylib: introduce PHY_INTERFACE_MODE_XGMII for 10G PHY
Date: Fri, 10 Jan 2014 14:26:46 +0800
Message-ID: <1389335206-32511-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming <afleming@gmail.com>

Signed-off-by: Andy Fleming <afleming@gmail.com>
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
changes for v6:
rebased on top of 'net-next' tree. commit id 11b57f90257c1.

 drivers/of/of_net.c | 1 +
 include/linux/phy.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 8f9be2e..a208a45 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -30,6 +30,7 @@ static const char *phy_modes[] = {
 	[PHY_INTERFACE_MODE_RGMII_TXID] = "rgmii-txid",
 	[PHY_INTERFACE_MODE_RTBI]	= "rtbi",
 	[PHY_INTERFACE_MODE_SMII]	= "smii",
+	[PHY_INTERFACE_MODE_XGMII]	= "xgmii",
 };
 
 /**
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3eda43c..a9685b1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -73,6 +73,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_RGMII_TXID,
 	PHY_INTERFACE_MODE_RTBI,
 	PHY_INTERFACE_MODE_SMII,
+	PHY_INTERFACE_MODE_XGMII,
 } phy_interface_t;
 
 
-- 
1.8.4.1


