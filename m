Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3IPNrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:47:12 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46944 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3IPNoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:25 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/24] Staging: winbond: reg: seventh of the patches that fixes lines over 80 characters
Date: Mon, 16 Sep 2013 15:43:35 +0200
Message-Id: <1379339024-12157-16-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seventh of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index e51530e..3b19da8 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -2060,7 +2060,8 @@ u8 RFSynthesizer_SetWinbond242Power(struct hw_data *pHwData, u8 index)
 		i--;
 
 	/* Set TxVga into RF */
-	PowerData = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(w89rf242_txvga_data[i][0], 24);
+	PowerData = (1 << 31) | (0 << 30) | (24 << 24)
+			    | BitReverse(w89rf242_txvga_data[i][0], 24);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 
 	/* Update BB48 BB4C BB58 for high precision txvga */
@@ -2136,11 +2137,15 @@ void Mxx_initial(struct hw_data *pHwData)
 	pltmp[4] = tmp;
 
 	/* M38 */
-	reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) | (DEFAULT_LONG_RETRY_LIMIT << 4) | DEFAULT_SHORT_RETRY_LIMIT;
+	reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
+				       (DEFAULT_LONG_RETRY_LIMIT << 4) |
+				       DEFAULT_SHORT_RETRY_LIMIT;
 	pltmp[5] = reg->M38_MacControl;
 
 	/* M3C */
-	tmp = (DEFAULT_PIFST << 26) | (DEFAULT_EIFST << 16) | (DEFAULT_DIFST << 8) | (DEFAULT_SIFST << 4) | DEFAULT_OSIFST;
+	tmp = (DEFAULT_PIFST << 26) | (DEFAULT_EIFST << 16) |
+		       (DEFAULT_DIFST << 8) | (DEFAULT_SIFST << 4) |
+		       DEFAULT_OSIFST;
 	reg->M3C_MacControl = tmp;
 	pltmp[6] = tmp;
 
@@ -2163,7 +2168,9 @@ void Mxx_initial(struct hw_data *pHwData)
 	pltmp[9] = tmp;
 
 	/* M4C */
-	reg->M4C_MacStatus = (DEFAULT_PROTOCOL_VERSION << 30) | (DEFAULT_MAC_POWER_STATE << 28) | (DEFAULT_DTIM_ALERT_TIME << 24);
+	reg->M4C_MacStatus = (DEFAULT_PROTOCOL_VERSION << 30) |
+				      (DEFAULT_MAC_POWER_STATE << 28) |
+				      (DEFAULT_DTIM_ALERT_TIME << 24);
 	pltmp[10] = reg->M4C_MacStatus;
 
 	for (i = 0; i < 11; i++)
@@ -2235,10 +2242,11 @@ void GetTxVgaFromEEPROM(struct hw_data *pHwData)
 }
 
 /*
- * This function will affect the TxVga parameter in HAL. If hal_set_current_channel
- * or RFSynthesizer_SetPowerIndex be called, new TxVga will take effect.
- * TxVgaSettingInEEPROM of sHwData is an u8 array point to EEPROM contain for IS89C35
- * This function will use default TxVgaSettingInEEPROM data to calculate new TxVga.
+ * This function will affect the TxVga parameter in HAL. If
+ * hal_set_current_channel or RFSynthesizer_SetPowerIndex be called, new TxVga
+ * will take effect. TxVgaSettingInEEPROM of sHwData is an u8 array point to
+ * EEPROM contain for IS89C35. This function will use default
+ * TxVgaSettingInEEPROM data to calculate new TxVga.
  */
 void EEPROMTxVgaAdjust(struct hw_data *pHwData)
 {
-- 
1.8.1.2

