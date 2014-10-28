Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbaJ1GGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:06:10 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49246 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbaJ1GGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:06:06 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9S663Mt009972, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/2] r8152: rename tx_underun
Date: Tue, 28 Oct 2014 14:05:51 +0800
Message-ID: <1394712342-15778-67-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-66-Taiwan-albertk@realtek.com>
References: <1394712342-15778-66-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace tx_underun with tx_underrun for checkpatch.pl.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e3d84c3..fdea194 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -486,7 +486,7 @@ struct tally_counter {
 	__le64	rx_broadcast;
 	__le32	rx_multicast;
 	__le16	tx_aborted;
-	__le16	tx_underun;
+	__le16	tx_underrun;
 };
 
 struct rx_desc {
@@ -3420,7 +3420,7 @@ static void rtl8152_get_ethtool_stats(struct net_device *dev,
 	data[9] = le64_to_cpu(tally.rx_broadcast);
 	data[10] = le32_to_cpu(tally.rx_multicast);
 	data[11] = le16_to_cpu(tally.tx_aborted);
-	data[12] = le16_to_cpu(tally.tx_underun);
+	data[12] = le16_to_cpu(tally.tx_underrun);
 }
 
 static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
-- 
1.9.3

