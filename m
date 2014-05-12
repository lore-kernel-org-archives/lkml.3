Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbaELPZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:25:08 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51699 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501AbaELPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:25:05 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging/wlan-ng: update function header comment
Date: Mon, 12 May 2014 17:22:44 +0200
Message-Id: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header comment of p80211netdev_rx_bh() does not match function
prototype. Fixed.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index e3ae802..e350e1c 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -243,19 +243,11 @@ void p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 	tasklet_schedule(&wlandev->rx_bh);
 }
 
-/*----------------------------------------------------------------
-* p80211netdev_rx_bh
-*
-* Deferred processing of all received frames.
-*
-* Arguments:
-*	wlandev		WLAN network device structure
-*	skb		skbuff containing a full 802.11 frame.
-* Returns:
-*	nothing
-* Side effects:
-*
-----------------------------------------------------------------*/
+/**
+ * p80211netdev_rx_bh - deferred processing of all received frames
+ *
+ * @arg: pointer to WLAN network device structure (cast to unsigned long)
+ */
 static void p80211netdev_rx_bh(unsigned long arg)
 {
 	wlandevice_t *wlandev = (wlandevice_t *) arg;
-- 
1.8.1.4

