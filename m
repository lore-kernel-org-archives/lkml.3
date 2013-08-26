Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3HZPLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:37 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47179 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab3HZPLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:34 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/24] Staging: winbond: reg: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:10 +0200
Message-Id: <1377529823-5116-12-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 300038a..0cb0798 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1093,15 +1093,18 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		Wb35Reg_WriteSync(pHwData, 0x1050, pHwData->reg.BB50);
 		usleep(5000);
 
-		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01B0, 20);
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24)
+			       | BitReverse((0x0F << 20) | 0xF01B0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(5000);
 
-		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01E0, 20);
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24)
+			       | BitReverse((0x0F << 20) | 0xF01E0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(5000);
 
-		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01A0, 20);
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24)
+			       | BitReverse((0x0F << 20) | 0xF01A0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		Wb35Reg_WriteSync(pHwData, 0x105c, pHwData->reg.BB5C);
@@ -1159,30 +1162,37 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 
 		/* ----- Calibration (1). VCO frequency calibration */
 		/* Calibration (1a.0). Synthesizer reset */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x0F<<24) | 0x00101E, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x0F<<24) | 0x00101E, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(5000);
 		/* Calibration (1a). VCO frequency calibration mode ; waiting 2msec VCO calibration time */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFE69c0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFE69c0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(2000);
 
 		/* ----- Calibration (2). TX baseband Gm-C filter auto-tuning */
 		/* Calibration (2a). turn off ENCAL signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xF8EBC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xF8EBC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (2b.0). TX filter auto-tuning BW: TFLBW=101 (TC5376A default) */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x07<<24) | 0x0C68CE, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x07<<24) | 0x0C68CE, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (2b). send TX reset signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x0F<<24) | 0x00201E, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x0F<<24) | 0x00201E, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (2c). turn-on TX Gm-C filter auto-tuning */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFCEBC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFCEBC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		udelay(150); /* Sleep 150 us */
 		/* turn off ENCAL signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xF8EBC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xF8EBC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		/* ----- Calibration (3). RX baseband Gm-C filter auto-tuning */
-- 
1.8.1.2

