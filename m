Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3CREma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:42:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33581 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab3CREam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:42 -0400
Message-Id: <20130318042148.991204983@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Christian Schmiedl <christian.schmiedl@gemalto.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 49/82] USB: added support for Cinterions products AH6 and PLS8
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Schmiedl <christian.schmiedl@gemalto.com>

commit 1941138e1c024ecb5bd797d414928d3eb94d8662 upstream.

add support for Cinterion's products AH6 and PLS8 by adding Product IDs
and USB_DEVICE tuples.

Signed-off-by: Christian Schmiedl <christian.schmiedl@gemalto.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -341,6 +341,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
+#define CINTERION_PRODUCT_AH6			0x0055
+#define CINTERION_PRODUCT_PLS8			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1261,6 +1263,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AH6) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLS8) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },


