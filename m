Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbbA1UyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32996 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbbA1UyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:01 -0500
Date: Wed, 28 Jan 2015 12:00:22 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, tapaswenipathak@gmail.com,
        thomas@grouk.net, sudipm.mukherjee@gmail.com,
        rickard_strandqvist@spectrumdigital.se, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: remove useless printing line
Message-ID: <20150128100022.GA29018@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unneeded call to printk.

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
---
 drivers/staging/rtl8712/usb_intf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 7d0d171..f1fd7e8 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -366,7 +366,6 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	struct net_device *pnetdev;
 	struct usb_device *udev;
 
-	printk(KERN_INFO "r8712u: Staging version\n");
 	/* In this probe function, O.S. will provide the usb interface pointer
 	 * to driver. We have to increase the reference count of the usb device
 	 * structure by using the usb_get_dev function.
-- 
1.7.9.5

