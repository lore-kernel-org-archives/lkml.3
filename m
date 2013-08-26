Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3HZPLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:47 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38862 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab3HZPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:44 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/24] Staging: winbond: wb35reg_f: fixed lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:15 +0200
Message-Id: <1377529823-5116-17-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed lines over 80 characters.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35reg_f.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index 95dc980..cd6710c 100644
--- a/drivers/staging/winbond/wb35reg_f.h
+++ b/drivers/staging/winbond/wb35reg_f.h
@@ -15,7 +15,8 @@ void Uxx_ReadEthernetAddress(struct hw_data *hw_data);
 void Dxx_initial(struct hw_data *hw_data);
 void Mxx_initial(struct hw_data *hw_data);
 void RFSynthesizer_initial(struct hw_data *hw_data);
-void RFSynthesizer_SwitchingChannel(struct hw_data *hw_data, struct chan_info channel);
+void RFSynthesizer_SwitchingChannel(struct hw_data *hw_data,
+					   struct chan_info channel);
 void BBProcessor_initial(struct hw_data *hw_data);
 void BBProcessor_RateChanging(struct hw_data *hw_data, u8 rate);
 u8 RFSynthesizer_SetPowerIndex(struct hw_data *hw_data, u8 power_index);
@@ -34,10 +35,14 @@ void EEPROMTxVgaAdjust(struct hw_data *hw_data);
 
 void Wb35Reg_destroy(struct hw_data *hw_data);
 
-unsigned char Wb35Reg_Read(struct hw_data *hw_data, u16 register_no, u32 *register_value);
-unsigned char Wb35Reg_ReadSync(struct hw_data *hw_data, u16 register_no, u32 *register_value);
-unsigned char Wb35Reg_Write(struct hw_data *hw_data, u16 register_no, u32 register_value);
-unsigned char Wb35Reg_WriteSync(struct hw_data *hw_data, u16 register_no, u32 register_value);
+unsigned char Wb35Reg_Read(struct hw_data *hw_data, u16 register_no,
+				   u32 *register_value);
+unsigned char Wb35Reg_ReadSync(struct hw_data *hw_data, u16 register_no,
+				   u32 *register_value);
+unsigned char Wb35Reg_Write(struct hw_data *hw_data, u16 register_no,
+				   u32 register_value);
+unsigned char Wb35Reg_WriteSync(struct hw_data *hw_data, u16 register_no,
+				   u32 register_value);
 unsigned char Wb35Reg_WriteWithCallbackValue(struct hw_data *hw_data,
 							 u16 register_no,
 							 u32 register_value,
@@ -59,7 +64,8 @@ void CardGetMulticastBit(u8 address[MAC_ADDR_LENGTH], u8 *byte, u8 *value);
 u32 CardComputeCrc(u8 *buffer, u32 length);
 
 void Wb35Reg_phy_calibration(struct hw_data *hw_data);
-void Wb35Reg_Update(struct hw_data *hw_data, u16 register_no, u32 register_value);
+void Wb35Reg_Update(struct hw_data *hw_data, u16 register_no,
+			   u32 register_value);
 unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *hw_data);
 
 #endif
-- 
1.8.1.2

