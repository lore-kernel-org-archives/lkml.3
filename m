Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3CREou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:44:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab3CREad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:33 -0400
Message-Id: <20130318042150.238022565@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Steve Conklin <sconklin@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 62/82] usb: serial: Add Rigblaster Advantage to device table
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Conklin <sconklin@canonical.com>

commit a57e82a18779ab8a5e5a1f5841cef937cf578913 upstream.

The Rigblaster Advantage is an amateur radio interface sold by West Mountain
Radio. It contains a cp210x serial interface but the device ID is not in
the driver.

Signed-off-by: Steve Conklin <sconklin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -91,6 +91,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x2405, 0x0003) }, /* West Mountain Radio RIGblaster Advantage */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0x815F) }, /* Timewave HamLinkUSB */


