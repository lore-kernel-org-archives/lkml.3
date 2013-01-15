Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3AOVpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:45:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20402 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3AOVpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:45:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ef-50f5cded49bb
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: [PATCH net-next 3/3] net: stmmac: add gmac autonego set for ethtool
 support
Date: Tue, 15 Jan 2013 13:45:16 -0800
Message-id: <00c101cdf369$9c366aa0$d4a33fe0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3zaZo5c0I6UdKPRnW6X3SJ/2QUtw==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ923Z78GGDydr2xxedccNotjC8Qc
	mDw+b5ILYIzisklJzcksSy3St0vgyviw8wVrwVPOipb1+Q2MMzm6GDk5JARMJG7/m8YEYYtJ
	XLi3nq2LkYtDSGAZo0T7hiusMEUXj75igUhMZ5TYsWE/O4Tzm1Hi866tYO1sAmoSzTMvA7Vz
	cIgIWEicaMsCCTML1EhcvXyDEcQWFgiTeH2xhwWkhEVAVeLzAT2QMK+ApcT1p/uYIGxBiR+T
	77FAtGpJrN95nAnClpfYvOYtM8Q9ChI7zr4GGykioCdx9jfEVmYBcYlpTUUgYRYBAYlvkw+B
	bZIQkJXYdIAZ5GAJgW52iSdPb7FAjJGUOLjiBssERrFZSDbPQrJ5FpLNsxA2LGBkWcUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kREivSOxhXNVgcYhTgYFTi4fUs/BogxJpYVlyZe4hRgoNZ
	SYQ3bCFQiDclsbIqtSg/vqg0J7X4EKMP0OETmaVEk/OBcZxXEm9obGxiZmJqYm5pam6KQ1hJ
	nJfx1JMAIYH0xJLU7NTUgtQimHFMHJxSDYzT2QOOL+S/cFKdUcOckbmlKClmp09oz/w7i73K
	zf0kGqdfZPXfPDdznsmV1aYpy6IFJux6PvdUxN2arC+JFdcOpd7bPevwBD154aZzz/zMwxSW
	9T3rX+UzQ7VwlcHj5emrYq2aNU5WLNc8y8WjK7l1s9vHIK3QXp6Nq8S+hkQs4Cg7sVre+5oS
	S3FGoqEWc1FxIgAClOyNwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd23Z78GGMw7K2txedccNotjC8Qc
	mDw+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAZqspFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z4sPMFa8FTzoqW
	9fkNjDM5uhg5OSQETCQuHn3FAmGLSVy4t56ti5GLQ0hgOqPEjg372SGc34wSn3dtZQKpYhNQ
	k2ieeRmoioNDRMBC4kRbFkiYWaBG4urlG4wgtrBAmMTriz0sICUsAqoSnw/ogYR5BSwlrj/d
	xwRhC0r8mHyPBaJVS2L9zuNMELa8xOY1b5kh7lGQ2HH2NdhIEQE9ibO/IbYyC4hLTGsqmsAo
	MAvJpFlIJs1CMmkWQscCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGR+Ex6B+OqBotD
	jAIcjEo8vJ6FXwOEWBPLiitzDzFKcDArifCGLQQK8aYkVlalFuXHF5XmpBYfYvQBenMis5Ro
	cj4wSeSVxBsam5gZWRqZWRiZmJvjEFYS52U89SRASCA9sSQ1OzW1ILUIZhwTB6dUA2OwR9fW
	21O891+fKPLUzkh9m+Pl6xbXbczmNJbONKybuKmUicF2xTKNg1IvL+2XcpZel2u1QEJir8js
	I7WK2R3LFYNinvC3TPG7+mBO56q77bstdvuVdqkeSrU/ff/M5Ktid1+fMY+2npbQ2K1dJqHh
	t3rpeoat1qkpE5PMTfQD3wQEXJVrPaXEUpyRaKjFXFScCACUz0oc8QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds gmac auto-negotiation setting for ethtool.
If interface is SGMII, TBI or RTBI, gmac's auto-negotiation
enable bit is need to set.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1372ce2..457c1a4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -335,6 +335,7 @@ stmmac_set_pauseparam(struct net_device *netdev,
 	struct phy_device *phy = priv->phydev;
 	int new_pause = FLOW_OFF;
 	int ret = 0;
+	int interface = priv->plat->interface;
 
 	spin_lock(&priv->lock);
 
@@ -348,6 +349,10 @@ stmmac_set_pauseparam(struct net_device *netdev,
 
 	if (phy->autoneg) {
 		if (netif_running(netdev))
+			if (interface == PHY_INTERFACE_MODE_SGMII ||
+			    interface == PHY_INTERFACE_MODE_TBI ||
+			    interface == PHY_INTERFACE_MODE_RTBI)
+				priv->hw->mac->set_autoneg(priv->ioaddr);
 			ret = phy_start_aneg(phy);
 	} else
 		priv->hw->mac->flow_ctrl(priv->ioaddr, phy->duplex,
-- 
1.7.10.4


