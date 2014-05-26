Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaEZQGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:20 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52883 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaEZQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:17 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/24] staging: rtl8188eu: Remove unused function rtl8188eu_ps_func()
Date: Mon, 26 May 2014 21:35:19 +0530
Message-Id: <1401120339-23667-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 9020129..141f85a 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -2226,12 +2226,6 @@ static void rtl8188eu_init_default_value(struct adapter *adapt)
 		haldata->odmpriv.RFCalibrateInfo.ThermalValue_HP[i] = 0;
 }
 
-static u8 rtl8188eu_ps_func(struct adapter *Adapter, enum hal_intf_ps_func efunc_id, u8 *val)
-{
-	u8 bResult = true;
-	return bResult;
-}
-
 void rtl8188eu_set_hal_ops(struct adapter *adapt)
 {
 	struct hal_ops	*halfunc = &adapt->HalFunc;
-- 
1.7.10.4

