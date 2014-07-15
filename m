Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaGOUrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:47:20 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58960 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbaGOUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:47:18 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V5 5/6] staging: vt6556: Cleanup indentation on statements
Date: Tue, 15 Jul 2014 22:46:48 +0200
Message-Id: <1405457209-6584-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tabs instead of spaces in a set of statements and fix lines
over 80 chars. Reported by checkpatch.

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V4:
 - Fix identation issue found on V4

 drivers/staging/vt6656/main_usb.c | 44 ++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 553a8e9..cc0281a 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -382,38 +382,40 @@ static int device_init_registers(struct vnt_private *pDevice)
 	/* load vt3266 calibration parameters in EEPROM */
 	if (pDevice->byRFType == RF_VT3226D0) {
 		if ((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
-			(pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
+		    (pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
 
 			byCalibTXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
 			byCalibTXDC = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_DC];
 			byCalibRXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
 			if (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) {
-			/* CR255, enable TX/RX IQ and DC compensation mode */
+				/* CR255, enable TX/RX IQ and
+				   DC compensation mode */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xff,
-					0x03);
-			/* CR251, TX I/Q Imbalance Calibration */
+						   MESSAGE_REQUEST_BBREG,
+						   0xff,
+						   0x03);
+				/* CR251, TX I/Q Imbalance Calibration */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xfb,
-					byCalibTXIQ);
-			/* CR252, TX DC-Offset Calibration */
+						   MESSAGE_REQUEST_BBREG,
+						   0xfb,
+						   byCalibTXIQ);
+				/* CR252, TX DC-Offset Calibration */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xfC,
-					byCalibTXDC);
-			/* CR253, RX I/Q Imbalance Calibration */
+						   MESSAGE_REQUEST_BBREG,
+						   0xfC,
+						   byCalibTXDC);
+				/* CR253, RX I/Q Imbalance Calibration */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xfd,
-					byCalibRXIQ);
+						   MESSAGE_REQUEST_BBREG,
+						   0xfd,
+						   byCalibRXIQ);
 			} else {
-			/* CR255, turn off BB Calibration compensation */
+				/* CR255, turn off
+				   BB Calibration compensation */
 				vnt_control_out_u8(pDevice,
-					MESSAGE_REQUEST_BBREG,
-					0xff,
-					0x0);
+						   MESSAGE_REQUEST_BBREG,
+						   0xff,
+						   0x0);
 			}
 		}
 	}
-- 
1.9.3

