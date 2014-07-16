Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbaGPHpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:45:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61498 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaGPHps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:45:48 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: fix missing blank line after variable declaration
Date: Wed, 16 Jul 2014 10:45:30 +0300
Message-Id: <1405496730-7256-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor bezukh <igbzkh@gmail.com>

Checkpatch fix - Add missing blank line after variable declaration

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/card.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index e21abd8..0b2ca2f 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -351,6 +351,7 @@ s_vSetRSPINF(PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs, v
 bool CARDbIsShortPreamble(void *pDeviceHandler)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
+
 	if (pDevice->byPreambleType == 0)
 		return false;
 
@@ -372,6 +373,7 @@ bool CARDbIsShortPreamble(void *pDeviceHandler)
 bool CARDbIsShorSlotTime(void *pDeviceHandler)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
+
 	return pDevice->bShortSlotTime;
 }
 
@@ -929,6 +931,7 @@ bool CARDbRadioPowerOn(void *pDeviceHandler)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	bool bResult = true;
+
 	printk("chester power on\n");
 	if (pDevice->bRadioControlOff == true) {
 		if (pDevice->bHWRadioOff == true) printk("chester bHWRadioOff\n");
-- 
1.7.9.5

