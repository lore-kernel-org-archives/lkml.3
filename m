Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbaDIHdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:33:36 -0400
Received: from mx02.posteo.de ([89.146.194.165]:51841 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751488AbaDIHdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:33:35 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 03:33:35 EDT
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: teobaluta@gmail.com, josh@joshtriplett.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: rtl8187se: fix pointer and return statement's syntax
Date: Wed,  9 Apr 2014 09:25:55 +0200
Message-Id: <1397028355-28063-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
noise from the eudyptula challenge. applies to next-20140408 as well as
linus' current tree.

 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
index 0dc5ae4..e6257b3 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
@@ -180,7 +180,7 @@ static inline int ieee80211_put_snap(u8 *data, u16 h_proto)
 int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
 			       struct sk_buff *frag, int hdr_len)
 {
-	struct ieee80211_crypt_data* crypt = ieee->crypt[ieee->tx_keyidx];
+	struct ieee80211_crypt_data *crypt = ieee->crypt[ieee->tx_keyidx];
 	int res;
 
 	/*
@@ -285,7 +285,7 @@ static int ieee80211_classify(struct sk_buff *skb,
 
 	if (!network->QoS_Enable) {
 		skb->priority = 0;
-		return(wme_UP);
+		return wme_UP;
 	}
 
 	if (eh->ether_type == __constant_htons(ETHERTYPE_IP)) {
@@ -304,7 +304,7 @@ static int ieee80211_classify(struct sk_buff *skb,
 	}
 
 	skb->priority = wme_UP;
-	return(wme_UP);
+	return wme_UP;
 }
 
 /* SKBs are added to the ieee->tx_queue. */
-- 
1.7.10.4

