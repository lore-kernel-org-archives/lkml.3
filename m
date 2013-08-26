Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3HZPLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:42 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41311 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3HZPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:38 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/24] Staging: winbond: reg: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:12 +0200
Message-Id: <1377529823-5116-14-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fifth of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index acdc003..b05f9bd 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1252,46 +1252,57 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 
 		/* for LNA=10 -------- */
 		/* Calibration (5c-m). RX DC offset current bias ON; & LNA=10; RXVGA=111111 */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x06<<24) | 0x342FCC, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x06<<24) | 0x342FCC, 24);
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
 
 		/* for LNA=01 -------- */
 		/* Calibration (5c-m). RX DC offset current bias ON; & LNA=01; RXVGA=111111 */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x06<<24) | 0x341FCC, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x06<<24) | 0x341FCC, 24);
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
 
 		/* for LNA=00 -------- */
 		/* Calibration (5c-l). RX DC offset current bias ON; & LNA=00; RXVGA=111111 */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x06<<24) | 0x340FCC, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x06<<24) | 0x340FCC, 24);
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
 		/* Calibration (5g). turn on AGC servo-loop */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x01<<24) | 0xEFFFC2, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x01<<24) | 0xEFFFC2, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		/* ----- Calibration (7). Switch RF chip to normal mode */
 		/* 0x00 0xF86100 ; 3E184   ; Switch RF chip to normal mode */
-		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xF86100, 24);
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24)
+			       | BitReverse((0x00<<24) | 0xF86100, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(5000);
 		break;
-- 
1.8.1.2

