Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaFFQQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:50 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58933 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaFFQQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/13] staging: rtl8188eu: HalPhyRf_8188e.c: Remove unnecessary comments
Date: Fri,  6 Jun 2014 21:45:19 +0530
Message-Id: <1402071320-14400-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c |   37 ++++--------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 5afaad2..c951616 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -1,5 +1,4 @@
-
-/******************************************************************************
+/*
  *
  * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
  *
@@ -15,17 +14,13 @@
  * You should have received a copy of the GNU General Public License along with
  * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
+ */
 
 #include "odm_precomp.h"
 
-/*---------------------------Define Local Constant---------------------------*/
 /*  2010/04/25 MH Define the max tx power tracking tx agc power. */
 #define		ODM_TXPWRTRACK_MAX_IDX_88E		6
 
-/*---------------------------Define Local Constant---------------------------*/
 
 u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
 {
@@ -47,27 +42,19 @@ u8 ODM_GetRightChnlPlaceforIQK(u8 chnl)
 	return 0;
 }
 
-/* 3============================================================ */
 /* 3 Tx Power Tracking */
-/* 3============================================================ */
-/*-----------------------------------------------------------------------------
+/*
  * Function:	ODM_TxPwrTrackAdjust88E()
  *
  * Overview:	88E we can not write 0xc80/c94/c4c/ 0xa2x. Instead of write TX agc.
  *				No matter OFDM & CCK use the same method.
  *
- * Input:		NONE
- *
- * Output:		NONE
- *
- * Return:		NONE
- *
  * Revised History:
  *	When		Who		Remark
  *	04/23/2012	MHC		Create Version 0.
  *	04/23/2012	MHC		Adjust TX agc directly not throughput BB digital.
  *
- *---------------------------------------------------------------------------*/
+ */
 void ODM_TxPwrTrackAdjust88E(struct odm_dm_struct *dm_odm, u8 Type,/*  0 = OFDM, 1 = CCK */
 	u8 *pDirection, 		/*  1 = +(increase) 2 = -(decrease) */
 	u32 *pOutWriteVal		/*  Tx tracking CCK/OFDM BB swing index adjust */
@@ -116,23 +103,12 @@ void ODM_TxPwrTrackAdjust88E(struct odm_dm_struct *dm_odm, u8 Type,/*  0 = OFDM,
 	*pOutWriteVal = pwr_value | (pwr_value<<8) | (pwr_value<<16) | (pwr_value<<24);
 }	/*  ODM_TxPwrTrackAdjust88E */
 
-/*-----------------------------------------------------------------------------
+/*
  * Function:	odm_TxPwrTrackSetPwr88E()
  *
  * Overview:	88E change all channel tx power accordign to flag.
  *				OFDM & CCK are all different.
- *
- * Input:		NONE
- *
- * Output:		NONE
- *
- * Return:		NONE
- *
- * Revised History:
- *	When		Who		Remark
- *	04/23/2012	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
+ */
 static void odm_TxPwrTrackSetPwr88E(struct odm_dm_struct *dm_odm)
 {
 	if (dm_odm->BbSwingFlagOfdm || dm_odm->BbSwingFlagCck) {
@@ -143,7 +119,6 @@ static void odm_TxPwrTrackSetPwr88E(struct odm_dm_struct *dm_odm)
 	}
 }	/*  odm_TxPwrTrackSetPwr88E */
 
-/* 091212 chiyokolin */
 void
 odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 	struct adapter *Adapter
-- 
1.7.10.4

