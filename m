Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaCaNY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:58 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:50778 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbaCaNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:53 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2014 09:24:53 EDT
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: khoroshilov@ispras.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wlan-ng fix small coding style issue
Date: Mon, 31 Mar 2014 15:13:23 +0200
Message-Id: <1396271603-12142-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/prism2usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 4739c14..ccb2c2e 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -293,6 +293,7 @@ static int prism2sta_suspend(struct usb_interface *interface,
 	hfa384x_t *hw = NULL;
 	wlandevice_t *wlandev;
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
+
 	if (!wlandev)
 		return -ENODEV;
 
@@ -315,6 +316,7 @@ static int prism2sta_resume(struct usb_interface *interface)
 	hfa384x_t *hw = NULL;
 	wlandevice_t *wlandev;
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
+
 	if (!wlandev)
 		return -ENODEV;
 
-- 
1.9.0

