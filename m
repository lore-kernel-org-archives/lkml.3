Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaBZAa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:30:57 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48007 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaBZAa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:30:56 -0500
From: Jan Vcelak <jv@fcelda.cz>
To: crope@iki.fi, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
Date: Wed, 26 Feb 2014 01:30:45 +0100
Message-Id: <1393374645-4568-1-git-send-email-jv@fcelda.cz>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]

The USB dongle uses RTL2832U demodulator and FC0012 tuner.

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
---

The patch adds support for the Genius TVGo DVB-T03 USB dongle.

 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fda5c64..bb051c9 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1432,6 +1432,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
+		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.8.5.3

