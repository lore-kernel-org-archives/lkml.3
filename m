Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaERPVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:21:38 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34291 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaERPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:21:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/28] staging:rtl8188eu:Remove funtion Hal_CustomizeByCustomerID_8188EU()
Date: Sun, 18 May 2014 20:48:59 +0530
Message-Id: <1400426361-19596-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function has empty defination.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 4c3f8c8..141f85a 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1133,10 +1133,6 @@ static void Hal_EfuseParseMACAddr_8188EU(struct adapter *adapt, u8 *hwinfo, bool
 		 eeprom->mac_addr[4], eeprom->mac_addr[5]));
 }
 
-static void Hal_CustomizeByCustomerID_8188EU(struct adapter *adapt)
-{
-}
-
 static void
 readAdapterInfo_8188EU(
 		struct adapter *adapt
@@ -1163,7 +1159,6 @@ readAdapterInfo_8188EU(
 	/*  The following part initialize some vars by PG info. */
 	/*  */
 	Hal_InitChannelPlan(adapt);
-	Hal_CustomizeByCustomerID_8188EU(adapt);
 }
 
 static void _ReadPROMContent(
-- 
1.7.10.4

