Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3HZPP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:15:27 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37618 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3HZPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:32 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/24] Staging: winbond: reg: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:09 +0200
Message-Id: <1377529823-5116-11-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index b1d977a..300038a 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -974,42 +974,48 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		number = ARRAY_SIZE(max2825_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2825_rf_data[i]; /* Backup Rf parameter */
-			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2825_rf_data[i], 18);
+			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24)
+					   | BitReverse(max2825_rf_data[i], 18);
 		}
 		break;
 	case RF_MAXIM_2827:
 		number = ARRAY_SIZE(max2827_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2827_rf_data[i];
-			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2827_rf_data[i], 18);
+			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24)
+					   | BitReverse(max2827_rf_data[i], 18);
 		}
 		break;
 	case RF_MAXIM_2828:
 		number = ARRAY_SIZE(max2828_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2828_rf_data[i];
-			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2828_rf_data[i], 18);
+			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24)
+					   | BitReverse(max2828_rf_data[i], 18);
 		}
 		break;
 	case RF_MAXIM_2829:
 		number = ARRAY_SIZE(max2829_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2829_rf_data[i];
-			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2829_rf_data[i], 18);
+			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24)
+					   | BitReverse(max2829_rf_data[i], 18);
 		}
 		break;
 	case RF_AIROHA_2230:
 		number = ARRAY_SIZE(al2230_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = al2230_rf_data[i];
-			pltmp[i] = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230_rf_data[i], 20);
+			pltmp[i] = (1 << 31) | (0 << 30) | (20 << 24)
+					   | BitReverse(al2230_rf_data[i], 20);
 		}
 		break;
 	case RF_AIROHA_2230S:
 		number = ARRAY_SIZE(al2230s_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = al2230s_rf_data[i];
-			pltmp[i] = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230s_rf_data[i], 20);
+			pltmp[i] = (1 << 31) | (0 << 30) | (20 << 24)
+					   | BitReverse(al2230s_rf_data[i], 20);
 		}
 		break;
 	case RF_AIROHA_7230:
@@ -1030,7 +1036,8 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 			}
 
 			pHwData->phy_para[i] = ltmp;
-			pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(ltmp, 24);
+			pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24)
+					   | BitReverse(ltmp, 24);
 		}
 		break;
 	}
@@ -1057,10 +1064,12 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 
 	switch (pHwData->phy_type) {
 	case RF_AIROHA_2230:
-		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x07 << 20) | 0xE168E, 20);
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24)
+			       | BitReverse((0x07 << 20) | 0xE168E, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(10000);
-		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230_rf_data[7], 20);
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24)
+			       | BitReverse(al2230_rf_data[7], 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 		usleep(10000);
 	case RF_AIROHA_2230S:
@@ -1074,7 +1083,8 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* ========================================================= */
 
 		/* The follow code doesn't use the burst-write mode */
-		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F<<20) | 0xF01A0, 20);
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24)
+			       | BitReverse((0x0F<<20) | 0xF01A0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 
 		ltmp = pHwData->reg.BB5C & 0xfffff000;
-- 
1.8.1.2

