Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938AbaE2Rwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:52:41 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63578 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2Rwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:52:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/18] staging: rtl8188eu: Remove unused function reset_reset_value()
Date: Thu, 29 May 2014 23:20:46 +0530
Message-Id: <1401385858-28722-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_sreset.c    |    9 ---------
 drivers/staging/rtl8188eu/include/rtw_sreset.h |    1 -
 2 files changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index 434c433..5bc8fe0 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -29,15 +29,6 @@ void sreset_init_value(struct adapter *padapter)
 	psrtpriv->last_tx_time = 0;
 	psrtpriv->last_tx_complete_time = 0;
 }
-void sreset_reset_value(struct adapter *padapter)
-{
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(padapter);
-	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
-
-	psrtpriv->Wifi_Error_Status = WIFI_STATUS_SUCCESS;
-	psrtpriv->last_tx_time = 0;
-	psrtpriv->last_tx_complete_time = 0;
-}
 
 u8 sreset_get_wifi_status(struct adapter *padapter)
 {
diff --git a/drivers/staging/rtl8188eu/include/rtw_sreset.h b/drivers/staging/rtl8188eu/include/rtw_sreset.h
index 8474180..af01972 100644
--- a/drivers/staging/rtl8188eu/include/rtw_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtw_sreset.h
@@ -41,7 +41,6 @@ struct sreset_priv {
 #define		WIFI_IF_NOT_EXIST			BIT6
 
 void sreset_init_value(struct adapter *padapter);
-void sreset_reset_value(struct adapter *padapter);
 u8 sreset_get_wifi_status(struct adapter *padapter);
 void sreset_set_wifi_error_status(struct adapter *padapter, u32 status);
 
-- 
1.7.10.4

