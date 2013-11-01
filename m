Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3KAVoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3KAVoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:44:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Parkhomenko <ra85551@gmail.com>
Subject: [ 31/32] USB: serial: option: add support for Inovia SEW858 device
Date: Fri,  1 Nov 2013 14:43:42 -0700
Message-Id: <20131101214321.208419633@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f4c19b8e165cff1a6607c21f8809441d61cab7ec upstream.

This patch adds the device id for the Inovia SEW858 device to the option driver.

Reported-by: Pavel Parkhomenko <ra85551@gmail.com>
Tested-by: Pavel Parkhomenko <ra85551@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -457,6 +457,10 @@ static void option_instat_callback(struc
 #define CHANGHONG_VENDOR_ID			0x2077
 #define CHANGHONG_PRODUCT_CH690			0x7001
 
+/* Inovia */
+#define INOVIA_VENDOR_ID			0x20a6
+#define INOVIA_SEW858				0x1105
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1367,6 +1371,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) }, /* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) }, /* D-Link DWM-156/C1 */
+	{ USB_DEVICE(INOVIA_VENDOR_ID, INOVIA_SEW858) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


