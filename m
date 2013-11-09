Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3KIGuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:50:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3KIGt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:49:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 3.4 03/26] USB: quirks: add touchscreen that is dazzeled by remote wakeup
Date: Fri,  8 Nov 2013 22:51:32 -0800
Message-Id: <20131109065050.463937368@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065050.089866597@linuxfoundation.org>
References: <20131109065050.089866597@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 614ced91fc6fbb5a1cdd12f0f1b6c9197d9f1350 upstream.

The device descriptors are messed up after remote wakeup

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -119,6 +119,9 @@ static const struct usb_device_id usb_qu
 	/* Alcor Micro Corp. Hub */
 	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* MicroTouch Systems touchscreen */
+	{ USB_DEVICE(0x0596, 0x051e), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 


