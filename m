Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaFVIw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54833 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaFVIwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 38/42] staging: rtl8188eu: osdep_service.h: Remove unused macros
Date: Sun, 22 Jun 2014 14:21:42 +0530
Message-Id: <1403427107-12744-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 913cbfe..e335471 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -109,9 +109,6 @@ static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
 		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 3));
 }
 
-#ifndef BIT
-	#define BIT(x)	(1 << (x))
-#endif
 
 #define BIT0	0x00000001
 #define BIT1	0x00000002
@@ -178,7 +175,6 @@ static inline void flush_signals_thread(void)
 		flush_signals(current);
 }
 
-#define _RND(sz, r) ((((sz)+((r)-1))/(r))*(r))
 #define RND4(x)	(((x >> 2) + (((x & 3) == 0) ?  0 : 1)) << 2)
 
 struct rtw_netdev_priv_indicator {
-- 
1.7.10.4

