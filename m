Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbaLIQrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:47:42 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49402 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbaLIQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:46:21 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB9GkJic027106, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 6/9] r8169:update rtl8168e-vl ephy parameter
Date: Wed, 10 Dec 2014 00:46:00 +0800
Message-ID: <1418143563-7652-7-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418143563-7652-1-git-send-email-hau@realtek.com>
References: <1418143563-7652-1-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update rtl8168e-vl ephy parameter to improve pcie compatibility.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 2ff8b73..a979519 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5817,7 +5817,9 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 	struct pci_dev *pdev = tp->pci_dev;
 	static const struct ephy_info e_info_8168e_2[] = {
 		{ 0x09, 0x0000,	0x0080 },
-		{ 0x19, 0x0000,	0x0224 }
+		{ 0x19, 0x0000,	0x0224 },
+		{ 0x00, 0x0000,	0x0008 },
+		{ 0x0c, 0x3df0,	0x0200 }
 	};
 
 	rtl_csi_access_enable_1(tp);
-- 
1.9.1

