Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaERPUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:20:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51697 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaERPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:20:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/28] staging: rtl8188eu: Remove function with empty definition _InitOperationMode()
Date: Sun, 18 May 2014 20:48:55 +0530
Message-Id: <1400426361-19596-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 9ce6173..2e7b81ce 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -583,10 +583,6 @@ static void InitUsbAggregationSetting(struct adapter *Adapter)
 	haldata->UsbRxHighSpeedMode = false;
 }
 
-static void _InitOperationMode(struct adapter *Adapter)
-{
-}
-
 static void _InitBeaconParameters(struct adapter *Adapter)
 {
 	struct hal_data_8188e	*haldata = GET_HAL_DATA(Adapter);
@@ -824,7 +820,6 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	_InitEDCA(Adapter);
 	_InitRetryFunction(Adapter);
 	InitUsbAggregationSetting(Adapter);
-	_InitOperationMode(Adapter);/* todo */
 	_InitBeaconParameters(Adapter);
 	/*  Init CR MACTXEN, MACRXEN after setting RxFF boundary REG_TRXFF_BNDY to patch */
 	/*  Hw bug which Hw initials RxFF boundary size to a value which is larger than the real Rx buffer size in 88E. */
-- 
1.7.10.4

