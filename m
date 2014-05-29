Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773AbaE2Rv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:51:57 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45769 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2Rvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:51:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/18] staging: rtl8188eu: Remove unused function rtw_hal_sreset_reset_value()
Date: Thu, 29 May 2014 23:20:44 +0530
Message-Id: <1401385858-28722-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c     |    6 ------
 drivers/staging/rtl8188eu/include/hal_intf.h |    1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index d0ac4a1..699775b 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -380,12 +380,6 @@ void rtw_hal_sreset_reset(struct adapter *adapt)
 		adapt->HalFunc.silentreset(adapt);
 }
 
-void rtw_hal_sreset_reset_value(struct adapter *adapt)
-{
-	if (adapt->HalFunc.sreset_reset_value)
-		adapt->HalFunc.sreset_reset_value(adapt);
-}
-
 void rtw_hal_sreset_xmit_status_check(struct adapter *adapt)
 {
 	if (adapt->HalFunc.sreset_xmit_status_check)
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index c59fccd..fff349f 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -369,7 +369,6 @@ void	rtw_hal_antdiv_rssi_compared(struct adapter *padapter,
 
 void rtw_hal_sreset_init(struct adapter *padapter);
 void rtw_hal_sreset_reset(struct adapter *padapter);
-void rtw_hal_sreset_reset_value(struct adapter *padapter);
 void rtw_hal_sreset_xmit_status_check(struct adapter *padapter);
 void rtw_hal_sreset_linked_status_check(struct adapter *padapter);
 u8   rtw_hal_sreset_get_wifi_status(struct adapter *padapter);
-- 
1.7.10.4

