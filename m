Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaGLSLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:11:41 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:30174 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbaGLSLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:11:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMJAJB5wVNXQ56W/2dsb2JhbABZgw6tMgEBAQEBAQUBbpt/AYEQF3WEBAEFViMQUTkeGYhGAbUIkg0XhXuJUAcWhC0Fmw6LV4hGg0Y7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH V2 5/9] ps3_gelic: remove unnecessary break after goto
Date: Sat, 12 Jul 2014 20:09:44 +0200
Message-Id: <1405188597-2815-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405188597-2815-1-git-send-email-fabf@skynet.be>
References: <1405188597-2815-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
index d568af1..2553ed5 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
@@ -723,13 +723,10 @@ static int gelic_wl_get_scan(struct net_device *netdev,
 		/* If a scan in progress, caller should call me again */
 		ret = -EAGAIN;
 		goto out;
-		break;
-
 	case GELIC_WL_SCAN_STAT_INIT:
 		/* last scan request failed or never issued */
 		ret = -ENODEV;
 		goto out;
-		break;
 	case GELIC_WL_SCAN_STAT_GOT_LIST:
 		/* ok, use current list */
 		break;
-- 
1.9.1

