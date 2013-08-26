Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3HZPL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:26 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49656 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab3HZPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:24 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/24] Staging: winbond: reg: erased trailing whitespace
Date: Mon, 26 Aug 2013 17:10:05 +0200
Message-Id: <1377529823-5116-7-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erased all the errors given by checkpatch stating trailing whitespace.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 75b7752..5883d23 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -920,7 +920,7 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
 	Wb35Reg_WriteSync(pHwData, 0x03f8, 0x7ff);
 }
 
-static void Set_ChanIndep_RfData_al7230_24(struct hw_data *pHwData, u32 *pltmp, 
+static void Set_ChanIndep_RfData_al7230_24(struct hw_data *pHwData, u32 *pltmp,
 					char number)
 {
 	u8	i;
@@ -930,7 +930,7 @@ static void Set_ChanIndep_RfData_al7230_24(struct hw_data *pHwData, u32 *pltmp,
 	}
 }
 
-static void Set_ChanIndep_RfData_al7230_50(struct hw_data *pHwData, u32 *pltmp, 
+static void Set_ChanIndep_RfData_al7230_50(struct hw_data *pHwData, u32 *pltmp,
 					char number)
 {
 	u8	i;
@@ -1620,13 +1620,13 @@ void BBProcessor_initial(struct hw_data *pHwData)
 		reg->SQ3_filter[i] = 0x2f; /* half of Bit 0 ~ 6 */
 }
 
-static inline void set_tx_power_per_channel_max2829(struct hw_data *pHwData,  
+static inline void set_tx_power_per_channel_max2829(struct hw_data *pHwData,
 						struct chan_info Channel)
 {
 	RFSynthesizer_SetPowerIndex(pHwData, 100);
 }
 
-static void set_tx_power_per_channel_al2230(struct hw_data *pHwData,  
+static void set_tx_power_per_channel_al2230(struct hw_data *pHwData,
 					struct chan_info Channel)
 {
 	u8	index = 100;
@@ -1636,7 +1636,7 @@ static void set_tx_power_per_channel_al2230(struct hw_data *pHwData,
 	RFSynthesizer_SetPowerIndex(pHwData, index);
 }
 
-static void set_tx_power_per_channel_al7230(struct hw_data *pHwData,  
+static void set_tx_power_per_channel_al7230(struct hw_data *pHwData,
 					struct chan_info Channel)
 {
 	u8	i, index = 100;
@@ -1660,7 +1660,7 @@ static void set_tx_power_per_channel_al7230(struct hw_data *pHwData,
 	RFSynthesizer_SetPowerIndex(pHwData, index);
 }
 
-static void set_tx_power_per_channel_wb242(struct hw_data *pHwData,  
+static void set_tx_power_per_channel_wb242(struct hw_data *pHwData,
 					struct chan_info Channel)
 {
 	u8	index = 100;
-- 
1.8.1.2

