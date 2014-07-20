Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaGTOUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:20:18 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:41906 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbaGTOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:20:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKALLOy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwMZBwF4V7iVAHFoQwBZsllC+DRjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/30] mwl8k: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:12 +0200
Message-Id: <1405865801-18806-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/mwl8k.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3c0a0a8..9a3d4d6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1633,22 +1633,17 @@ static int mwl8k_tid_queue_mapping(u8 tid)
 	case 0:
 	case 3:
 		return IEEE80211_AC_BE;
-		break;
 	case 1:
 	case 2:
 		return IEEE80211_AC_BK;
-		break;
 	case 4:
 	case 5:
 		return IEEE80211_AC_VI;
-		break;
 	case 6:
 	case 7:
 		return IEEE80211_AC_VO;
-		break;
 	default:
 		return -1;
-		break;
 	}
 }
 
-- 
1.9.1

