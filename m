Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3AJXy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:54:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28785 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3AJXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:54:24 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-65-50ef54afc07f
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: RE: [PATCH 1/3] net: stmmac: add gmac autonet set for SGMII, TBI,
 and RTBI
Date: Thu, 10 Jan 2013 15:54:20 -0800
Message-id: <003c01cdef8d$d12e92d0$738bb870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3vjbcarbGGNk02QOSR1VCtniPeow==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ931Ie8DDFr7pC0u75rDZnFsgZgD
	k8fnTXIBjFFcNimpOZllqUX6dglcGTO/H2Aq6JOs6F15mKmBcbpoFyMnh4SAicSdvY9YIWwx
	iQv31rOB2EICyxglXlzIgKlp2P8EqIYLKL6IUeL0zrcsEM5vRomdL3Yxg1SxCahJNM+8DNTN
	wSEiYCFxoi0LJMwsUCNx9fINRhBbWCBU4vCsHiYQm0VAVWL2vA6wZbwClhLfHm2BsgUlfky+
	xwLRqyWxfudxJghbXmLzmrfMEAcpSOw4+xpspoiAnsSjtzsZQdYyC4hLTGsqghgvIPFt8iEW
	kLCEgKzEpgPMIBdLCPSzS+x5dgBqjKTEwRU3WCYwis1CsnkWks2zkGyehbBhASPLKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYyQaJHawbiyweIQowAHoxIPb6Xm+wAh1sSy4srcQ4wSHMxK
	IrwtC94FCPGmJFZWpRblxxeV5qQWH2L0ATp8IrOUaHI+MJLzSuINjY1NzExMTcwtTc1NcQgr
	ifMynnoSICSQnliSmp2aWpBaBDOOiYNTqoGxSXHZpP7+n/a1t7zFL/sdun78hmvLQ00focaA
	V9ZPZ3IULezIXxPE08IlZf5wW4Wc5XmXxTpXNb+snHWivKRyVXhyfr1MNVO96pu8+MKU/Xsc
	DHI2xn5bxVj8ZaL5PSPfht+3rvBwlz1d11qc0M7Tb6g+9f6drb6ft1Ta7tlQLDwjf/Pb3SJK
	LMUZiYZazEXFiQCGuuvuwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAd31Ie8DDO5uFLK4vGsOm8WxBWIO
	TB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAE1WUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWbM/H6AqaBPsqJ3
	5WGmBsbpol2MnBwSAiYSDfufsELYYhIX7q1n62Lk4hASWMQocXrnWxYI5zejxM4Xu5hBqtgE
	1CSaZ14GquLgEBGwkDjRlgUSZhaokbh6+QYjiC0sECpxeFYPE4jNIqAqMXteBxuIzStgKfHt
	0RYoW1Dix+R7LBC9WhLrdx5ngrDlJTavecsMcZCCxI6zr8FmigjoSTx6u5MRZC2zgLjEtKai
	CYwCs5BMmoVk0iwkk2YhdCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyNz6R2MK5s
	sDjEKMDBqMTDW6n5PkCINbGsuDL3EKMEB7OSCG/LgncBQrwpiZVVqUX58UWlOanFhxh9gP6c
	yCwlmpwPTBR5JfGGxiZmRpZGZhZGJubmOISVxHkZTz0JEBJITyxJzU5NLUgtghnHxMEp1cDo
	xt+uc07WJJeTWzT48bR0V0kbfYG9OzxbfTwD3/G0ZC3K/ntktljkv/crdV9pTxc+VlCvJcz1
	+rA6j8f3FY+f1adPmnlDxeqos6TmzLSZL0x8M69M/x2pcsvjT+PVhBRrzXn3ZoYs9G/YLrGa
	5cTuNVvWP8udle917qwOt3qD51mlgLKQ/SJKLMUZiYZazEXFiQDC6L2o8wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds gmac autoneg set function for SGMII, TBI,
or RTBI interface. In case of PHY's autoneg is set, gmac's
autoneg enable bit should set. After checking phy's autoneg
if phydev's autoneg is '1' gmac's ANE bit set for those
interface.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |   11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    9 +++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h
b/drivers/net/ethernet/stmicro/stmmac/common.h
index 186d148..72ba769 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -344,6 +344,7 @@ struct stmmac_ops {
 	void (*reset_eee_mode) (void __iomem *ioaddr);
 	void (*set_eee_timer) (void __iomem *ioaddr, int ls, int tw);
 	void (*set_eee_pls) (void __iomem *ioaddr, int link);
+	void (*set_autoneg) (void __iomem *ioaddr);
 };
 
 struct mac_link {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index bfe0226..a0737b39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -297,6 +297,16 @@ static void  dwmac1000_set_eee_timer(void __iomem
*ioaddr, int ls, int tw)
 	writel(value, ioaddr + LPI_TIMER_CTRL);
 }
 
+static void dwmac1000_set_autoneg(void __iomem *ioaddr)
+{
+	u32 value;
+
+	value = readl(ioaddr + GMAC_AN_CTRL);
+	value |= 0x1000;
+	writel(value, ioaddr + GMAC_AN_CTRL);
+}
+
+
 static const struct stmmac_ops dwmac1000_ops = {
 	.core_init = dwmac1000_core_init,
 	.rx_ipc = dwmac1000_rx_ipc_enable,
@@ -311,6 +321,7 @@ static const struct stmmac_ops dwmac1000_ops = {
 	.reset_eee_mode =  dwmac1000_reset_eee_mode,
 	.set_eee_timer =  dwmac1000_set_eee_timer,
 	.set_eee_pls =  dwmac1000_set_eee_pls,
+	.set_autoneg =  dwmac1000_set_autoneg,
 };
 
 struct mac_device_info *dwmac1000_setup(void __iomem *ioaddr)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f07c061..3e28934 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1007,6 +1007,7 @@ static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
+	int interface = priv->plat->interface;
 
 	clk_prepare_enable(priv->stmmac_clk);
 
@@ -1041,6 +1042,14 @@ static int stmmac_open(struct net_device *dev)
 	/* Initialize the MAC Core */
 	priv->hw->mac->core_init(priv->ioaddr);
 
+	/* If phy autoneg is on, set gmac autoneg for SGMII, TBI and RTBI*/
+	if((interface == PHY_INTERFACE_MODE_SGMII) ||
+	   (interface == PHY_INTERFACE_MODE_TBI) ||
+	   (interface == PHY_INTERFACE_MODE_RTBI)) {
+		if (priv->phydev->autoneg)
+			priv->hw->mac->set_autoneg(priv->ioaddr);
+	}
+
 	/* Request the IRQ lines */
 	ret = request_irq(dev->irq, stmmac_interrupt,
 			 IRQF_SHARED, dev->name, dev);
-- 
1.7.10.4


