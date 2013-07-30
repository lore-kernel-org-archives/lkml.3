Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab3G3Jfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:35:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab3G3JeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:34:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 101/106] usb: serial: option: add Olivetti Olicard 200
Date: Tue, 30 Jul 2013 10:32:00 +0100
Message-Id: <1375176725-5825-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 4cf76df06ecc852633ed927d91e01c83c33bc331 upstream.

Speaks AT on interfaces 5 (command & PPP) and 3 (secondary), other
interface protocols are unknown.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a93b219..7776198 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -347,6 +347,7 @@ static void option_instat_callback(struct urb *urb);
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
+#define OLIVETTI_PRODUCT_OLICARD200		0xc005
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -1281,6 +1282,7 @@ static const struct usb_device_id option_ids[] = {
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
-- 
1.8.3.2

