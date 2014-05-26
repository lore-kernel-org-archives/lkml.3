Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaEZQGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:14 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60370 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaEZQGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:11 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/24] staging: rtl8188eu: Remove unused function pointer ->interface_ps_func
Date: Mon, 26 May 2014 21:35:18 +0530
Message-Id: <1401120339-23667-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_halinit.c  |    2 --
 drivers/staging/rtl8188eu/include/hal_intf.h |    3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 0cb84ae..9020129 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -2272,7 +2272,5 @@ void rtl8188eu_set_hal_ops(struct adapter *adapt)
 	halfunc->hal_xmit = &rtl8188eu_hal_xmit;
 	halfunc->mgnt_xmit = &rtl8188eu_mgnt_xmit;
 
-	halfunc->interface_ps_func = &rtl8188eu_ps_func;
-
 	rtl8188e_set_hal_ops(halfunc);
 }
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 9228bc6..acdef1d 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -218,9 +218,6 @@ struct hal_ops {
 	void	(*AntDivCompareHandler)(struct adapter *adapter,
 					struct wlan_bssid_ex *dst,
 					struct wlan_bssid_ex *src);
-	u8	(*interface_ps_func)(struct adapter *padapter,
-				     enum hal_intf_ps_func efunc_id, u8 *val);
-
 	s32	(*hal_xmit)(struct adapter *padapter,
 			    struct xmit_frame *pxmitframe);
 	s32 (*mgnt_xmit)(struct adapter *padapter,
-- 
1.7.10.4

