Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3HZPMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:12:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39893 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab3HZPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:12:00 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/24] Staging: winbond: wbusb: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:22 +0200
Message-Id: <1377529823-5116-24-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some lines over 80 characters.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wbusb.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3fa1ae4..c128bc9 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -169,7 +169,8 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
 	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
 }
 
-static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
+static void hal_set_current_channel_ex(struct hw_data *pHwData,
+					       struct chan_info channel)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
@@ -186,7 +187,8 @@ static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info
 				       sizeof(struct chan_info));
 }
 
-static void hal_set_current_channel(struct hw_data *pHwData, struct chan_info channel)
+static void hal_set_current_channel(struct hw_data *pHwData,
+					    struct chan_info channel)
 {
 	hal_set_current_channel_ex(pHwData, channel);
 }
@@ -206,7 +208,9 @@ static void hal_set_accept_broadcast(struct hw_data *pHwData, u8 enable)
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
 
-/* For wep key error detection, we need to accept broadcast packets to be received temporary. */
+/* For wep key error detection, we need to accept broadcast packets to be
+ * received temporary.
+*/
 static void hal_set_accept_promiscuous(struct hw_data *pHwData, u8 enable)
 {
 	struct wb35_reg *reg = &pHwData->reg;
@@ -290,7 +294,8 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.get_tsf		= wbsoft_get_tsf,
 };
 
-static void hal_set_ethernet_address(struct hw_data *pHwData, u8 *current_address)
+static void hal_set_ethernet_address(struct hw_data *pHwData,
+					     u8 *current_address)
 {
 	u32 ltmp[2];
 
@@ -305,7 +310,8 @@ static void hal_set_ethernet_address(struct hw_data *pHwData, u8 *current_addres
 	Wb35Reg_BurstWrite(pHwData, 0x03e8, ltmp, 2, AUTO_INCREMENT);
 }
 
-static void hal_get_permanent_address(struct hw_data *pHwData, u8 *pethernet_address)
+static void hal_get_permanent_address(struct hw_data *pHwData,
+					      u8 *pethernet_address)
 {
 	if (pHwData->SurpriseRemove)
 		return;
-- 
1.8.1.2

