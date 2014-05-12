Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbaELPZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:25:09 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51698 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758554AbaELPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:25:05 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging/wlan-ng: remove function declaration
Date: Mon, 12 May 2014 17:22:45 +0200
Message-Id: <1399908167-19271-2-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
References: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed useless function prototype: static function p80211netdev_rx_bh()
is defined before being used.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index e350e1c..2da3cbb 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -90,9 +90,6 @@
 
 #include "cfg80211.c"
 
-/* Support functions */
-static void p80211netdev_rx_bh(unsigned long arg);
-
 /* netdevice method functions */
 static int p80211knetdev_init(netdevice_t *netdev);
 static struct net_device_stats *p80211knetdev_get_stats(netdevice_t *netdev);
-- 
1.8.1.4

