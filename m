Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaGTObB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:31:01 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:21593 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbaGTOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:30:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgNAEfRy1NXQ0aj/2dsb2JhbABZgw6BKa4dBgEBAQEBBQEFaZ1IgQUXdoRgI4EaN4hGAbA0kHEXhXuJUB2EMAWbJYthiE6DRjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 30/30] ps3_gelic: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:30:48 +0200
Message-Id: <1405866648-24870-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
index d568af1..1205472 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
@@ -1831,25 +1831,18 @@ static const char *wpasecstr(enum gelic_eurus_wpa_security sec)
 	switch (sec) {
 	case GELIC_EURUS_WPA_SEC_NONE:
 		return "NONE";
-		break;
 	case GELIC_EURUS_WPA_SEC_WPA_TKIP_TKIP:
 		return "WPA_TKIP_TKIP";
-		break;
 	case GELIC_EURUS_WPA_SEC_WPA_TKIP_AES:
 		return "WPA_TKIP_AES";
-		break;
 	case GELIC_EURUS_WPA_SEC_WPA_AES_AES:
 		return "WPA_AES_AES";
-		break;
 	case GELIC_EURUS_WPA_SEC_WPA2_TKIP_TKIP:
 		return "WPA2_TKIP_TKIP";
-		break;
 	case GELIC_EURUS_WPA_SEC_WPA2_TKIP_AES:
 		return "WPA2_TKIP_AES";
-		break;
 	case GELIC_EURUS_WPA_SEC_WPA2_AES_AES:
 		return "WPA2_AES_AES";
-		break;
 	}
 	return "";
 };
-- 
1.9.1

