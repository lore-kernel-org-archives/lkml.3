Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3CRWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:03:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3CRVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Conklin <sconklin@canonical.com>
Subject: [ 10/75] usb: serial: Add Rigblaster Advantage to device table
Date: Mon, 18 Mar 2013 14:06:33 -0700
Message-Id: <20130318210510.997507513@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Conklin <sconklin@canonical.com>

commit a57e82a18779ab8a5e5a1f5841cef937cf578913 upstream.

The Rigblaster Advantage is an amateur radio interface sold by West Mountain
Radio. It contains a cp210x serial interface but the device ID is not in
the driver.

Signed-off-by: Steve Conklin <sconklin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -85,6 +85,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x2405, 0x0003) }, /* West Mountain Radio RIGblaster Advantage */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0x815F) }, /* Timewave HamLinkUSB */


