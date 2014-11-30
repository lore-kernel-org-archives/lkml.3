Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaK3ReJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:34:09 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36853 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaK3ReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:34:07 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        es.Sorensen@redhat.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: Removed the extra semicolon
Date: Sun, 30 Nov 2014 23:03:37 +0530
Message-Id: <1417368817-7224-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: Statement terminations use 1 semicolon

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index d80ea4e..96b5245 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -10639,7 +10639,7 @@ void BTDM_BBBackOffLevel(struct rtw_adapter *padapter, u8 type)
 
 void BTDM_FWCoexAllOff(struct rtw_adapter *padapter)
 {
-	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);;
+	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
 
 	RTPRINT(FBT, BT_TRACE, ("BTDM_FWCoexAllOff()\n"));
 	if (pHalData->bt_coexist.bFWCoexistAllOff)
@@ -10653,7 +10653,7 @@ void BTDM_FWCoexAllOff(struct rtw_adapter *padapter)
 
 void BTDM_SWCoexAllOff(struct rtw_adapter *padapter)
 {
-	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);;
+	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
 
 	RTPRINT(FBT, BT_TRACE, ("BTDM_SWCoexAllOff()\n"));
 	if (pHalData->bt_coexist.bSWCoexistAllOff)
@@ -10666,7 +10666,7 @@ void BTDM_SWCoexAllOff(struct rtw_adapter *padapter)
 
 void BTDM_HWCoexAllOff(struct rtw_adapter *padapter)
 {
-	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);;
+	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
 
 	RTPRINT(FBT, BT_TRACE, ("BTDM_HWCoexAllOff()\n"));
 	if (pHalData->bt_coexist.bHWCoexistAllOff)
-- 
1.9.1

