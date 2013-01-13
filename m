Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3AMR5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:57:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34941 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab3AMRpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:23 -0500
Message-Id: <20130113174258.536486196@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 13/49] p54usb: add USBIDs for two more p54usb devices
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 4010fe21a315b4223c25376714c6a2b61b722e5c upstream.

This patch adds USBIDs for:
	- DrayTek Vigor 530
	- Zoom 4410a

It also adds a note about Gemtek WUBI-100GW
and SparkLAN WL-682 USBID conflict [WUBI-100GW
is a ISL3886+NET2280 (LM86 firmare) solution,
whereas WL-682 is a ISL3887 (LM87 firmware)]
device.

Source: <http://www.wikidevi.com/wiki/Intersil/p54/usb/windows>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/p54/p54usb.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 64b944b..800a165 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -47,6 +47,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x0411, 0x0050)},	/* Buffalo WLI2-USB2-G54 */
 	{USB_DEVICE(0x045e, 0x00c2)},	/* Microsoft MN-710 */
 	{USB_DEVICE(0x0506, 0x0a11)},	/* 3COM 3CRWE254G72 */
+	{USB_DEVICE(0x0675, 0x0530)},	/* DrayTek Vigor 530 */
 	{USB_DEVICE(0x06b9, 0x0120)},	/* Thomson SpeedTouch 120g */
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
 	{USB_DEVICE(0x07aa, 0x001c)},	/* Corega CG-WLUSB2GT */
@@ -82,6 +83,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
 	{USB_DEVICE(0x083a, 0x4503)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
@@ -102,6 +104,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
+	/* {USB_DEVICE(0x15a9, 0x0002)}, * Also SparkLAN WL-682 with 3887 */
 	{USB_DEVICE(0x1668, 0x1050)},	/* Actiontec 802UIG-1 */
 	{USB_DEVICE(0x1740, 0x1000)},	/* Senao NUB-350 */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */


