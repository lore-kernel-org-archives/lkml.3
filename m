Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3IPNrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:47:37 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61295 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3IPNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:20 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/24] Staging: winbond: reg: fourth of the patches that fixes lines over 80 characters
Date: Mon, 16 Sep 2013 15:43:32 +0200
Message-Id: <1379339024-12157-13-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fourth of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 6aae4da..6d2ab1e 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1187,46 +1187,57 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 
 		/* ----- Calibration (3). RX baseband Gm-C filter auto-tuning */
 		/* Calibration (3a). turn off ENCAL signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (3b.0). RX filter auto-tuning BW: RFLBW=100 (TC5376A+corner default;) */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x07<<24) | 0x0C68CE, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x07<<24) | 0x0C68CE, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (3b). send RX reset signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x0F<<24) | 0x00401E, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x0F<<24) | 0x00401E, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (3c). turn-on RX Gm-C filter auto-tuning */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFEEDC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFEEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		udelay(150); /* Sleep 150 us */
 		/* Calibration (3e). turn off ENCAL signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		/* ----- Calibration (4). TX LO leakage calibration */
 		/* Calibration (4a). TX LO leakage calibration */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFD6BC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFD6BC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		udelay(150); /* Sleep 150 us */
 
 		/* ----- Calibration (5). RX DC offset calibration */
 		/* Calibration (5a). turn off ENCAL signal and set to RX SW DC calibration mode */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (5b). turn off AGC servo-loop & RSSI */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x01<<24) | 0xEBFFC2, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x01<<24) | 0xEBFFC2, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		/* for LNA=11 -------- */
 		/* Calibration (5c-h). RX DC offset current bias ON; & LNA=11; RXVGA=111111 */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x06<<24) | 0x343FCC, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x06<<24) | 0x343FCC, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		/* Calibration (5d). turn on RX DC offset cal function; and waiting 2 msec cal time */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFF6DC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFF6DC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(2000);
 		/* Calibration (5f). turn off ENCAL signal */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		/* for LNA=10 -------- */
-- 
1.8.1.2

