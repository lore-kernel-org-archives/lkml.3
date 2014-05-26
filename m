Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaEZQGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:07 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61568 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaEZQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/24] staging: rtl8188eu: Remove unused function rtw_hal_intf_ps_func()
Date: Mon, 26 May 2014 21:35:17 +0530
Message-Id: <1401120339-23667-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c     |    9 ---------
 drivers/staging/rtl8188eu/include/hal_intf.h |    3 ---
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index d75ca7a..43eee48 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -207,15 +207,6 @@ u32 rtw_hal_inirp_deinit(struct adapter *adapt)
 	return _FAIL;
 }
 
-u8 rtw_hal_intf_ps_func(struct adapter *adapt,
-			enum hal_intf_ps_func efunc_id, u8 *val)
-{
-	if (adapt->HalFunc.interface_ps_func)
-		return adapt->HalFunc.interface_ps_func(adapt, efunc_id,
-							   val);
-	return _FAIL;
-}
-
 s32 rtw_hal_xmit(struct adapter *adapt, struct xmit_frame *pxmitframe)
 {
 	if (adapt->HalFunc.hal_xmit)
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index c274b34..9228bc6 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -332,9 +332,6 @@ void rtw_hal_disable_interrupt(struct adapter *padapter);
 u32	rtw_hal_inirp_init(struct adapter *padapter);
 u32	rtw_hal_inirp_deinit(struct adapter *padapter);
 
-u8	rtw_hal_intf_ps_func(struct adapter *padapter,
-			     enum hal_intf_ps_func efunc_id, u8 *val);
-
 s32	rtw_hal_xmit(struct adapter *padapter, struct xmit_frame *pxmitframe);
 s32	rtw_hal_mgnt_xmit(struct adapter *padapter,
 			  struct xmit_frame *pmgntframe);
-- 
1.7.10.4

