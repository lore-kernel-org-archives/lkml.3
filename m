Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3AJXzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:55:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28785 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3AJXyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:54:25 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-70-50ef54b1a5c4
From: Byungho An <bh74.an@samsung.com>
To: "'David Miller'" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, jeffrey.t.kirsher@intel.com,
        kgene.kim@samsung.com
References: <000601cdedf8$5d39bdf0$17ad39d0$@samsung.com>
 <20130110.000208.2040524620441942742.davem@davemloft.net>
In-reply-to: <20130110.000208.2040524620441942742.davem@davemloft.net>
Subject: RE: [PATCH v2 3/3] net: stmmac: add gmac autonego set for ethtool
 support
Date: Thu, 10 Jan 2013 15:54:24 -0800
Message-id: <003d01cdef8d$d25b2bf0$771183d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQBXgvEqF9EyCS0rCZdYUH4PnkGcJgJp5FZsmxzGc6A=
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ92NIe8DDI6fFrG4vGsOm8WxBWIO
	TB6fN8kFMEZx2aSk5mSWpRbp2yVwZXz6O4ut4CVnxYK+HywNjPM5uhg5OCQETCRez9TvYuQE
	MsUkLtxbz9bFyMUhJLCMUaL55DUWiISJRMul5VCJRYwS/e+vs0A4vxklvn5uZQKpYhNQk2ie
	eZkNxBYR0JA4+beRCaSIWaCNUeJX3wR2kISQQKnEl1WTWEFsTgE3iSP33oKtEBYIkbj3pQ2s
	mUVAVWJJXy/YUF4BS4mTB7axQ9iCEj8m3wOrZxbQkli/8zgThC0vsXnNW2aIUxUkdpx9zQhx
	hJXEr54VzCBvMguIS0xrKoIYLyDxbfIhFojvZSU2HWAGOVNCYBW7xKXVJ5kgxkhKHFxxg2UC
	o8QsJJtnIdk8C8nmWQgbFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIiTCpHYwrGywO
	MQpwMCrx8FZqvg8QYk0sK67MPcQowcGsJMLbsuBdgBBvSmJlVWpRfnxRaU5q8SFGH6DDJzJL
	iSbnA6M/ryTe0NjYxMzE1MTc0tTcFIewkjgv46knAUIC6YklqdmpqQWpRTDjmDg4pRoY1xfu
	y9/x9Ezs2idJhXenubqxfftw+vSEeZ2hVbeS/c65NzhvPTODf6GOpmayyi7Vzz6XyjTq727Y
	/uHEq2vnzCaxHgy7zdNr8F1my83fje2zTGbZGKrHxu1luX/+kO+nr7fS5q689DPLNUFA6qOF
	+6kMXbaUm4s5Z5cdWf3T6Po1Y7nji0vf31FiKc5INNRiLipOBABLqW2/3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd2NIe8DDJacE7C4vGsOm8WxBWIO
	TB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAE1WUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZ8+juLreAlZ8WC
	vh8sDYzzOboYOTkkBEwkWi4tZ4OwxSQu3FsPZHNxCAksYpTof3+dBcL5zSjx9XMrE0gVm4Ca
	RPPMy2AdIgIaEif/NjKBFDELtDFK/OqbwA6SEBIolfiyahIriM0p4CZx5N5bFhBbWCBE4t6X
	NrBmFgFViSV9vWBDeQUsJU4e2MYOYQtK/Jh8D6yeWUBLYv3O40wQtrzE5jVvmSFOVZDYcfY1
	I8QRVhK/elYAxTmAasQlpjUVTWAUmoVk0iwkk2YhmTQLoWMBI8sqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjOAIfia1g3Flg8UhRgEORiUe3krN9wFCrIllxZW5hxglOJiVRHhbFrwLEOJN
	SaysSi3Kjy8qzUktPsToA/TnRGYp0eR8YHLJK4k3NDYxM7I0MrMwMjE3xyGsJM7LeOpJgJBA
	emJJanZqakFqEcw4Jg5OqQbGjANfSphf7WO6OemRePHbmaxbddi2n/Pf1vbe6onahLOOt+Te
	tx25vyDu6TwuXunm6ROeT2gVt1/O8+yAjeBisysvjsz5wHW7+Kppmkmb3qJVdVzuLvb7N+su
	XXr5h/GMfIUtC9bma3i+e2muHH/wvJhpqZLXcTPb2LbKuXNjLx+zfNepGrH8iRJLcUaioRZz
	UXEiAK58lcINAwAA
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
+			if((interface == PHY_INTERFACE_MODE_SGMII) ||
+			   (interface == PHY_INTERFACE_MODE_TBI) ||
+			   (interface == PHY_INTERFACE_MODE_RTBI)) 
+				priv->hw->mac->set_autoneg(priv->ioaddr);
 			ret = phy_start_aneg(phy);
 	} else
 		priv->hw->mac->flow_ctrl(priv->ioaddr, phy->duplex,
-- 
1.7.10.4


