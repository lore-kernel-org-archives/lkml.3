Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaE0Pg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:36:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59157 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0Pgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:36:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/15] staging: rtl8188eu:Remove unused function rtl8188eu_set_hw_type()
Date: Tue, 27 May 2014 21:05:46 +0530
Message-Id: <1401204955-4093-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    6 ------
 drivers/staging/rtl8188eu/include/usb_ops.h   |    1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index ca81530..3aadf56 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -682,9 +682,3 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_read_port_cancel = &usb_read_port_cancel;
 	pops->_write_port_cancel = &usb_write_port_cancel;
 }
-
-void rtl8188eu_set_hw_type(struct adapter *adapt)
-{
-	adapt->chip_type = RTL8188E;
-	DBG_88E("CHIP TYPE: RTL8188E\n");
-}
diff --git a/drivers/staging/rtl8188eu/include/usb_ops.h b/drivers/staging/rtl8188eu/include/usb_ops.h
index 7d33477..a290e0f 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops.h
@@ -63,7 +63,6 @@ enum{
 #include <usb_ops_linux.h>
 
 void rtl8188eu_set_hw_type(struct adapter *padapter);
-#define hal_set_hw_type rtl8188eu_set_hw_type
 void rtl8188eu_set_intf_ops(struct _io_ops *pops);
 #define usb_set_intf_ops rtl8188eu_set_intf_ops
 
-- 
1.7.10.4

