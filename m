Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbaFAMTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:52 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35599 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755AbaFAMTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:50 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/26] staging: rtl8188eu: Remove unused function rtl8188e_clone_haldata()
Date: Sun,  1 Jun 2014 17:46:45 +0530
Message-Id: <1401625013-11208-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    5 -----
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 6a9c8e2..208b373 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1815,11 +1815,6 @@ static void rtl8188e_SetHalODMVar(struct adapter *Adapter, enum hal_odm_variable
 	}
 }
 
-void rtl8188e_clone_haldata(struct adapter *dst_adapter, struct adapter *src_adapter)
-{
-	memcpy(dst_adapter->HalData, src_adapter->HalData, dst_adapter->hal_data_sz);
-}
-
 void rtl8188e_start_thread(struct adapter *padapter)
 {
 }
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index c7fef7a..4b59c8e 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -463,7 +463,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc);
 /*  register */
 void SetBcnCtrlReg(struct adapter *padapter, u8 SetBits, u8 ClearBits);
 
-void rtl8188e_clone_haldata(struct adapter *dst, struct adapter *src);
 void rtl8188e_start_thread(struct adapter *padapter);
 void rtl8188e_stop_thread(struct adapter *padapter);
 
-- 
1.7.10.4

