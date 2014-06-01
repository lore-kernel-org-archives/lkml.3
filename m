Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaFAMT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:58 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48124 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbaFAMT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/26] staging: rtl8188eu: Remove hal_data_sz from struct adapter
Date: Sun,  1 Jun 2014 17:46:46 +0530
Message-Id: <1401625013-11208-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c   |    1 -
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 141f85a..8831be5 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -2234,7 +2234,6 @@ void rtl8188eu_set_hal_ops(struct adapter *adapt)
 	adapt->HalData = rtw_zmalloc(sizeof(struct hal_data_8188e));
 	if (adapt->HalData == NULL)
 		DBG_88E("cant not alloc memory for HAL DATA\n");
-	adapt->hal_data_sz = sizeof(struct hal_data_8188e);
 
 	halfunc->hal_power_on = rtl8188eu_InitPowerOn;
 	halfunc->hal_init = &rtl8188eu_hal_init;
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index de3b70c..9cdab6a 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -215,7 +215,6 @@ struct adapter {
 	struct wifidirect_info	wdinfo;
 
 	void *HalData;
-	u32 hal_data_sz;
 	struct hal_ops	HalFunc;
 
 	s32	bDriverStopped;
-- 
1.7.10.4

