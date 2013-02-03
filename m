Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3BCOzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34103 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684Ab3BCOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:00 -0500
Message-Id: <20130203144645.815424964@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Thomas Hartmann <hartmann@ict.tuwien.ac.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 020/128] staging: r8712u: Add new device ID
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit da849a92d3bafaf24d770e971c2c9e5c3f60b5d1 upstream.

The ISY IWL 1000 USB WLAN stick with USB ID 050d:11f1 is a clone of
the Belkin F7D1101 V1 device.

Reported-by: Thomas Hartmann <hartmann@ict.tuwien.ac.at>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thomas Hartmann <hartmann@ict.tuwien.ac.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rtl8712/usb_intf.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 6b73843..a96cd06 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -63,6 +63,8 @@ static struct usb_device_id rtl871x_usb_id_tbl[] = {
 	{USB_DEVICE(0x0B05, 0x1791)}, /* 11n mode disable */
 	/* Belkin */
 	{USB_DEVICE(0x050D, 0x945A)},
+	/* ISY IWL - Belkin clone */
+	{USB_DEVICE(0x050D, 0x11F1)},
 	/* Corega */
 	{USB_DEVICE(0x07AA, 0x0047)},
 	/* D-Link */


