Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaLDMlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:41:36 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40826 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaLDMlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:41:35 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        es.Sorensen@redhat.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: rtl8723au: hal: Added blank line after declaration
Date: Thu,  4 Dec 2014 18:11:13 +0530
Message-Id: <1417696873-3281-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl warning:

WARNING: Missing blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/rtl8723au/hal/odm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
index 1c0f106d..cabe33a 100644
--- a/drivers/staging/rtl8723au/hal/odm.c
+++ b/drivers/staging/rtl8723au/hal/odm.c
@@ -1435,6 +1435,7 @@ static void ODM_EdcaTurboInit23a(struct dm_odm_t *pDM_Odm)
 {
 
 	struct rtw_adapter *Adapter = pDM_Odm->Adapter;
+
 	pDM_Odm->DM_EDCA_Table.bCurrentTurboEDCA = false;
 	pDM_Odm->DM_EDCA_Table.bIsCurRDLState = false;
 	Adapter->recvpriv.bIsAnyNonBEPkts = false;
@@ -1591,6 +1592,7 @@ ConvertTo_dB23a(
 void ODM_SingleDualAntennaDefaultSetting(struct dm_odm_t *pDM_Odm)
 {
 	struct sw_ant_sw *pDM_SWAT_Table = &pDM_Odm->DM_SWAT_Table;
+
 	pDM_SWAT_Table->ANTA_ON = true;
 	pDM_SWAT_Table->ANTB_ON = true;
 }
-- 
1.9.1

