Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbbAGQmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:42:52 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41852 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbbAGQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:40:37 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t07GeZwI024006, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 04/11] r8169:update rtl8168dp pcie ephy parameter
Date: Thu, 8 Jan 2015 00:40:19 +0800
Message-ID: <1420648826-12972-5-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420648826-12972-1-git-send-email-hau@realtek.com>
References: <1420648826-12972-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add following ephy parameter. This parameter will save more power when
in ASPM mode.
{ 0x10, 0x0004,	0x0000 }

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 0fc7e62..15a0f5b 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5733,7 +5733,8 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 	static const struct ephy_info e_info_8168d_4[] = {
 		{ 0x0b, 0x0000,	0x0048 },
 		{ 0x19, 0x0020,	0x0050 },
-		{ 0x0c, 0x0100,	0x0020 }
+		{ 0x0c, 0x0100,	0x0020 },
+		{ 0x10, 0x0004,	0x0000 }
 	};
 
 	rtl_csi_access_enable_1(tp);
-- 
1.9.1

