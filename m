Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaK0Onk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:43:40 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63931 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0Oni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:43:38 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] Drivers:Staging:rtl8188eu:hal:usb_halinit.c: Added blank line after declarations
Date: Thu, 27 Nov 2014 20:13:03 +0530
Message-Id: <1417099383-5862-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This patch fixes the five checkpatch.pl warnings:

    WARNING:Missing a blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 14650e9..439828c 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1931,6 +1931,7 @@ GetHalDefVar8188EUsb(
 	case HW_DEF_RA_INFO_DUMP:
 		{
 			u8 entry_id = *((u8 *)pValue);
+
 			if (check_fwstate(&Adapter->mlmepriv, _FW_LINKED)) {
 				DBG_88E("============ RA status check ===================\n");
 				DBG_88E("Mac_id:%d , RateID = %d, RAUseRate = 0x%08x, RateSGI = %d, DecisionRate = 0x%02x ,PTStage = %d\n",
@@ -1946,6 +1947,7 @@ GetHalDefVar8188EUsb(
 	case HW_DEF_ODM_DBG_FLAG:
 		{
 			struct odm_dm_struct *dm_ocm = &(haldata->odmpriv);
+
 			pr_info("dm_ocm->DebugComponents = 0x%llx\n", dm_ocm->DebugComponents);
 		}
 		break;
@@ -1994,6 +1996,7 @@ static u8 SetHalDefVar8188EUsb(struct adapter *Adapter, enum hal_def_variable eV
 			} else if (dm_func == 6) {/* turn on all dynamic func */
 				if (!(podmpriv->SupportAbility  & DYNAMIC_BB_DIG)) {
 					struct rtw_dig *pDigTable = &podmpriv->DM_DigTable;
+
 					pDigTable->CurIGValue = usb_read8(Adapter, 0xc50);
 				}
 				podmpriv->SupportAbility = DYNAMIC_ALL_FUNC_ENABLE;
@@ -2011,6 +2014,7 @@ static u8 SetHalDefVar8188EUsb(struct adapter *Adapter, enum hal_def_variable eV
 		{
 			u8 bRSSIDump = *((u8 *)pValue);
 			struct odm_dm_struct *dm_ocm = &(haldata->odmpriv);
+
 			if (bRSSIDump)
 				dm_ocm->DebugComponents	=	ODM_COMP_DIG|ODM_COMP_FA_CNT;
 			else
@@ -2021,7 +2025,9 @@ static u8 SetHalDefVar8188EUsb(struct adapter *Adapter, enum hal_def_variable eV
 		{
 			u64	DebugComponents = *((u64 *)pValue);
 			struct odm_dm_struct *dm_ocm = &(haldata->odmpriv);
+
 			dm_ocm->DebugComponents = DebugComponents;
+
 		}
 		break;
 	default:
-- 
1.9.1

