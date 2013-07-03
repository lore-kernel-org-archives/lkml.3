Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab3GCS7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:59:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab3GCSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:47 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iVLWc46vPo0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hhIJcn8xpH0A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=jEp0ucaQiEUA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184045.624221554@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [006/141] USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0006-USB-option-add-device-IDs-for-Dell-5804-Novatel-E371.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

[ Upstream commit 49c6e370dd6400b84897c4100095089b5c13a061 ]

A rebranded Novatel E371 for AT&T's LTE bands.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ff62810..4fa928d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -197,6 +197,7 @@ static void option_instat_callback(struct urb *urb);
 
 #define DELL_PRODUCT_5800_MINICARD_VZW		0x8195  /* Novatel E362 */
 #define DELL_PRODUCT_5800_V2_MINICARD_VZW	0x8196  /* Novatel E362 */
+#define DELL_PRODUCT_5804_MINICARD_ATT		0x819b  /* Novatel E371 */
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
@@ -740,6 +741,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_MINICARD_VZW, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_V2_MINICARD_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5804_MINICARD_ATT, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
-- 
1.7.10.4


