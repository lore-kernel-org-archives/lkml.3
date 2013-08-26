Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3HZPOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:14:03 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39464 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab3HZPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:41 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/24] Staging: winbond: reg: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:13 +0200
Message-Id: <1377529823-5116-15-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sixth of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index b05f9bd..50ca7dd 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1738,7 +1738,8 @@ static void set_tx_power_per_channel_wb242(struct hw_data *pHwData,
  *   None.
  * ===========================================================================
  */
-void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info Channel)
+void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,
+					   struct chan_info Channel)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	u32	pltmp[16]; /* The 16 is the maximum capability of hardware */
@@ -1891,9 +1892,9 @@ void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info C
 		/* BB: select 5 GHz */
 		reg->BB50 &= ~(BIT(11) | BIT(12));
 		if (Channel.ChanNo <= 64)
-			reg->BB50 |= BIT(12);				/* 10-5.25GHz */
+			reg->BB50 |= BIT(12);			/* 10-5.25GHz */
 		else if ((Channel.ChanNo >= 100) && (Channel.ChanNo <= 124))
-			reg->BB50 |= BIT(11);				/* 01-5.48GHz */
+			reg->BB50 |= BIT(11);			/* 01-5.48GHz */
 		else if ((Channel.ChanNo >= 128) && (Channel.ChanNo <= 161))
 			reg->BB50 |= (BIT(12) | BIT(11));	/* 11-5.775GHz */
 		else	/* Chan 184 ~ 196 will use bit[12-11] = 10 in version sh-src-1.2.25 */
@@ -1968,7 +1969,8 @@ u8 RFSynthesizer_SetMaxim2828_24Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	if (index > 1)
 		index = 1;
-	PowerData = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2828_power_data_24[index], 18);
+	PowerData = (1 << 31) | (0 << 30) | (18 << 24)
+			    | BitReverse(max2828_power_data_24[index], 18);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return index;
 }
@@ -1978,7 +1980,8 @@ u8 RFSynthesizer_SetMaxim2828_50Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	if (index > 1)
 		index = 1;
-	PowerData = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2828_power_data_50[index], 18);
+	PowerData = (1 << 31) | (0 << 30) | (18 << 24)
+			    | BitReverse(max2828_power_data_50[index], 18);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return index;
 }
@@ -1988,7 +1991,8 @@ u8 RFSynthesizer_SetMaxim2827_24Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	if (index > 1)
 		index = 1;
-	PowerData = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2827_power_data_24[index], 18);
+	PowerData = (1 << 31) | (0 << 30) | (18 << 24)
+			    | BitReverse(max2827_power_data_24[index], 18);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return index;
 }
@@ -1998,7 +2002,8 @@ u8 RFSynthesizer_SetMaxim2827_50Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	if (index > 1)
 		index = 1;
-	PowerData = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2827_power_data_50[index], 18);
+	PowerData = (1 << 31) | (0 << 30) | (18 << 24)
+			    | BitReverse(max2827_power_data_50[index], 18);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return index;
 }
@@ -2008,7 +2013,8 @@ u8 RFSynthesizer_SetMaxim2825Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	if (index > 1)
 		index = 1;
-	PowerData = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2825_power_data_24[index], 18);
+	PowerData = (1 << 31) | (0 << 30) | (18 << 24)
+			    | BitReverse(max2825_power_data_24[index], 18);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return index;
 }
@@ -2026,7 +2032,8 @@ u8 RFSynthesizer_SetAiroha2230Power(struct hw_data *pHwData, u8 index)
 	if (i == count)
 		i--;
 
-	PowerData = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230_txvga_data[i][0], 20);
+	PowerData = (1 << 31) | (0 << 30) | (20 << 24)
+			    | BitReverse(al2230_txvga_data[i][0], 20);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return i;
 }
@@ -2043,7 +2050,8 @@ u8 RFSynthesizer_SetAiroha7230Power(struct hw_data *pHwData, u8 index)
 	}
 	if (i == count)
 		i--;
-	PowerData = (1 << 31) | (0 << 30) | (24 << 24) | (al7230_txvga_data[i][0] & 0xffffff);
+	PowerData = (1 << 31) | (0 << 30) | (24 << 24)
+			    | (al7230_txvga_data[i][0] & 0xffffff);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 	return i;
 }
-- 
1.8.1.2

