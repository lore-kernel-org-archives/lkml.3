Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3BCPRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:17:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34237 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab3BCOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:45 -0500
Message-Id: <20130203144647.520350549@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dzianis Kahanovich <mahatma@bspu.unibel.by>,
        Denis Kaganovich <mahatma@eu.by>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 039/128] USB: option: add Nexpring NP10T terminal id
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzianis Kahanovich <mahatma@bspu.unibel.by>

commit ad86e58661b38b279b7519d4e49c7a19dc1654bb upstream.

Hyundai Petatel Inc. Nexpring NP10T terminal (EV-DO rev.A USB modem) ID

Signed-off-by: Denis Kaganovich <mahatma@eu.by>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2c75d50..478adcf 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -445,6 +445,10 @@ static void option_instat_callback(struct urb *urb);
 #define CELLIENT_VENDOR_ID			0x2692
 #define CELLIENT_PRODUCT_MEN200			0x9005
 
+/* Hyundai Petatel Inc. products */
+#define PETATEL_VENDOR_ID			0x1ff4
+#define PETATEL_PRODUCT_NP10T			0x600e
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1306,6 +1310,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
+	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


