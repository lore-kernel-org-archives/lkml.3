Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3BCDFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:05:35 -0500
Received: from mout.gmx.net ([212.227.15.19]:63058 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab3BCDFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:05:02 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/My4QZa4LMj06i5mmVc5xAtn/uEeQjOOz5X0EkpE
	he0vsrhLSPGrpw
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging/xgifb: Remove unused variable
Date: Sun,  3 Feb 2013 04:08:42 +0100
Message-Id: <1359860926-27769-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
References: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index is not used here -> remove.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 53b5557..a7fb52f 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1390,14 +1390,10 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned char index;
 	unsigned short i;
 	struct XGI_LVDSCRT1HDataStruct const *LCDPtr = NULL;
 	struct XGI_LVDSCRT1VDataStruct const *LCDPtr1 = NULL;
 
-	index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-	index = index & IndexMask;
-
 	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		LCDPtr = XGI_GetLcdPtr(xgifb_epllcd_crt1_h, ModeNo, ModeIdIndex,
 				       RefreshRateTableIndex, pVBInfo);
-- 
1.7.8.6

