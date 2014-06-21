Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbaFUMug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:50:36 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57152 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934694AbaFUMuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:50:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/7] staging:rtl8188eu:usb_ops.h:Remove unused enum, macros and function declaration
Date: Sat, 21 Jun 2014 18:19:33 +0530
Message-Id: <1403354977-23644-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
References: <1403354977-23644-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_ops.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
index e10b711..74009ca 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops.h
@@ -27,13 +27,7 @@
 
 #define REALTEK_USB_VENQT_READ		0xC0
 #define REALTEK_USB_VENQT_WRITE		0x40
-#define REALTEK_USB_VENQT_CMD_REQ	0x05
-#define REALTEK_USB_VENQT_CMD_IDX	0x00
 
-enum{
-	VENDOR_WRITE = 0x00,
-	VENDOR_READ = 0x01,
-};
 #define ALIGNMENT_UNIT			16
 #define MAX_VENDOR_REQ_CMD_SIZE	254	/* 8188cu SIE Support */
 #define MAX_USB_IO_CTL_SIZE	(MAX_VENDOR_REQ_CMD_SIZE + ALIGNMENT_UNIT)
@@ -42,14 +36,9 @@ enum{
 			    value, index, data, size, timeout_ms)	\
 	usb_control_msg((dev), (pipe), (request), (requesttype), (value),\
 			(index), (data), (size), (timeout_ms))
-#define rtw_usb_bulk_msg(usb_dev, pipe, data, len, actual_length, timeout_ms) \
-	usb_bulk_msg((usb_dev), (pipe), (data), (len),			\
-		     (actual_length), (timeout_ms))
 
 #include <usb_ops_linux.h>
 
-void rtl8188eu_set_hw_type(struct adapter *padapter);
-
 /*
  * Increase and check if the continual_urb_error of this @param dvobjprivei
  * is larger than MAX_CONTINUAL_URB_ERR
-- 
1.7.10.4

