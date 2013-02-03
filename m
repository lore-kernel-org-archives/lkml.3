Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3BCPTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:19:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab3BCOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:34 -0500
Message-Id: <20130203144647.239808561@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Quentin.Li" <snowmanli88@163.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 036/128] USB: option: Add new MEDIATEK PID support
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Quentin.Li" <snowmanli88@163.com>

commit 94a85b633829b946eef53fc1825d526312fb856f upstream.

In option.c, add some new MEDIATEK PIDs support for MEDIATEK new products. This
is a MEDIATEK inc. release patch.

Signed-off-by: Quentin.Li <snowmanli88@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e6f87b7..2e8c1c8 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -429,9 +429,12 @@ static void option_instat_callback(struct urb *urb);
 #define MEDIATEK_VENDOR_ID			0x0e8d
 #define MEDIATEK_PRODUCT_DC_1COM		0x00a0
 #define MEDIATEK_PRODUCT_DC_4COM		0x00a5
+#define MEDIATEK_PRODUCT_DC_4COM2		0x00a7
 #define MEDIATEK_PRODUCT_DC_5COM		0x00a4
 #define MEDIATEK_PRODUCT_7208_1COM		0x7101
 #define MEDIATEK_PRODUCT_7208_2COM		0x7102
+#define MEDIATEK_PRODUCT_7103_2COM		0x7103
+#define MEDIATEK_PRODUCT_7106_2COM		0x7106
 #define MEDIATEK_PRODUCT_FP_1COM		0x0003
 #define MEDIATEK_PRODUCT_FP_2COM		0x0023
 #define MEDIATEK_PRODUCT_FPDC_1COM		0x0043
@@ -1294,6 +1297,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FP_2COM, 0x0a, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FPDC_1COM, 0x0a, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FPDC_2COM, 0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_7103_2COM, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_7106_2COM, 0x02, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ } /* Terminating entry */
 };


