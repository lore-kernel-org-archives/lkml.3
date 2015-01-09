Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbbAIP0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:26:24 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57162 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbbAIP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:26:22 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t09FQJWH026008, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next v2 7/8] r8169:update rtl8402 pcie ephy parameter
Date: Fri, 9 Jan 2015 23:26:05 +0800
Message-ID: <1420817166-9868-8-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420817166-9868-1-git-send-email-hau@realtek.com>
References: <1420817166-9868-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove following unnecessary ephy parameter.
{ 0x1e,	0, 0x4000 }

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 483fa40..aa12833 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6431,8 +6431,7 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 {
 	void __iomem *ioaddr = tp->mmio_addr;
 	static const struct ephy_info e_info_8402[] = {
-		{ 0x19,	0xffff, 0xff64 },
-		{ 0x1e,	0, 0x4000 }
+		{ 0x19,	0xffff, 0xff64 }
 	};
 
 	rtl_csi_access_enable_2(tp);
-- 
1.9.1

