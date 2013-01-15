Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3AOVtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:49:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61814 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3AOVtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:49:21 -0500
X-AuditID: cbfee61b-b7f616d00000319b-c7-50f5cedffe44
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: [PATCH net-next 2/3] net: stmmac: add autoneg complete irq
Date: Tue, 15 Jan 2013 13:49:18 -0800
Message-id: <00c501cdf36a$2cac3a60$8604af20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3zah5iPcXqDp7YTFCdR+B9G+3kCg==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zQ937574GGLy8b2lxedccNotjC8Qc
	mDw+b5ILYIzisklJzcksSy3St0vgyri3qI+p4Kdoxcpfp9gbGC8JdTFyckgImEhcXzCPHcIW
	k7hwbz1bFyMXh5DAMkaJda+WMsMU7bmyjQUiMZ1RYtLtE0wQzm9GiZZl7xlBqtgE1CSaZ14G
	aufgEBGwkDjRlgUSZhaokbh6+QZYibCAs8Sza5OZQGwWAVWJZf/vsYDYvAKWEk071zJD2IIS
	PyZDxJkFtCTW7zzOBGHLS2xe8xbqIAWJHWdfg80UEdCTOP/lICPIWmYBcYlpTUUQ4wUkvk0+
	xAISlhCQldh0gBnkYgmBbnaJzX+eQT0sKXFwxQ2WCYxis5BsnoVk8ywkm2chbFjAyLKKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIyRepHcwrmqwOMQowMGoxMPrWfg1QIg1say4MvcQowQH
	s5IIb9hCoBBvSmJlVWpRfnxRaU5q8SFGH6DDJzJLiSbnA2M5ryTe0NjYxMzE1MTc0tTcFIew
	kjgv46knAUIC6YklqdmpqQWpRTDjmDg4pRoYt30VvpphsHvf0uBp1/h/flATDTNs5a+Wvc5k
	MMM5sOZY5733J0yeMuUsmCn0yDHrmAev2ObN61rEW1T2MSwykt64+vXWTWtyTMomz/3SZHxj
	3peod7vLzbOqs+8mlgv+sWML4Pnnf/EoX82dmeGmX0/qcQblV/onX7O5/G7lr7xPxvtO3Pbr
	UWIpzkg01GIuKk4EAKVg1KjEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd37574GGPS8Nba4vGsOm8WxBWIO
	TB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAE1WUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWbcW9THVPBTtGLl
	r1PsDYyXhLoYOTkkBEwk9lzZxgJhi0lcuLeerYuRi0NIYDqjxKTbJ5ggnN+MEi3L3jOCVLEJ
	qEk0z7wMVMXBISJgIXGiLQskzCxQI3H18g2wEmEBZ4ln1yYzgdgsAqoSy/7fA1vAK2Ap0bRz
	LTOELSjxYzJEnFlAS2L9zuNMELa8xOY1b5khDlKQ2HH2NdhMEQE9ifNfDjKCrGUWEJeY1lQ0
	gVFgFpJJs5BMmoVk0iyEjgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqPxmfQOxlUN
	FocYBTgYlXh4PQu/BgixJpYVV+YeYpTgYFYS4Q1bCBTiTUmsrEotyo8vKs1JLT7E6AP050Rm
	KdHkfGCiyCuJNzQ2MTOyNDKzMDIxN8chrCTOy3jqSYCQQHpiSWp2ampBahHMOCYOTqkGxmk1
	e27ekDpT8EjnwNXwZWumB7K4XOFjDDv25Yxl317p+9Pv5157qyu4/EnP2TVrjxdFNU86k+Wk
	as+SH8QVplfnu16q1kth/9udnOn1u4znTuyV7S0TSd4n7x27kKdno7E9q828eY8VTzw0Vr2y
	JiX12GHBb5UC4lxpIS9/5SnOk0s4e643UImlOCPRUIu5qDgRAPZcVGnzAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds auto-negotiation complete irq and ISR.
when the irq is occured it read GMAC_AN_STATUS register
to clear PCSANCIS bit.

Singed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    5 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h
b/drivers/net/ethernet/stmicro/stmmac/common.h
index 72ba769..bc5ce7a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -203,6 +203,7 @@ enum core_specific_irq_mask {
 	core_irq_tx_path_exit_lpi_mode = 32,
 	core_irq_rx_path_in_lpi_mode = 64,
 	core_irq_rx_path_exit_lpi_mode = 128,
+	core_irq_pcs_autoneg_complete = 256,
 };
 
 /* DMA HW capabilities */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index a0737b39..0643ed3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -222,6 +222,11 @@ static int dwmac1000_irq_status(void __iomem *ioaddr)
 		readl(ioaddr + GMAC_PMT);
 		status |= core_irq_receive_pmt_irq;
 	}
+	if (unlikely(intr_status & pcs_ane_irq)) {
+		CHIP_DBG(KERN_INFO "GMAC: PCS Auto-negotiation complete\n");
+		readl(ioaddr + GMAC_AN_STATUS);
+		status |= core_irq_pcs_autoneg_complete;
+	}
 	/* MAC trx/rx EEE LPI entry/exit interrupts */
 	if (intr_status & lpiis_irq) {
 		/* Clean LPI interrupt by reading the Reg 12 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index b05df89..b4220f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -93,6 +93,7 @@ struct stmmac_priv {
 	u32 tx_coal_timer;
 	int use_riwt;
 	u32 rx_riwt;
+	bool core_pcs_an;
 };
 
 extern int phyaddr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3e28934..0d2afbb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1623,6 +1623,8 @@ static irqreturn_t stmmac_interrupt(int irq, void
*dev_id)
 				priv->xstats.mmc_rx_csum_offload_irq_n++;
 			if (status & core_irq_receive_pmt_irq)
 				priv->xstats.irq_receive_pmt_irq_n++;
+			if (status & core_irq_pcs_autoneg_complete)
+				priv->core_pcs_an = true;
 
 			/* For LPI we need to save the tx status */
 			if (status & core_irq_tx_path_in_lpi_mode) {
-- 
1.7.10.4


