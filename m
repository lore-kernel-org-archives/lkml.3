Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaGaTfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:35:02 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43730 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaGaTfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:35:00 -0400
From: Modestas Stankus <stankus.modestas@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Modestas Stankus <stankus.modestas@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: coding style problem fix
Date: Thu, 31 Jul 2014 22:33:35 +0300
Message-Id: <1406835215-15852-1-git-send-email-stankus.modestas@gmail.com>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: break is not useful after a goto or return
201: FILE: drivers/staging/wlan-ng/p80211conv.c:201:
+               return 1;
+               break;

Signed-off-by: Modestas Stankus <stankus.modestas@gmail.com>
---
 drivers/staging/wlan-ng/p80211conv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 913676e..3b5468c 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -198,7 +198,6 @@ int skb_ether_to_p80211(wlandevice_t *wlandev, u32 ethconv,
 		netdev_err(wlandev->netdev,
 			   "Error: Converting eth to wlan in unknown mode.\n");
 		return 1;
-		break;
 	}
 
 	p80211_wep->data = NULL;
-- 
2.0.3

