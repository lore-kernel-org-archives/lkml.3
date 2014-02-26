Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaBZSe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:34:28 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56921 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaBZSeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:34:25 -0500
From: Jan Vcelak <jv@fcelda.cz>
To: crope@iki.fi, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] [media] rtl28xxu: add chipset version comments into device list
Date: Wed, 26 Feb 2014 19:33:40 +0100
Message-Id: <1393439620-7993-2-git-send-email-jv@fcelda.cz>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393439620-7993-1-git-send-email-jv@fcelda.cz>
References: <530DB488.9030901@iki.fi>
 <1393439620-7993-1-git-send-email-jv@fcelda.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index b9eb662..ab1deac 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1382,6 +1382,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 };
 
 static const struct usb_device_id rtl28xxu_id_table[] = {
+	/* RTL2831U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
 		&rtl2831u_props, "Realtek RTL2831U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT,
@@ -1389,6 +1390,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2,
 		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
 
+	/* RTL2832U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2832,
 		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
@@ -1432,6 +1434,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 
+	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
 	{ }
-- 
1.8.5.3

