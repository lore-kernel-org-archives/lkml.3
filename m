Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3APAGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:06:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:43130 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab3AOWd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Quentin.Li" <snowmanli88@163.com>
Subject: [ 159/221] USB: option: Add new MEDIATEK PID support
Date: Tue, 15 Jan 2013 10:51:26 -0800
Message-Id: <20130115185009.537574235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Quentin.Li" <snowmanli88@163.com>

commit 94a85b633829b946eef53fc1825d526312fb856f upstream.

In option.c, add some new MEDIATEK PIDs support for MEDIATEK new products. This
is a MEDIATEK inc. release patch.

Signed-off-by: Quentin.Li <snowmanli88@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -430,9 +430,12 @@ static void option_instat_callback(struc
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
@@ -1300,6 +1303,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FP_2COM, 0x0a, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FPDC_1COM, 0x0a, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FPDC_2COM, 0x0a, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_7103_2COM, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_7106_2COM, 0x02, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
 	{ } /* Terminating entry */


