Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405Ab3AOW51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:57:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:48462 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934145Ab3AOW5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Hartmann <hartmann@ict.tuwien.ac.at>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 51/71] staging: r8712u: Add new device ID
Date: Tue, 15 Jan 2013 14:54:48 -0800
Message-Id: <20130115225344.079603892@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit da849a92d3bafaf24d770e971c2c9e5c3f60b5d1 upstream.

The ISY IWL 1000 USB WLAN stick with USB ID 050d:11f1 is a clone of
the Belkin F7D1101 V1 device.

Reported-by: Thomas Hartmann <hartmann@ict.tuwien.ac.at>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thomas Hartmann <hartmann@ict.tuwien.ac.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/usb_intf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -62,6 +62,8 @@ static struct usb_device_id rtl871x_usb_
 	{USB_DEVICE(0x0B05, 0x1791)}, /* 11n mode disable */
 	/* Belkin */
 	{USB_DEVICE(0x050D, 0x945A)},
+	/* ISY IWL - Belkin clone */
+	{USB_DEVICE(0x050D, 0x11F1)},
 	/* Corega */
 	{USB_DEVICE(0x07AA, 0x0047)},
 	/* D-Link */


