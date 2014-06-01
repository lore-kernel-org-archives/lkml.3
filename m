Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaFAMUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:20:14 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39149 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaFAMUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:20:10 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/26] staging: rtl8188eu:Remove EepromAddressSize from struct adapter
Date: Sun,  1 Jun 2014 17:46:48 +0530
Message-Id: <1401625013-11208-22-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c   |    3 ---
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 8831be5..e60b5e9 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1203,9 +1203,6 @@ static int _ReadAdapterInfo8188EU(struct adapter *Adapter)
 
 static void ReadAdapterInfo8188EU(struct adapter *Adapter)
 {
-	/*  Read EEPROM size before call any EEPROM function */
-	Adapter->EepromAddressSize = GetEEPROMSize8188E(Adapter);
-
 	_ReadAdapterInfo8188EU(Adapter);
 }
 
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index a459206..ec9ad4a 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -220,7 +220,6 @@ struct adapter {
 	s32	bSurpriseRemoved;
 	s32	bCardDisableWOHSM;
 
-	u8	EepromAddressSize;
 	u8	hw_init_completed;
 
 	void *cmdThread;
-- 
1.7.10.4

