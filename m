Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3CATqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3CATqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Klimov <klimov.linux@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Jiri Kosina <jkosina@suse.cz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 46/46] [hid] usb hid quirks for Masterkit MA901 usb radio
Date: Fri,  1 Mar 2013 11:45:34 -0800
Message-Id: <20130301194437.089273060@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <klimov.linux@gmail.com>

commit 0322bd3980b3ebf7dde8474e22614cb443d6479a upstream.

Don't let Masterkit MA901 USB radio be handled by usb hid drivers.
This device will be handled by radio-ma901.c driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1922,6 +1922,7 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MASTERKIT, USB_DEVICE_ID_MASTERKIT_MA901RADIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -520,6 +520,9 @@
 #define USB_VENDOR_ID_MADCATZ		0x0738
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 
+#define USB_VENDOR_ID_MASTERKIT			0x16c0
+#define USB_DEVICE_ID_MASTERKIT_MA901RADIO	0x05df
+
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
 #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a


