Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLPQ2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:28:06 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39138 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaLPQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:28:04 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sanjeev_sharma@mentor.com, oort10@gmail.com, md.jamalmohiuddin@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8192u : fix space before , coding style issue in r8190_rtl8256.c
Date: Tue, 16 Dec 2014 21:57:44 +0530
Message-Id: <1418747264-4949-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to r8190_rtl8256.c file that fixes space before , warning found by checkpatch.pl tool

Signed-off-by: Mohammad Jamal<md.jamalmohiuddin@gmail.com>
---
 drivers/staging/rtl8192u/r8190_rtl8256.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.c b/drivers/staging/rtl8192u/r8190_rtl8256.c
index 45514aa..1868352 100644
--- a/drivers/staging/rtl8192u/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192u/r8190_rtl8256.c
@@ -23,7 +23,7 @@
  * Return:      NONE
  * Note:	8226 support both 20M  and 40 MHz
  *---------------------------------------------------------------------------*/
-void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)
+void PHY_SetRF8256Bandwidth(struct net_device *dev, HT_CHANNEL_WIDTH Bandwidth)
 {
 	u8	eRFPath;
 	struct r8192_priv *priv = ieee80211_priv(dev);
--
1.7.9.5

