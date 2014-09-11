Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaIKMn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:43:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51648 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755440AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hans de Goede" <hdegoede@redhat.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.843474095@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 008/131] [media] gspca_pac7302: Add new usb-id for
 Genius i-Look 317
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 242841d3d71191348f98310e2d2001e1001d8630 upstream.

Tested-and-reported-by: yullaw <yullaw@mageia.cz>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/gspca/pac7302.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -1190,6 +1190,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x093a, 0x2620)},
 	{USB_DEVICE(0x093a, 0x2621)},
 	{USB_DEVICE(0x093a, 0x2622), .driver_info = FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2623), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2625)},
 	{USB_DEVICE(0x093a, 0x2626)},

