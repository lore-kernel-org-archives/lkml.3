Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaE0Pgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:36:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0Pgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:36:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/15] staging: rtl8188eu:Remove unused function chip_by_usb_id()
Date: Tue, 27 May 2014 21:05:45 +0530
Message-Id: <1401204955-4093-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index fbf967d..1e62713 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -219,13 +219,6 @@ static void usb_dvobj_deinit(struct usb_interface *usb_intf)
 
 }
 
-static void chip_by_usb_id(struct adapter *padapter,
-			   const struct usb_device_id *pdid)
-{
-	padapter->chip_type = NULL_CHIP_TYPE;
-	hal_set_hw_type(padapter);
-}
-
 static void usb_intf_start(struct adapter *padapter)
 {
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+usb_intf_start\n"));
-- 
1.7.10.4

