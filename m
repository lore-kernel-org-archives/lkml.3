Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab3GaNuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:50:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759650Ab3GaNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Barry Grussling" <barry@grussling.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.948041410@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [61/84] usb: cp210x support SEL C662 Vendor/Device
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Barry Grussling <barry@grussling.com>

commit b579fa52f6be0b4157ca9cc5e94d44a2c89a7e95 upstream.

This patch adds support for the Schweitzer Engineering Laboratories
C662 USB cable based off the CP210x driver.

Signed-off-by: Barry Grussling <barry@grussling.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -155,6 +155,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */

