Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaFAMSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53323 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaFAMSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:46 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/26] staging: rtl8188eu: Remove unused stucture defination struct specific_device_id
Date: Sun,  1 Jun 2014 17:46:36 +0530
Message-Id: <1401625013-11208-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index f40db1a..8cbdab5 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -68,12 +68,6 @@ enum _NIC_VERSION {
 #define SPEC_DEV_ID_RF_CONFIG_2T2R	BIT(4)
 #define SPEC_DEV_ID_ASSIGN_IFNAME	BIT(5)
 
-struct specific_device_id {
-	u32		flags;
-	u16		idVendor;
-	u16		idProduct;
-};
-
 struct registry_priv {
 	u8	chip_version;
 	u8	rfintfs;
-- 
1.7.10.4

