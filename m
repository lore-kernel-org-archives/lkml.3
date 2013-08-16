Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3HPWjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3HPWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 038/133] usb: serial: option: add Olivetti Olicard 200
Date: Fri, 16 Aug 2013 15:33:00 -0700
Message-Id: <1376692475-28413-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 4cf76df06ecc852633ed927d91e01c83c33bc331 upstream.

Speaks AT on interfaces 5 (command & PPP) and 3 (secondary), other
interface protocols are unknown.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 1c8733a..d4099bb 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -341,6 +341,7 @@ static void option_instat_callback(struct urb *urb);
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
 #define OLIVETTI_PRODUCT_OLICARD145		0xc003
+#define OLIVETTI_PRODUCT_OLICARD200		0xc005
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -1259,6 +1260,7 @@ static const struct usb_device_id option_ids[] = {
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD200) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
-- 
1.8.1.2

