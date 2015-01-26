Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbbAZMwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:52:39 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61512 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:52:35 -0500
Date: Mon, 26 Jan 2015 14:52:29 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, tapaswenipathak@gmail.com,
        thomas@grouk.net, sudipm.mukherjee@gmail.com,
        rickard_strandqvist@spectrumdigital.se, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8712: fix Prefer [subsystem eg:
 netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to
 printk(KERN_INFO ...
Message-ID: <20150126125229.GA11609@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
fix Prefer [subsystem eg: netdev]_info([subsystem]dev,
... then dev_info(dev, ... then pr_info(...  to
printk(KERN_INFO ...

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
v2: changed netdev_info to pr_info

 drivers/staging/rtl8712/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 7d0d171..15f0d42 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -366,7 +366,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	struct net_device *pnetdev;
 	struct usb_device *udev;
 
-	printk(KERN_INFO "r8712u: Staging version\n");
+	pr_info("r8712u: Staging version\n");
 	/* In this probe function, O.S. will provide the usb interface pointer
 	 * to driver. We have to increase the reference count of the usb device
 	 * structure by using the usb_get_dev function.
-- 
1.7.9.5

