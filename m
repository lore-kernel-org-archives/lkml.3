Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3JUJKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:10:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035Ab3JUIwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Joerg Kalisch" <the_force@gmx.de>,
        "Christian Lamparter" <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.882356935@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 091/149] p54usb: add USB ID for Corega WLUSB2GTST USB
 adapter
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 1e43692cdb7cc445d6347d8a5207d9cef0c71434 upstream.

Added USB ID for Corega WLUSB2GTST USB adapter.

Reported-by: Joerg Kalisch <the_force@gmx.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/p54/p54usb.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -83,6 +83,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x07aa, 0x0020)},	/* Corega WLUSB2GTST USB */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */

