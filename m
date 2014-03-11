Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaCKHOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:14:12 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52411 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaCKHOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:14:10 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2B7E2v8009803, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] r8169: fix the incorrect tx descriptor version
Date: Tue, 11 Mar 2014 15:11:59 +0800
Message-ID: <1394521919-4257-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tx descriptor version of RTL8111B belong to RTL_TD_0.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index e977965..3ff7bc3 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -209,7 +209,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_16] =
 		_R("RTL8101e",		RTL_TD_0, NULL, JUMBO_1K, true),
 	[RTL_GIGA_MAC_VER_17] =
-		_R("RTL8168b/8111b",	RTL_TD_1, NULL, JUMBO_4K, false),
+		_R("RTL8168b/8111b",	RTL_TD_0, NULL, JUMBO_4K, false),
 	[RTL_GIGA_MAC_VER_18] =
 		_R("RTL8168cp/8111cp",	RTL_TD_1, NULL, JUMBO_6K, false),
 	[RTL_GIGA_MAC_VER_19] =
-- 
1.8.4.2

