Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaFWIzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55513 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 060/111] [media] rtl28xxu: add 15f4:0131 Astrometa DVB-T2
Date: Mon, 23 Jun 2014 10:31:35 +0200
Message-Id: <d5b6059bcccdb85a6e42dc1fa73fe7ee33e47316.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antti Palosaari <crope@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8fdd33b1bcf32ed9cf21aa9e4a66fa68c6beaa1b upstream.

Components are RTL2832P + R828D + MN88472.
Currently support only DVB-T as there is no driver for MN88472 demod.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c0cd0848631b..b51991756b71 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1388,6 +1388,9 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+
+	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
+		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
2.0.0

