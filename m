Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaFWIw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55536 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Vcelak <jv@fcelda.cz>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 070/111] rtl28xxu: add chipset version comments into device list
Date: Mon, 23 Jun 2014 10:31:45 +0200
Message-Id: <be7a9c317efde7bad3198f789d37df8ab1ed59db.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Vcelak <jv@fcelda.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 60aa4c6fa5723af72cff154a5cd33ac4995d1e0a upstream.

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 62cb601eed3f..ad85db6c87a5 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1343,6 +1343,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 };
 
 static const struct usb_device_id rtl28xxu_id_table[] = {
+	/* RTL2831U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
 		&rtl2831u_props, "Realtek RTL2831U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT,
@@ -1350,6 +1351,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2,
 		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
 
+	/* RTL2832U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2832,
 		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
@@ -1395,6 +1397,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 
+	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
 	{ }
-- 
2.0.0

