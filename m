Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809AbaFTQ44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:56:56 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35896 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaFTQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:56:55 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergo.torino@gmail.com, pebolle@tiscali.nl, himangi774@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in halbcoutsrc
Date: Fri, 20 Jun 2014 12:56:50 -0400
Message-Id: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrites the wireless check for legacy checking in function
halbtc_legacy to check for both Mode A and B.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
index 01f5a74..2d4fad3 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
@@ -144,7 +144,7 @@ static bool halbtc_legacy(struct rtl_priv *adapter)
 	
 	bool is_legacy = false;
 
-	if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_B))
+	if ((mac->mode == WIRELESS_MODE_A) || (mac->mode == WIRELESS_MODE_B))
 		is_legacy = true;
 
 	return is_legacy;
-- 
1.9.1

