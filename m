Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366Ab3GZVNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:13:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3GZUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dcbw@redhat.com>
Subject: [ 48/59] usb: serial: option: add Olivetti Olicard 200
Date: Fri, 26 Jul 2013 13:53:12 -0700
Message-Id: <20130726205018.970568589@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 4cf76df06ecc852633ed927d91e01c83c33bc331 upstream.

Speaks AT on interfaces 5 (command & PPP) and 3 (secondary), other
interface protocols are unknown.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -347,6 +347,7 @@ static void option_instat_callback(struc
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
+#define OLIVETTI_PRODUCT_OLICARD200		0xc005
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -1279,6 +1280,7 @@ static const struct usb_device_id option
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/


