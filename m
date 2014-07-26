Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaGZTgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:36:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaGZTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 003/109] media: gspca_pac7302: Add new usb-id for Genius i-Look 317
Date: Sat, 26 Jul 2014 12:01:25 -0700
Message-Id: <20140726190223.936329141@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 242841d3d71191348f98310e2d2001e1001d8630 upstream.

Tested-and-reported-by: yullaw <yullaw@mageia.cz>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/pac7302.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -928,6 +928,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x093a, 0x2620)},
 	{USB_DEVICE(0x093a, 0x2621)},
 	{USB_DEVICE(0x093a, 0x2622), .driver_info = FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2623), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2625)},
 	{USB_DEVICE(0x093a, 0x2626)},


