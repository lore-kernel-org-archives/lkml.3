Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaHMFg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:36:57 -0400
Received: from thoros.lunarpages.com ([67.210.120.70]:41403 "EHLO
	thoros.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaHMFg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:36:56 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2014 01:36:56 EDT
From: "Ragnar B. Johannsson" <ragnar@igo.is>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ragnar B. Johannsson" <ragnar@igo.is>
Subject: [PATCH 3/3] staging: vt6656: add blank line after declaration
Date: Sun, 10 Aug 2014 22:23:50 +0000
Message-Id: <1407709430-61260-4-git-send-email-ragnar@igo.is>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407709430-61260-1-git-send-email-ragnar@igo.is>
References: <1407709430-61260-1-git-send-email-ragnar@igo.is>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thoros.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [0 0]
X-AntiAbuse: Sender Address Domain - igo.is
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a blank line after declaration to comply with coding style.

Signed-off-by: Ragnar B. Johannsson <ragnar@igo.is>
---
 drivers/staging/vt6656/rxtx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 08ce18d..852ebe8 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1036,6 +1036,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 	info = IEEE80211_SKB_CB(skb);
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)mgmt_hdr;
+
 		hdr->duration_id = 0;
 		hdr->seq_ctrl = cpu_to_le16(priv->seq_counter << 4);
 	}
-- 
1.9.3

