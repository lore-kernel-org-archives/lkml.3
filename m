Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3AXDhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:37:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3AXDac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Quentin.Li" <snowmanli88@163.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 46/74] USB: option: Add new MEDIATEK PID support
Date: Thu, 24 Jan 2013 01:26:58 -0200
Message-Id: <1358998046-613-47-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Quentin.Li" <snowmanli88@163.com>

commit 94a85b633829b946eef53fc1825d526312fb856f upstream.

In option.c, add some new MEDIATEK PIDs support for MEDIATEK new products. This
is a MEDIATEK inc. release patch.

Signed-off-by: Quentin.Li <snowmanli88@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2896ae5..48d3984 100644
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
-- 
1.7.9.5

