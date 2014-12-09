Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbaLIQqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:46:23 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49399 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738AbaLIQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:46:18 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB9GkFDB026688, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 3/9] r8169:update rtl8411b ephy parameter
Date: Wed, 10 Dec 2014 00:45:57 +0800
Message-ID: <1418143563-7652-4-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418143563-7652-1-git-send-email-hau@realtek.com>
References: <1418143563-7652-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update rtl8411b ephy parameter to improve pcie compatibility.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 10aa0b1..9c946df 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6000,10 +6000,11 @@ static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 	void __iomem *ioaddr = tp->mmio_addr;
 	static const struct ephy_info e_info_8411_2[] = {
 		{ 0x00, 0x0000,	0x0008 },
-		{ 0x0c, 0x3df0,	0x0200 },
+		{ 0x0c, 0x3bf0,	0x0400 },
 		{ 0x0f, 0xffff,	0x5200 },
 		{ 0x19, 0x0020,	0x0000 },
-		{ 0x1e, 0x0000,	0x2000 }
+		{ 0x1e, 0x0000,	0x2000 },
+		{ 0x06, 0x0000,	0x0010 }
 	};
 
 	rtl_hw_start_8168g(tp);
-- 
1.9.1

